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

import 'package:pumped_end_device/data/local/dao2/market_region_zone_config_dao.dart';
import 'package:pumped_end_device/data/local/dao2/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/user-interface/settings/model/dropdown_values.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/quote_sort_order.dart';
import 'package:pumped_end_device/util/log_util.dart';

class SettingsService {
  static const _tag = 'SettingsService';

  Future<dynamic> insertSettings(final num searchRadius, final num numSearchResults, final FuelCategory defaultFuelCategory,
      final FuelType defaultFuelType, final String defaultSearchCriteria, int version) {
    final UserConfiguration userConfiguration = UserConfiguration(
        id: UserConfiguration.defaultUserConfigId,
        version: version,
        searchRadius: searchRadius,
        numSearchResults: numSearchResults,
        defaultFuelCategory: defaultFuelCategory,
        defaultFuelType: defaultFuelType,
        searchCriteria: defaultSearchCriteria);

    final UserConfigurationDao userConfigurationDao = UserConfigurationDao.instance;
    return userConfigurationDao.insertUserConfiguration(userConfiguration);
  }

  Future<DropDownValues<FuelCategory>> fuelCategoryDropdownValues() async {
    final DropDownValues<FuelCategory> dropDownValues = DropDownValues();
    final MarketRegionZoneConfigDao marketRegionZoneConfigDao = MarketRegionZoneConfigDao.instance;
    final MarketRegionZoneConfiguration? marketRegionZoneConfig =
        await marketRegionZoneConfigDao.getMarketRegionZoneConfiguration();
    FuelCategory defaultFuelCategory;
    if (marketRegionZoneConfig != null) {
      dropDownValues.values = marketRegionZoneConfig.marketRegionConfig.allowedFuelCategories.toList();
      defaultFuelCategory = marketRegionZoneConfig.marketRegionConfig.defaultFuelCategory;
      FuelCategory? userDefaultFuelCategory;
      final UserConfigurationDao userConfigurationDao = UserConfigurationDao.instance;
      final UserConfiguration? userConfiguration = await userConfigurationDao
          .getUserConfiguration(UserConfiguration.defaultUserConfigId);
      if (userConfiguration != null) {
        userDefaultFuelCategory = userConfiguration.defaultFuelCategory;
      }
      dropDownValues.values.sort((cat1, cat2) => cat1.categoryName.compareTo(cat2.categoryName));
      dropDownValues.selectedIndex =
          _getSelectedFuelCategoryIndex(dropDownValues.values, defaultFuelCategory, userDefaultFuelCategory);
    } else {
      dropDownValues.noDataFound = true;
      dropDownValues.values = [];
    }
    return dropDownValues;
  }

  Future<DropDownValues<FuelType>> fuelTypeDropdownValues(final FuelCategory? selectedFuelCat) async {
    final DropDownValues<FuelType> dropDownValues = DropDownValues();
    FuelCategory? fuelCategory;
    FuelCategory? userDefaultFuelCategory;
    FuelType? userDefaultFuelType;
    final UserConfigurationDao userConfigurationDao = UserConfigurationDao.instance;
    final UserConfiguration? userConfiguration = await userConfigurationDao
        .getUserConfiguration(UserConfiguration.defaultUserConfigId);
    if (userConfiguration != null) {
      userDefaultFuelCategory = userConfiguration.defaultFuelCategory;
      userDefaultFuelType = userConfiguration.defaultFuelType;
    }
    if (selectedFuelCat != null) {
      fuelCategory = selectedFuelCat;
    } else {
      LogUtil.debug(_tag, 'Input selectedFuelCat is null - 1');
      final MarketRegionZoneConfigDao marketRegionZoneConfigDao = MarketRegionZoneConfigDao.instance;
      final MarketRegionZoneConfiguration? marketRegionZoneConfig =
          await marketRegionZoneConfigDao.getMarketRegionZoneConfiguration();
      List<FuelCategory> fuelCategories = [];
      FuelCategory? marketRegionFuelCategory;
      if (marketRegionZoneConfig != null) {
        fuelCategories = marketRegionZoneConfig.marketRegionConfig.allowedFuelCategories.toList();
        marketRegionFuelCategory = marketRegionZoneConfig.marketRegionConfig.defaultFuelCategory;
      } else {
        LogUtil.debug(_tag, 'fuelTypeDropdownValues::MarketRegionZoneConfig is null');
      }
      if (marketRegionFuelCategory != null || userDefaultFuelCategory != null) {
        final int selectedCategoryIndex =
            _getSelectedFuelCategoryIndex(fuelCategories, marketRegionFuelCategory, userDefaultFuelCategory);
        fuelCategory = fuelCategories[selectedCategoryIndex];
        LogUtil.debug(_tag, 'fuelCategories found at index $selectedCategoryIndex');
      }
    }
    if (fuelCategory != null) {
      final List<FuelType> fuelCategoryAllowedFuelTypes = fuelCategory.allowedFuelTypes.toList();
      fuelCategoryAllowedFuelTypes.sort((ft1, ft2) => ft1.fuelName.compareTo(ft2.fuelName));
      dropDownValues.values = fuelCategoryAllowedFuelTypes;
      dropDownValues.selectedIndex =
          _getSelectedFuelTypeIndex(dropDownValues.values, fuelCategory.defaultFuelType, userDefaultFuelType);
    } else {
      dropDownValues.noDataFound = true;
    }
    return dropDownValues;
  }

  static const _defaultSortOrder = 'CHEAPEST_CLOSEST';

  Future<DropDownValues<SortOrder>> sortOrderDropdownValues() async {
    final DropDownValues<SortOrder> dropDownValues = DropDownValues();
    dropDownValues.values = SortOrder.values.toList();
    final UserConfigurationDao userConfigurationDao = UserConfigurationDao.instance;
    final UserConfiguration? userConfiguration = await userConfigurationDao
        .getUserConfiguration(UserConfiguration.defaultUserConfigId);
    if (userConfiguration != null) {
      dropDownValues.selectedIndex =
          _getSortOrderSelectedIndex(dropDownValues.values, userConfiguration.searchCriteria);
    } else {
      final MarketRegionZoneConfigDao marketRegionZoneConfigDao = MarketRegionZoneConfigDao.instance;
      final MarketRegionZoneConfiguration? marketRegionZoneConfig =
          await marketRegionZoneConfigDao.getMarketRegionZoneConfiguration();
      if (marketRegionZoneConfig != null) {
        dropDownValues.selectedIndex =
            _getSortOrderSelectedIndex(dropDownValues.values, marketRegionZoneConfig.marketRegionConfig.sortOrder);
      } else {
        dropDownValues.selectedIndex = _getSortOrderSelectedIndex(dropDownValues.values, _defaultSortOrder);
      }
    }
    return dropDownValues;
  }

  static const _maxSearchRadius = 4;

  Future<DropDownValues<num>> searchRadiusDropDownValues(final int maxEntries) async {
    final MarketRegionZoneConfigDao marketRegionZoneConfigDao = MarketRegionZoneConfigDao.instance;
    final UserConfigurationDao userConfigurationDao = UserConfigurationDao.instance;

    final MarketRegionZoneConfiguration? marketRegionZoneConfig =
        await marketRegionZoneConfigDao.getMarketRegionZoneConfiguration();

    final DropDownValues<num> dropDownValues = DropDownValues();

    if (marketRegionZoneConfig != null) {
      dropDownValues.values = _getEntries(maxEntries, marketRegionZoneConfig.marketRegionConfig.searchRange);
      final UserConfiguration? userConfiguration = await userConfigurationDao
          .getUserConfiguration(UserConfiguration.defaultUserConfigId);
      final userVal = userConfiguration?.searchRadius;
      dropDownValues.selectedIndex = _getSelectedIndex(userVal??_maxSearchRadius, dropDownValues.values);
    } else {
      // This condition should never happen.
      // The else part is impossible
    }
    return dropDownValues;
  }

  static const _maxSearchResults = 20;

  Future<DropDownValues<num>> searchFuelStationDropDownValues(final int maxEntries) async {
    final MarketRegionZoneConfigDao marketRegionZoneConfigDao = MarketRegionZoneConfigDao.instance;
    final UserConfigurationDao userConfigurationDao = UserConfigurationDao.instance;

    final MarketRegionZoneConfiguration? marketRegionZoneConfig =
        await marketRegionZoneConfigDao.getMarketRegionZoneConfiguration();

    final DropDownValues<num> dropDownValues = DropDownValues();

    if (marketRegionZoneConfig != null) {
      dropDownValues.values = _getEntries(maxEntries, marketRegionZoneConfig.marketRegionConfig.maxNumberOfResults);
      final UserConfiguration? userConfiguration = await userConfigurationDao
          .getUserConfiguration(UserConfiguration.defaultUserConfigId);
      final userVal = userConfiguration?.numSearchResults;
      dropDownValues.selectedIndex = _getSelectedIndex(userVal??_maxSearchResults, dropDownValues.values);
    } else {
      // This else part should never happen
      // It it happens, then it is error.
    }
    return dropDownValues;
  }

  int _getSelectedFuelCategoryIndex(final List<FuelCategory> allowedFuelCategories,
      final FuelCategory? marketRegionDefaultFuelCategory, final FuelCategory? userDefaultFuelCategory) {
    final FuelCategory? selectedFuelCategory =
        userDefaultFuelCategory ?? marketRegionDefaultFuelCategory;
    for (int i = 0; i < allowedFuelCategories.length; i++) {
      if (allowedFuelCategories[i] == selectedFuelCategory) {
        return i;
      }
    }
    return 0;
  }

  static int _getSelectedFuelTypeIndex(
      final List<FuelType> fuelTypes, final FuelType defaultFuelType, final FuelType? userDefaultFuelType) {
    int userSelectedFuelTypeIndex = -1;
    int defaultFuelTypeIndex = -1;
    for (int i = 0; i < fuelTypes.length; i++) {
      if (fuelTypes[i] == userDefaultFuelType) {
        userSelectedFuelTypeIndex = i;
      } else if (fuelTypes[i] == defaultFuelType) {
        defaultFuelTypeIndex = i;
      }
    }
    final int retVal = userSelectedFuelTypeIndex != -1 ? userSelectedFuelTypeIndex : defaultFuelTypeIndex;
    return retVal != -1 ? retVal : 0;
  }


  static int _getSortOrderSelectedIndex(final List<SortOrder> values, final String? sortOrderStr) {
    SortOrder sortOrder;
    if (sortOrderStr != null) {
      LogUtil.debug(_tag, '$sortOrderStr sortOrderStr value');
      sortOrder = QuoteSortOrder.getSortOrder(sortOrderStr)!;
    } else {
      sortOrder = QuoteSortOrder.getSortOrder('CHEAPEST_CLOSEST')!;
    }
    for (int i = 0; i < values.length; i++) {
      if (values[i] == sortOrder) {
        return i;
      }
    }
    return 0;
  }

  static List<num> _getEntries(final int maxEntries, final int maxValue) {
    List<num> entries = [];
    int steps = maxEntries;
    num stepValues = (maxValue / steps).ceil();
    if (stepValues > 0) {
      int i = 1;
      while (i <= steps) {
        entries.add(stepValues * (i++));
      }
    } else {
      entries = [maxValue as double];
    }
    return entries;
  }

  static int _getSelectedIndex(num? userVal, List<num> entries) {
    int selectedIndex = 0;
    if (userVal == null || entries.isEmpty) {
      selectedIndex = 0;
    } else {
      for (int i = 0; i < entries.length; i++) {
        if (entries[i] == userVal) {
          selectedIndex = i;
          break;
        }
      }
    }
    return selectedIndex;
  }
}
