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
import 'package:pumped_end_device/data/local/dao2/favorite_fuel_stations_dao.dart';
import 'package:pumped_end_device/data/local/dao2/hidden_result_dao.dart';
import 'package:pumped_end_device/data/local/model/favorite_fuel_station.dart';
import 'package:pumped_end_device/data/local/model/hidden_result.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/params/fuel_station_details_param.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationContextMenu extends StatefulWidget {
  final FuelStation fuelStation;
  final FuelType selectedFuelType;

  const FuelStationContextMenu({super.key, required this.fuelStation, required this.selectedFuelType});

  @override
  State<FuelStationContextMenu> createState() => _FuelStationContextMenuState();
}

class _FuelStationContextMenuState extends State<FuelStationContextMenu> {
  static const _tag = 'FuelStationContextMenu';

  final FavoriteFuelStationsDao dao = FavoriteFuelStationsDao.instance;

  @override
  Widget build(final BuildContext context) {
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
        icon: const Icon(Icons.more_vert_outlined),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)), side: BorderSide(width: .1)),
        padding: EdgeInsets.zero,
        onSelected: (value) {
          if (value == 'preview') {
            Navigator.pushNamed(context, FuelStationDetailsScreen.routeName,
                arguments: FuelStationDetailsParam(widget.fuelStation, widget.selectedFuelType));
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
                      leading: const Icon(Icons.visibility),
                      title: Text('Preview', style: Theme.of(context).textTheme.titleSmall,
                          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))),
              PopupMenuItem<String>(
                  value: 'favourite',
                  child: ListTile(
                      leading: Icon(isFavourite ? Icons.heart_broken_outlined : Icons.favorite_border_outlined),
                      title: Text(isFavourite ? 'Unfavourite' : 'Favourite',
                          style: Theme.of(context).textTheme.titleSmall,
                          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                  value: 'hide',
                  child: ListTile(
                      leading: Icon(Icons.hide_source_outlined, color: Theme.of(context).colorScheme.error),
                      title: Text('Hide',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)))
            ]);
  }

  void _hideFuelStation() {
    final Future<bool> isFavourite = FavoriteFuelStationsDao.instance
        .containsFavoriteFuelStation(widget.fuelStation.stationId, widget.fuelStation.getFuelStationSource());
    isFavourite.then((value) {
      if (value) {
        WidgetUtils.showToastMessage(context, 'Cannot hide a favourite station. First unfavourite and then try again');
      } else {
        final Future<dynamic> insertHiddenResult = HiddenResultDao.instance.insertHiddenResult(HiddenResult(
            hiddenStationId: widget.fuelStation.stationId,
            hiddenStationSource: widget.fuelStation.getFuelStationSource()));
        insertHiddenResult.then((value) {
          WidgetUtils.showToastMessage(context, 'Added to hidden list. Refresh screen to update');
        }, onError: (error, s) {
          WidgetUtils.showToastMessage(context, 'Error hiding fuel station.', isErrorToast: true);
        });
      }
    }, onError: (error, s) {
      WidgetUtils.showToastMessage(context, 'Error checking eligibility to hide.', isErrorToast: true);
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
        WidgetUtils.showToastMessage(context, 'Fuel Station is not yet Favorite');
      } else {
        final Future<dynamic> deleteFavFuelStationFuture = dao.deleteFavoriteFuelStation(station);
        deleteFavFuelStationFuture.then((value) {
          WidgetUtils.showToastMessage(context, 'Removed from Favorite');
          setState(() {});
        }, onError: (error, s) {
          WidgetUtils.showToastMessage(context, 'Error removing from Favorite', isErrorToast: true);
          LogUtil.error(_tag, 'Error removing from Favorite $error');
        });
      }
    }, onError: (error, s) {
      WidgetUtils.showToastMessage(context, 'Error removing from Favorite', isErrorToast: true);
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
          WidgetUtils.showToastMessage(context, 'Bookmarked as Favorite');
          setState(() {});
        }, onError: (error, s) {
          WidgetUtils.showToastMessage(context, 'Error marking as Favorite', isErrorToast: true);
          LogUtil.error(_tag, 'Error marking as Favorite $error');
        });
      } else {
        WidgetUtils.showToastMessage(context, 'Already Bookmarked as Favorite');
      }
    }, onError: (error, s) {
      WidgetUtils.showToastMessage(context, 'Error marking as Favorite', isErrorToast: true);
      LogUtil.error(_tag, 'Error marking as Favorite $error');
    });
  }
}
