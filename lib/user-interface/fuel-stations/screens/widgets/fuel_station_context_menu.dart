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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao/favorite_fuel_stations_dao.dart';
import 'package:pumped_end_device/data/local/dao/hidden_result_dao.dart';
import 'package:pumped_end_device/data/local/model/favorite_fuel_station.dart';
import 'package:pumped_end_device/data/local/model/hidden_result.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/params/fuel_station_details_param.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/fuel_station_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationContextMenu extends StatefulWidget {
  final FuelStation fuelStation;

  const FuelStationContextMenu({Key? key, required this.fuelStation}) : super(key: key);

  @override
  State<FuelStationContextMenu> createState() => _FuelStationContextMenuState();
}

class _FuelStationContextMenuState extends State<FuelStationContextMenu> {
  static const _tag = 'FuelStationContextMenu';
  final FuelStationCardColorScheme colorScheme =
      getIt.get<FuelStationCardColorScheme>(instanceName: fsCardColorSchemeName);

  final FavoriteFuelStationsDao dao = FavoriteFuelStationsDao.instance;

  @override
  Widget build(final BuildContext context) {
    LogUtil.debug(_tag, 'Reading data from db for fuelStationId ${widget.fuelStation.stationId}');
    final Future<bool> isFavoriteFuelStationFuture =
        dao.containsFavoriteFuelStation(widget.fuelStation.stationId, widget.fuelStation.getFuelStationSource());
    return FutureBuilder<bool>(
        future: isFavoriteFuelStationFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _getPopupMenu(context, snapshot.data!);
          } else if (snapshot.hasError) {
            return _getPopupMenu(context, false);
          } else {
            return _getPopupMenu(context, false);
          }
        });
  }

  PopupMenuButton<String> _getPopupMenu(final BuildContext context, final bool isFavourite) {
    return PopupMenuButton<String>(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)), side: BorderSide(width: .1)),
        padding: EdgeInsets.zero,
        onSelected: (value) {
          if (value == 'preview') {
            Navigator.pushNamed(context, FuelStationDetailsScreen.routeName,
                arguments: FuelStationDetailsParam(widget.fuelStation));
          }
          if (value == 'favourite') {
            if (isFavourite) {
              _favoriteRemoveAction();
            } else {
              _favoriteAddAction();
            }
          }
          if (value == 'hide') {
            _hideFuelStation();
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  value: 'preview',
                  child: ListTile(
                      leading: Icon(Icons.visibility, color: colorScheme.contextMenuForegroundColor),
                      title: Text('Preview', style: TextStyle(color: colorScheme.contextMenuForegroundColor)))),
              PopupMenuItem<String>(
                  value: 'favourite',
                  child: ListTile(
                      leading: Icon(isFavourite ? Icons.heart_broken_outlined : Icons.favorite_border_outlined,
                          color: colorScheme.contextMenuForegroundColor),
                      title: Text(isFavourite ? 'Unfavourite' : 'Favourite',
                          style: TextStyle(color: colorScheme.contextMenuForegroundColor)))),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                  value: 'hide',
                  child: ListTile(
                      leading: Icon(Icons.hide_source_outlined, color: colorScheme.openCloseWidgetCloseColor),
                      title: Text('Hide', style: TextStyle(color: colorScheme.openCloseWidgetCloseColor))))
            ]);
  }

  void _hideFuelStation() {
    final Future<bool> isFavourite = FavoriteFuelStationsDao.instance
        .containsFavoriteFuelStation(widget.fuelStation.stationId, widget.fuelStation.getFuelStationSource());
    isFavourite.then((value) {
      if (value) {
        WidgetUtils.showToastMessage(context, 'Cannot hide a favourite station. First unfavourite and then try again',
            Colors.indigo);
      } else {
        final Future<dynamic> insertHiddenResult = HiddenResultDao.instance.insertHiddenResult(HiddenResult(
            hiddenStationId: widget.fuelStation.stationId,
            hiddenStationSource: widget.fuelStation.getFuelStationSource()));
        insertHiddenResult.then((value) {
          WidgetUtils.showToastMessage(
              context, 'Added to hidden list. Refresh screen to update', Colors.indigo);
        }, onError: (error, s) {
          WidgetUtils.showToastMessage(context, 'Error hiding fuel station.', Colors.indigo);
        });
      }
    }, onError: (error, s) {
      WidgetUtils.showToastMessage(context, 'Error checking eligibility to hide.', Colors.indigo);
    });
  }

  void _favoriteRemoveAction() {
    final FavoriteFuelStation station = FavoriteFuelStation(
        favoriteFuelStationId: widget.fuelStation.stationId,
        fuelStationSource: widget.fuelStation.getFuelStationSource());
    final Future<bool> isFavoriteFuelStationFuture =
        dao.containsFavoriteFuelStation(station.favoriteFuelStationId, station.fuelStationSource);
    isFavoriteFuelStationFuture.then((value) {
      if (!value) {
        WidgetUtils.showToastMessage(context, 'Fuel Station is not yet Favorite', Colors.indigo);
      } else {
        final Future<dynamic> deleteFavFuelStationFuture = dao.deleteFavoriteFuelStation(station);
        deleteFavFuelStationFuture.then((value) {
          WidgetUtils.showToastMessage(context, 'Removed from Favorite', Colors.indigo);
          setState(() {});
        }, onError: (error, s) {
          WidgetUtils.showToastMessage(context, 'Error removing from Favorite', Colors.indigo);
          LogUtil.error(_tag, 'Error removing from Favorite $error');
        });
      }
    }, onError: (error, s) {
      WidgetUtils.showToastMessage(context, 'Error removing from Favorite', Colors.indigo);
      LogUtil.error(_tag, 'Error removing from Favorite $error');
    });
  }

  void _favoriteAddAction() {
    final FavoriteFuelStation station = FavoriteFuelStation(
        favoriteFuelStationId: widget.fuelStation.stationId,
        fuelStationSource: widget.fuelStation.getFuelStationSource());
    final Future<bool> isFavoriteFuelStationFuture =
        dao.containsFavoriteFuelStation(station.favoriteFuelStationId, station.fuelStationSource);
    isFavoriteFuelStationFuture.then((value) {
      if (!value) {
        final Future<dynamic> insertFuture = dao.insertFavoriteFuelStation(station);
        insertFuture.then((value) {
          WidgetUtils.showToastMessage(context, 'Bookmarked as Favorite', Colors.indigo);
          setState(() {});
        }, onError: (error, s) {
          WidgetUtils.showToastMessage(context, 'Error marking as Favorite', Colors.indigo);
          LogUtil.error(_tag, 'Error marking as Favorite $error');
        });
      } else {
        WidgetUtils.showToastMessage(context, 'Already Bookmarked as Favorite', Colors.indigo);
      }
    }, onError: (error, s) {
      WidgetUtils.showToastMessage(context, 'Error marking as Favorite', Colors.indigo);
      LogUtil.error(_tag, 'Error marking as Favorite $error');
    });
  }
}
