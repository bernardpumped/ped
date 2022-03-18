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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/get_fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/model/request/get_fuel_station_operating_hrs_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/model/response/get_fuel_station_operating_hrs_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/operating_time_range.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/response-parser/get_fuel_station_operating_hrs_response_parser.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/favorite_fuel_station_bookmark.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/horizontal_scroll_list_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/operating_hours_source_citation.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/rate_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/update_button_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/widgets/directions_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/widgets/phone_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

class OverviewTabWidget extends StatefulWidget {
  final FuelStation _fuelStation;
  final Function onUpdateResult;

  const OverviewTabWidget(this._fuelStation, this.onUpdateResult, {Key? key}) : super(key: key);

  @override
  _OverviewTabWidgetState createState() => _OverviewTabWidgetState();
}

class _OverviewTabWidgetState extends State<OverviewTabWidget> {
  static const _tag = 'OverviewTabWidget';
  Future<GetFuelStationOperatingHrsResponse>? _operatingHrsResponseFuture;

  static const Color _secondaryIconColor = FontsAndColors.pumpedSecondaryIconColor;
  static const Color _nonActionIconColor = FontsAndColors.pumpedNonActionableIconColor;

  @override
  void initState() {
    super.initState();
    _operatingHrsResponseFuture = _getFuelStationOperatingHrsFuture();
  }

  Future<GetFuelStationOperatingHrsResponse> _getFuelStationOperatingHrsFuture() async {
    try {
      final GetFuelStationOperatingHrsRequest request = GetFuelStationOperatingHrsRequest(
          requestUuid: const Uuid().v1(),
          fuelStationId: widget._fuelStation.stationId,
          fuelStationSource: widget._fuelStation.getFuelStationSource());
      return await GetFuelStationOperatingHrs(GetFuelStationOperatingHrsResponseParser()).execute(request);
    } on Exception catch (e, s) {
      LogUtil.debug(_tag, 'Exception occurred while calling GetFuelStationOperatingHrsNew.execute $s');
      return GetFuelStationOperatingHrsResponse(
          'CALL-EXCEPTION', s.toString(), {}, DateTime.now().millisecondsSinceEpoch, null);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final FuelStation fuelStation = widget._fuelStation;
    final FuelStationAddress fuelStationAddress = fuelStation.fuelStationAddress;
    final bool phonePresent = fuelStationAddress.phone1 != null || fuelStationAddress.phone2 != null;
    bool imgUrlsPresent = fuelStation.imgUrls != null && fuelStation.imgUrls!.isNotEmpty;
    return Container(
        decoration: const BoxDecoration(color: FontsAndColors.pumpedBoxDecorationColor),
        child: Column(children: <Widget>[
          imgUrlsPresent
              ? Container(
                  margin: const EdgeInsets.only(top: 7, bottom: 7), child: HorizontalScrollListWidget(fuelStation.imgUrls!))
              : const SizedBox(width: 0),
          imgUrlsPresent ? const Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0) : const SizedBox(width: 0),
          _getActionBar(fuelStation),
          const Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0),
          _getFuelStationAddressWidget(fuelStationAddress),
          const Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0),
          _buildOperatingHourWidget(fuelStation),
          const Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0),
          phonePresent ? _getPhoneNumberWidget(fuelStationAddress) : const SizedBox(width: 0),
          phonePresent ? const Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0) : const SizedBox(width: 0),
          UpdateButtonWidget(fuelStation,
              expandSuggestEdit: true, updateFuelStationDetailsScreenForChange: widget.onUpdateResult)
        ]));
  }

  Widget _getActionBar(final FuelStation fuelStation) {
    final String? phone = DataUtils.isNotBlank(widget._fuelStation.fuelStationAddress.phone1)
        ? fuelStation.fuelStationAddress.phone1
        : fuelStation.fuelStationAddress.phone2;
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 15),
                  child: DirectionsWidget(
                      fuelStation.fuelStationAddress.latitude, fuelStation.fuelStationAddress.longitude, getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName))),
              (phone != null)
                  ? Padding(padding: const EdgeInsets.only(left: 15, right: 15), child: PhoneWidget(phone))
                  : const SizedBox(width: 0),
              Padding(padding: const EdgeInsets.only(left: 20, right: 15), child: RateWidget(fuelStation.fuelStationAddress)),
              Padding(padding: const EdgeInsets.only(left: 20, right: 15), child: FavoriteFuelStationBookmark(fuelStation))
            ]));
  }

  static const _addressDetailsIcon = Icon(IconData(IconCodes.addressDetailsIconCode, fontFamily: 'MaterialIcons',
      matchTextDirection: true), color: _nonActionIconColor, size: 30);

  Container _getFuelStationAddressWidget(final FuelStationAddress fuelStationAddress) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            // dense: true,
            leading: _addressDetailsIcon,
            title: _getFuelStationAddress(fuelStationAddress)));
  }

  static const _phoneIcon = Icon(IconData(IconCodes.phoneIconCode, fontFamily: 'MaterialIcons',
      matchTextDirection: true), color: _nonActionIconColor, size: 30);

  Widget _getPhoneNumberWidget(final FuelStationAddress fuelStationAddress) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            leading: _phoneIcon,
            title: _getPhone(fuelStationAddress)));
  }

  bool _operatingHoursExpanded = false;

  static const _operatingTimeIcon = Icon(IconData(IconCodes.operatingTimeIconCode, fontFamily: 'MaterialIcons',
      matchTextDirection: true), color: _nonActionIconColor, size: 30);

  Widget _buildOperatingHourWidget(final FuelStation fuelStation) {
    return FutureBuilder<GetFuelStationOperatingHrsResponse>(
        future: _operatingHrsResponseFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error ${snapshot.error.toString()}');
            return const Text('Error Loading');
          } else if (snapshot.hasData) {
            final GetFuelStationOperatingHrsResponse data = snapshot.data!;
            if (data.responseCode != 'SUCCESS') {
              return const ListTile(title: Text('Error Loading', style: TextStyle(color: Colors.red)));
            } else {
              fuelStation.fuelStationOperatingHrs = data.fuelStationOperatingHrs;
              final FuelStationOperatingHrs? fuelStationOperatingHrs = data.fuelStationOperatingHrs;
              List<OperatingHours>? weeklyOperatingHrs = fuelStationOperatingHrs?.weeklyOperatingHrs;
              if (weeklyOperatingHrs != null && weeklyOperatingHrs.isNotEmpty) {
                final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
                return Theme(
                    data: theme,
                    child: Container(
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ExpansionTile(
                            initiallyExpanded: false,
                            leading: _operatingTimeIcon,
                            title: _getOpenClosed(weeklyOperatingHrs),
                            key: const PageStorageKey<String>("open-close"),
                            trailing: ExpandIcon(
                                isExpanded: _operatingHoursExpanded,
                                color: _secondaryIconColor,
                                onPressed: (bool value) {
                                  setState(() {});
                                }),
                            children: _buildColumnContent(weeklyOperatingHrs),
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _operatingHoursExpanded = expanded;
                              });
                            })));
              } else {
                return const SizedBox(height: 0);
              }
            }
          } else {
            return const ListTile(leading: _operatingTimeIcon, title: Text('Loading...'));
          }
        });
  }

  List<Widget> _buildColumnContent(final List<OperatingHours> weeklyOperatingHrs) {
    final List<Widget> columnContent = [];
    for (final OperatingHours dailyOperatingHrs in weeklyOperatingHrs) {
      final String weekDay = DateTimeUtils.weekDayShortToLongName[dailyOperatingHrs.dayOfWeek]!;
      final String content1 = weekDay;
      String content2 = '';
      if (DataUtils.isNotBlank(dailyOperatingHrs.operatingTimeRange)) {
        switch (dailyOperatingHrs.operatingTimeRange) {
          case OperatingTimeRange.alwaysOpen:
            content2 = 'Open 24 Hours';
            break;
          case OperatingTimeRange.closed:
            content2 = 'Closed';
            break;
          default:
            content2 = sprintf('%02d:%02d - %02d:%02d', [
              dailyOperatingHrs.openingHrs,
              dailyOperatingHrs.openingMins,
              dailyOperatingHrs.closingHrs,
              dailyOperatingHrs.closingMins
            ]);
            break;
        }
      } else {
        content2 = '- - -';
      }
      columnContent.add(Padding(
          padding: const EdgeInsets.only(left: 40, top: 10, bottom: 10, right: 40),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Expanded(
                flex: 4,
                child: Text(content1,
                    textAlign: TextAlign.start, style: const TextStyle(fontSize: 14.0, color: Colors.black87))),
            Expanded(
                flex: 6,
                child: Text(content2,
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 14.0, color: Colors.black87))),
            Expanded(flex: 1, child: _getOperatingHoursSourceCitation(dailyOperatingHrs))
          ])));
    }
    return columnContent;
  }

  GestureDetector _getOperatingHoursSourceCitation(final OperatingHours operatingHours) {
    final Icon icon = (operatingHours.operatingTimeSource == 'G' || operatingHours.operatingTimeSource == 'F')
        ? PumpedIcons.googleSourceIconBlack54Size30
        : PumpedIcons.crowdSourceIconBlack54Size30;
    return GestureDetector(
        onTap: () {
          showCupertinoDialog(
              context: context,
              builder: (context) => OperatingHoursSourceCitation(operatingHours, widget._fuelStation));
        },
        child: icon);
  }

  Widget _getFuelStationAddress(final FuelStationAddress fuelStationAddress) {
    return Text(
        '${fuelStationAddress.addressLine1}, ${fuelStationAddress.locality} '
        '${fuelStationAddress.state} ${fuelStationAddress.zip}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87, fontFamily: 'SF-Pro-Display'));
  }

  static const TextStyle _redStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red);
  static const TextStyle _blackStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87);

  Widget _getOpenClosed(final List<OperatingHours> weeklyOperatingHrs) {
    final String currentWeekDay = DateTimeUtils.weekDayIntToShortName[DateTime.now().weekday]!;
    final OperatingHours? currentDayOperatingHrs = _getOperatingHrsForDay(weeklyOperatingHrs, currentWeekDay);
    int? currentDayOpeningHrs = currentDayOperatingHrs?.openingHrs;
    int? currentDayOpeningMins = currentDayOperatingHrs?.openingMins;
    int? currentDayClosingHrs = currentDayOperatingHrs?.closingHrs;
    int? currentDayClosingMins = currentDayOperatingHrs?.closingMins;
    if (currentDayOperatingHrs != null && OperatingTimeRange.alwaysOpen == currentDayOperatingHrs.operatingTimeRange) {
      currentDayOpeningHrs = 0;
      currentDayOpeningMins = 0;
      currentDayClosingHrs = 23;
      currentDayClosingMins = 59;
    }
    int currentHours = DateTime.now().hour;
    int currentMin = DateTime.now().minute;
    String currentStatus;
    String nextEventStatus;
    TextStyle currentStatusStyle;
    TextStyle nextEventStyle;

    if ((currentDayOpeningHrs != null &&
            currentDayOpeningMins != null &&
            currentDayClosingHrs != null &&
            currentDayClosingMins != null) &&
        (currentHours > currentDayOpeningHrs && currentHours < currentDayClosingHrs ||
            currentHours == currentDayOpeningHrs && currentHours < currentDayClosingHrs ||
            currentHours == currentDayClosingHrs && currentMin < currentDayClosingMins)) {
      if (OperatingTimeRange.alwaysOpen == currentDayOperatingHrs?.operatingTimeRange) {
        currentStatus = 'Open 24 Hours';
        currentStatusStyle = _blackStyle;
        nextEventStatus = '';
        nextEventStyle = _blackStyle;
      } else {
        currentStatus = 'Now Open. ';
        currentStatusStyle = _blackStyle;
        nextEventStatus = 'Closes at $currentDayClosingHrs: $currentDayClosingMins';
        nextEventStyle = _redStyle;
      }
    } else {
      currentStatus = 'Closed. ';
      currentStatusStyle = _redStyle;
      final OperatingHours? nextDayOperatingHrs = _getOperatingHrsForNextDay(weeklyOperatingHrs, currentWeekDay);
      if (nextDayOperatingHrs != null) {
        int? nextDayOpeningHrs = nextDayOperatingHrs.openingHrs;
        int? nextDayOpeningMins = nextDayOperatingHrs.openingMins;
        if (currentDayOperatingHrs != null &&
            OperatingTimeRange.alwaysOpen == currentDayOperatingHrs.operatingTimeRange) {
          nextDayOpeningHrs = 0;
          nextDayOpeningMins = 0;
        }
        if (nextDayOpeningHrs != null && nextDayOpeningMins != null) {
          nextEventStatus = sprintf('Opens %s %02d:%02d',
              [nextDayOperatingHrs.dayOfWeek, nextDayOperatingHrs.openingHrs, nextDayOperatingHrs.openingMins]);
        } else {
          nextEventStatus = 'Opens ${nextDayOperatingHrs.dayOfWeek}';
        }
        nextEventStyle = _blackStyle;
      } else {
        nextEventStatus = 'Not known';
        nextEventStyle = _redStyle;
      }
    }
    return Container(
        child: !_operatingHoursExpanded
            ? RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  TextSpan(text: currentStatus, style: currentStatusStyle),
                  TextSpan(text: nextEventStatus, style: nextEventStyle)
                ]))
            : Text(currentStatus, style: currentStatusStyle));
  }

  Widget _getPhone(final FuelStationAddress fuelStationAddress) {
    final String? phone = fuelStationAddress.phone1 ?? fuelStationAddress.phone2;
    if (phone != null) {
      return Text(phone, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87));
    } else {
      return const SizedBox(width: 0);
    }
  }

  OperatingHours? _getOperatingHrsForDay(final List<OperatingHours> weeklyOperatingHrs, final String? currentWeekDay) {
    for (final OperatingHours operatingHours in weeklyOperatingHrs) {
      if (operatingHours.dayOfWeek == currentWeekDay) {
        return operatingHours;
      }
    }
    return null;
  }

  OperatingHours? _getOperatingHrsForNextDay(final List<OperatingHours> weeklyOperatingHrs, final String currentWeekDay) {
    String? day = currentWeekDay;
    OperatingHours? operatingHours;
    do {
      day = DateTimeUtils.getNextDay(day);
      operatingHours = _getOperatingHrsForDay(weeklyOperatingHrs, day);
    } while (day != currentWeekDay && operatingHours == null);
    return operatingHours;
  }
}
