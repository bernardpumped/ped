/*
 *     Copyright (c) 2021.
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

import 'package:pumped_end_device/models/pumped/fuel_category.dart';

class MarketRegionConfig {
  /*
    This is trimmed down version of marketRegion config
    defined in backend. Trimming is done based on data
    required by the pumped_end_device
   */
  String marketRegionId;
  String marketRegionName;
  int marketRegionConfigVersion;

  String currency;
  String currencyValueFormat;
  String fuelMeasure;
  String distanceMeasure;

  int maxNumberOfResults;
  FuelCategory defaultFuelCategory;
  Set<FuelCategory> allowedFuelCategories;

  int searchRange;
  String sortOrder;
  bool incrementalSearch;
  int incrementalSearchValue;
  String fuelAuthorityId;
  String fuelAuthorityName;
  double minDefaultFuelPrice;
  double maxDefaultFuelPrice;

  MarketRegionConfig(
      {this.marketRegionId,
      this.marketRegionName,
      this.marketRegionConfigVersion,
      this.currency,
      this.currencyValueFormat,
      this.fuelMeasure,
      this.distanceMeasure,
      this.maxNumberOfResults,
      this.defaultFuelCategory,
      this.allowedFuelCategories,
      this.searchRange,
      this.sortOrder,
      this.incrementalSearch,
      this.incrementalSearchValue,
      this.fuelAuthorityId,
      this.fuelAuthorityName,
      this.minDefaultFuelPrice,
      this.maxDefaultFuelPrice});

  factory MarketRegionConfig.fromMap(final Map<String, dynamic> data) => MarketRegionConfig.fromJson(data);

  factory MarketRegionConfig.fromJson(final Map<String, dynamic> data) => MarketRegionConfig(
        marketRegionId: data['market_region_id'],
        marketRegionName: data['market_region_name'],
        marketRegionConfigVersion: data['market_region_config_version'],
        currency: data['currency'],
        currencyValueFormat: data['currency_value_format'],
        fuelMeasure: data['fuel_measure'],
        distanceMeasure: data['distance_measure'],
        maxNumberOfResults: data['max_number_results'],
        defaultFuelCategory: FuelCategory.fromJson(data['default_fuel_category']),
        allowedFuelCategories: (data['allowed_fuel_categories'] as List).map((i) => FuelCategory.fromJson(i)).toSet(),
        searchRange: data['search_range'],
        sortOrder: data['sort_order'],
        incrementalSearch: data['incremental_search'],
        incrementalSearchValue: data['incremental_search_value'],
        fuelAuthorityId: data['fuel_authority_id'],
        fuelAuthorityName: data['fuel_authority_name'],
        minDefaultFuelPrice: data['min_default_fuel_price'],
        maxDefaultFuelPrice: data['max_default_fuel_price'],
      );

  Map<String, dynamic> toJson() => {
        'market_region_id': marketRegionId,
        'market_region_name': marketRegionName,
        'market_region_config_version': marketRegionConfigVersion,
        'currency': currency,
        'currency_value_format': currencyValueFormat,
        'fuel_measure': fuelMeasure,
        'distance_measure': distanceMeasure,
        'max_number_results': maxNumberOfResults,
        'default_fuel_category': defaultFuelCategory.toJson(),
        'allowed_fuel_categories': allowedFuelCategories.map((i) => i.toJson()).toList(),
        'search_range': searchRange,
        'sort_order': sortOrder,
        'incremental_search': incrementalSearch,
        'incremental_search_value': incrementalSearchValue,
        'fuel_authority_id': fuelAuthorityId,
        'fuel_authority_name': fuelAuthorityName,
        'min_default_fuel_price': minDefaultFuelPrice,
        'max_default_fuel_price': maxDefaultFuelPrice,
      };

    Map<String, dynamic> toMap() => toJson();
}