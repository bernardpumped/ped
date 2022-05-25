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
import 'package:pumped_end_device/data/local/model/favorite_fuel_station.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FavoriteFuelStationBookmark extends StatefulWidget {
  final FuelStation _fuelStation;

  const FavoriteFuelStationBookmark(this._fuelStation, {Key? key}) : super(key: key);

  @override
  State<FavoriteFuelStationBookmark> createState() => _FavoriteFuelStationBookmarkState();
}

class _FavoriteFuelStationBookmarkState extends State<FavoriteFuelStationBookmark> {
  static const _tag = 'FavoriteFuelStationBookmark';
  final FavoriteFuelStationsDao dao = FavoriteFuelStationsDao.instance;

  @override
  Widget build(BuildContext context) {
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
                  ? _getWidget(Icons.heart_broken_outlined, 'Unfavourite', () {
                      _favoriteRemoveAction(station);
                    })
                  : _getWidget(Icons.favorite_border_outlined, 'Favourite', () {
                      _favoriteAddAction(station);
                    });
            } else if (snapshot.hasError) {
              return const Text('Error Loading');
            } else {
              return const Text('Loading');
            }
          })
    ]);
  }

  Widget _getWidget(final IconData icon, final String text, final GestureTapCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Column(children: [
        Card(
            elevation: 2,
            color: Colors.indigo,
            // color: Color(0xFFF0EDFF),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.indigo, width: 1)),
            child: Padding(padding: const EdgeInsets.all(14.0), child: Icon(icon, color: Colors.white))),
        Text(text, style: const TextStyle(color: Colors.indigo, fontSize: 14, fontWeight: FontWeight.w500))
      ]),
    );
  }

  void _favoriteRemoveAction(final FavoriteFuelStation station) {
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

  void _favoriteAddAction(final FavoriteFuelStation station) {
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
