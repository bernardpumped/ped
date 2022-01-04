/*
 *     Copyright (c) 2022.
 *     This file is part of Pumped End Device.
 *
 *     Pumped End Device is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     Pumped End Device is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with Pumped End Device.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:convert';

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/updatable_address_components.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/response-parser/operating_hours_response_parse_utils.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_address_details_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_fuel_quote_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_fuel_station_detail_type.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_fuel_station_details_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_operating_time_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_phone_number_result.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationUpdateMergeUtil {
  static const _TAG = 'FuelStationUpdateMergeUtil';

  void mergeFuelStationUpdateResult(
      final FuelStation fuelStation, final UpdateFuelStationDetailsResult updateFuelStationDetailsResult) {
    LogUtil.debug(_TAG, 'updateType : ${updateFuelStationDetailsResult.updateFuelStationDetailType}');
    switch (updateFuelStationDetailsResult.updateFuelStationDetailType) {
      case UpdateFuelStationDetailType.FUEL_PRICE:
        _mergeUpdateFuelQuotesResponse(fuelStation, updateFuelStationDetailsResult as UpdateFuelQuoteResult);
        break;
      case UpdateFuelStationDetailType.FUEL_STATION_FEATURE:
        LogUtil.debug(_TAG, 'Fuel Station feature update merge is driven by backend and is not implemented here.');
        break;
      case UpdateFuelStationDetailType.OPERATING_HOURS:
        _mergeUpdateOperatingTimeResult(fuelStation, updateFuelStationDetailsResult as UpdateOperatingTimeResult);
        break;
      case UpdateFuelStationDetailType.PHONE_NUMBER:
        _mergerUpdatePhoneNumberResult(fuelStation, updateFuelStationDetailsResult as UpdatePhoneNumberResult);
        break;
      case UpdateFuelStationDetailType.ADDRESS_DETAILS:
        _mergeUpdateAddressDetailsResult(fuelStation, updateFuelStationDetailsResult as UpdateAddressDetailsResult);
        break;
      case UpdateFuelStationDetailType.SUGGEST_EDIT:
        LogUtil.debug(_TAG, 'Suggest edit merge does not change anything on device. Skipping');
        break;
    }
  }

  void _mergeUpdateFuelQuotesResponse(
      final FuelStation fuelStation, final UpdateFuelQuoteResult updateFuelQuoteResult) {
    if (updateFuelQuoteResult.isUpdateSuccessful) {
      LogUtil.debug(_TAG, 'Update is successful. Merging.');
      final Map<String, FuelQuote> fuelTypeFuelQuoteMap = _getFuelTypeFuelQuoteMap(fuelStation);
      updateFuelQuoteResult.originalValues.forEach((fuelType, originalQuoteValue) {
        LogUtil.debug(_TAG, 'Merging for fuelType : $fuelType');
        final double updateValue = updateFuelQuoteResult.updateValues[fuelType];
        final List<dynamic> recordExceptions = updateFuelQuoteResult.recordLevelExceptionCodes[fuelType];
        if (recordExceptions == null || recordExceptions.length == 0) {
          final FuelQuote originalFuelQuote =
              _getOriginalFuelQuote(fuelTypeFuelQuoteMap, fuelType, fuelStation.stationId);
          _updateQuoteValues(originalFuelQuote, updateValue, updateFuelQuoteResult.updateEpoch);
        }
      });
    } else {
      LogUtil.debug(_TAG, 'updateFuelQuoteResult is not successful. Not merging the response with on device data');
    }
  }

  void _updateQuoteValues(final FuelQuote originalFuelQuote, final double updateValue, final int updateEpoch) {
    originalFuelQuote.quoteValue = updateValue;
    originalFuelQuote.publishDate = (updateEpoch / 1000).floor();
    originalFuelQuote.fuelQuoteSource = 'C';
  }

  FuelQuote _getOriginalFuelQuote(
      final Map<String, FuelQuote> fuelTypeFuelQuoteMap, final String fuelType, final int fuelStationId) {
    FuelQuote originalFuelQuote = fuelTypeFuelQuoteMap[fuelType];
    if (originalFuelQuote == null) {
      originalFuelQuote =
          new FuelQuote(fuelStationId: fuelStationId, fuelType: fuelType, quoteValue: null, publishDate: null);
      fuelTypeFuelQuoteMap[fuelType] = originalFuelQuote;
      // Do not have the quoteId. Need to check if it breaks anything.
    }
    return originalFuelQuote;
  }

  Map<String, FuelQuote> _getFuelTypeFuelQuoteMap(final FuelStation fuelStation) {
    Map<String, FuelQuote> fuelTypeFuelQuoteMap = fuelStation.fuelTypeFuelQuoteMap;
    if (fuelTypeFuelQuoteMap == null) {
      fuelTypeFuelQuoteMap = {};
      fuelStation.fuelTypeFuelQuoteMap = fuelTypeFuelQuoteMap;
    }
    return fuelTypeFuelQuoteMap;
  }

  void _mergeUpdateOperatingTimeResult(
      final FuelStation fuelStation, final UpdateOperatingTimeResult updateOperatingHrsResult) {
    if (updateOperatingHrsResult.isUpdateSuccessful) {
      final Map<String, dynamic> updateValues = updateOperatingHrsResult.updateValues;
      updateOperatingHrsResult.originalValues.forEach((dayOfWeek, originalOpHrsJson) {
        var updatedOperatingHrsJson = updateValues[dayOfWeek];
        final OperatingHours updatedOperatingHour =
            updatedOperatingHrsJson != null ? OperatingHours.fromJson(jsonDecode(updatedOperatingHrsJson)) : null;
        updatedOperatingHour.publishDate = DateTime.fromMillisecondsSinceEpoch(updateOperatingHrsResult.updateEpoch);
        updatedOperatingHour.operatingTimeSource = 'C';
        final List<dynamic> recordLevelExceptionCodes = updateOperatingHrsResult.recordLevelExceptionCodes[dayOfWeek];
        if (recordLevelExceptionCodes == null || recordLevelExceptionCodes.length == 0) {
          fuelStation.fuelStationOperatingHrs.updateOperatingHoursForDay(dayOfWeek, updatedOperatingHour);
        }
      });
      final String dayOfWeek = DateTimeUtils.weekDayIntToShortName[DateTime.now().weekday];
      fuelStation.operatingHours = fuelStation.fuelStationOperatingHrs.getOperatingHoursForDay(dayOfWeek);
      fuelStation.status = OperatingHoursResponseParseUtils.getStatus(fuelStation.operatingHours);
    } else {
      LogUtil.debug(_TAG, 'updateOperatingHrsResult is not successful. Not merging the response with on device data');
    }
  }

  void _mergeUpdateAddressDetailsResult(
      final FuelStation fuelStation, final UpdateAddressDetailsResult updateAddressDetailsResult) {
    if (updateAddressDetailsResult.isUpdateSuccessful) {
      final FuelStationAddress fuelStationAddress = fuelStation.fuelStationAddress;
      updateAddressDetailsResult.addressComponentNewValue.forEach((addressComponent, newValue) {
        LogUtil.debug(_TAG, '$addressComponent $newValue');
        String updateResult = updateAddressDetailsResult.addressComponentUpdateStatus != null
            ? updateAddressDetailsResult.addressComponentUpdateStatus[addressComponent]
            : null;
        bool successfulUpdate = DataUtils.isBlank(updateResult);
        if (successfulUpdate) {
          switch (addressComponent) {
            case UpdatableAddressComponents.ADDRESS_LINE:
              fuelStationAddress.addressLine1 = newValue;
              LogUtil.debug(_TAG, 'Updated addressLine $newValue');
              break;
            case UpdatableAddressComponents.LOCALITY:
              fuelStationAddress.locality = newValue;
              break;
            case UpdatableAddressComponents.REGION:
              fuelStationAddress.region = newValue;
              break;
            case UpdatableAddressComponents.STATION_NAME:
              fuelStationAddress.contactName = newValue;
              fuelStation.fuelStationName = newValue;
              break;
            case UpdatableAddressComponents.STATE:
              fuelStationAddress.state = newValue;
              break;
            case UpdatableAddressComponents.ZIP:
              fuelStationAddress.zip = newValue;
              break;
            default:
              break;
          }
        }
      });
    } else {
      LogUtil.debug(_TAG, 'updateAddressDetailsResult is not successful. Not merging the response with on device data');
    }
  }

  void _mergerUpdatePhoneNumberResult(
      final FuelStation fuelStation, final UpdatePhoneNumberResult updatePhoneNumberResult) {
    if (updatePhoneNumberResult.isUpdateSuccessful) {
      final FuelStationAddress fuelStationAddress = fuelStation.fuelStationAddress;
      updatePhoneNumberResult.phoneTypeNewValueMap.forEach((phoneType, newValue) {
        final bool successFulUpdate = updatePhoneNumberResult.phoneTypeUpdateStatusMap != null
            ? (updatePhoneNumberResult.phoneTypeUpdateStatusMap[phoneType] != null
                ? updatePhoneNumberResult.phoneTypeUpdateStatusMap[phoneType]
                : true)
            : true;
        if (successFulUpdate) {
          if (phoneType == UpdatableAddressComponents.PHONE1) {
            fuelStationAddress.phone1 = newValue;
          } else if (phoneType == UpdatableAddressComponents.PHONE2) {
            fuelStationAddress.phone2 = newValue;
          } else {
            LogUtil.debug(_TAG, 'Unknown phoneType $phoneType');
          }
        } else {
          LogUtil.debug(_TAG, 'Update was not successful for Phone Type $phoneType');
        }
      });
    } else {
      LogUtil.debug(_TAG, 'updatePhoneNumberResult is not successful. Not merging the response with on device data');
    }
  }
}
