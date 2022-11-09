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
  bool? developerOptions;

  UiSettings({this.uiTheme, this.developerOptions});

  Map<String, dynamic> toMap() => {'uiTheme': uiTheme, 'developerOptions': developerOptions};

  Map<String, dynamic> toJson() => {'uiTheme': uiTheme, 'developerOptions': developerOptions};

  factory UiSettings.fromJson(final Map<String, dynamic> data) {
    return UiSettings(uiTheme: data['uiTheme'], developerOptions: data['developerOptions']);
  }

  factory UiSettings.fromMap(final Map<String, dynamic> data) => UiSettings.fromJson(data);
}
