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

import '../icon_codes.dart';

class PumpedIcons {
  static const emailIcon_whiteSize24 = const Icon(IconData(IconCodes.email_icon_code, fontFamily: 'MaterialIcons'), color: Colors.white, size: 24);

  static const faSourceIcon_black54Size30 = const Icon(IconData(IconCodes.fa_source_icon_code, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 30);
  static const faSourceIcon_black54Size24 = const Icon(IconData(IconCodes.fa_source_icon_code, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 24);
  static const faSourceIcon_black54Size20 = const Icon(IconData(IconCodes.fa_source_icon_code, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 20);

  static const crowdSourceIcon_black54Size30 = const Icon(IconData(IconCodes.crowd_source_icon_code, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 30);
  static const crowdSourceIcon_black54Size24 = const Icon(IconData(IconCodes.crowd_source_icon_code, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 24);

  static const googleSourceIcon_black54Size30 = const Icon(IconData(IconCodes.google_source_icon_code, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 24);

  static const settingsIcon_black54Size30 = const Icon(IconData(IconCodes.settings_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const settingsIcon_black54Size24 = const Icon(IconData(IconCodes.settings_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 24);
  static const settingsTabIcon_size30 = const Icon(IconData(IconCodes.settings_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), size: 30);

  static const undoIcon_black87Size30 =  const Icon(IconData(IconCodes.undo_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);

  static const searchTabIcon_size30 =  const Icon(IconData(IconCodes.fuel_station_search_tab_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), size: 30);
  static const updateHistoryTabIcon_size30 =  const Icon(IconData(IconCodes.update_history_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), size: 30);
  static const aboutTabIcon_size30 =  const Icon(IconData(IconCodes.about_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), size: 30);

  static const fuelTypesIcon_black54Size30 = const Icon(IconData(IconCodes.fuel_type_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const fuelCategoriesIcon_black54Size30 = const Icon(IconData(IconCodes.fuel_categories_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);

}