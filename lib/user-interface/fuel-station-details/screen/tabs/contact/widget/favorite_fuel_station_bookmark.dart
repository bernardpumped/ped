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
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FavoriteFuelStationBookmark extends StatefulWidget {
  final FuelStation _fuelStation;
  final Function _onFavouriteStatusChange;

  const FavoriteFuelStationBookmark(this._fuelStation, this._onFavouriteStatusChange, {Key? key}) : super(key: key);

  @override
  State<FavoriteFuelStationBookmark> createState() => _FavoriteFuelStationBookmarkState();
}

class _FavoriteFuelStationBookmarkState extends State<FavoriteFuelStationBookmark> {
  static const _tag = 'FavoriteFuelStationBookmark';
  final FavoriteFuelStationsDao dao = FavoriteFuelStationsDao.instance;

  @override
  Widget build(final BuildContext context) {
    final Future<bool> isHidden = HiddenResultDao.instance
        .containsHiddenFuelStation(widget._fuelStation.stationId, widget._fuelStation.getFuelStationSource());
    return FutureBuilder<bool>(
        future: isHidden,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool hidden = snapshot.data!;
            return hidden ? _inEligibleStation() : _eligibleStation();
          } else if (snapshot.hasError) {
            return Text('Error Loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else {
            return Text('Loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  void _favoriteRemoveAction(final FavoriteFuelStation station) {
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

  void _favoriteAddAction(final FavoriteFuelStation station) {
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

  _eligibleStation() {
    final FavoriteFuelStation station = FavoriteFuelStation(
        favoriteFuelStationId: widget._fuelStation.stationId,
        fuelStationSource: (widget._fuelStation.getFuelStationSource()));
    final Future<bool> isFavoriteFuelStationFuture =
        dao.containsFavoriteFuelStation(station.favoriteFuelStationId, station.fuelStationSource);
    return Wrap(children: [
      FutureBuilder<bool>(
          future: isFavoriteFuelStationFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bool isFavoriteFuelStation = snapshot.data!;
              return isFavoriteFuelStation
                  ? WidgetUtils.getRoundedButton(
                      context: context,
                      buttonText: 'Unfavourite',
                      iconData: Icons.heart_broken_outlined,
                      onTapFunction: () {
                        _favoriteRemoveAction(station);
                        widget._onFavouriteStatusChange(); // This is to enable refresh of the home screen.
                      })
                  : WidgetUtils.getRoundedButton(
                      context: context,
                      buttonText: 'Favourite',
                      iconData: Icons.favorite_border_outlined,
                      onTapFunction: () {
                        _favoriteAddAction(station);
                        widget._onFavouriteStatusChange(); // This is to enable refresh of the home screen.
                      });
            } else if (snapshot.hasError) {
              return Text('Error Loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            } else {
              return Text('Loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            }
          })
    ]);
  }

  _inEligibleStation() {
    LogUtil.debug(_tag, 'Fuel Station is hidden. Not displaying Favourite button');
    return const SizedBox(width: 0);
  }
}
