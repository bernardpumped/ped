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

class UiSettings {
  String? uiTheme;
  String? textScale;
  bool? developerOptions;
  bool? devOptionsEnrichOffers;

  UiSettings({this.uiTheme, this.textScale, this.developerOptions, this.devOptionsEnrichOffers});

  Map<String, dynamic> toMap() =>
      {'uiTheme': uiTheme, 'textScale':textScale, 'developerOptions': developerOptions, 'devOptionsEnrichOffers': devOptionsEnrichOffers};

  Map<String, dynamic> toJson() =>
      {'uiTheme': uiTheme, 'textScale':textScale, 'developerOptions': developerOptions, 'devOptionsEnrichOffers': devOptionsEnrichOffers};

  factory UiSettings.fromJson(final Map<String, dynamic> data) {
    return UiSettings(
        uiTheme: data['uiTheme'],
        textScale: data['textScale'],
        developerOptions: data['developerOptions'],
        devOptionsEnrichOffers: data['devOptionsEnrichOffers']);
  }

  factory UiSettings.fromMap(final Map<String, dynamic> data) => UiSettings.fromJson(data);
}
