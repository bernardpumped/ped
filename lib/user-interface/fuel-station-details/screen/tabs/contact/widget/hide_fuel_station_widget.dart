import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao/favorite_fuel_stations_dao.dart';
import 'package:pumped_end_device/data/local/dao/hidden_result_dao.dart';
import 'package:pumped_end_device/data/local/model/favorite_fuel_station.dart';
import 'package:pumped_end_device/data/local/model/hidden_result.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class HideFuelStationWidget extends StatefulWidget {
  final FuelStation _fuelStation;
  final Function _onHideStatusChange;

  const HideFuelStationWidget(this._fuelStation, this._onHideStatusChange, {super.key});

  @override
  State<HideFuelStationWidget> createState() => _HideFuelStationWidgetState();
}

class _HideFuelStationWidgetState extends State<HideFuelStationWidget> {
  static const _tag = 'HideFuelStationWidget';
  final FavoriteFuelStationsDao dao = FavoriteFuelStationsDao.instance;
  @override
  Widget build(final BuildContext context) {
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
              return isFavoriteFuelStation ? _inEligibleStation() : _eligibleStation(context);
            } else if (snapshot.hasError) {
              return Text('Error Loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            } else {
              return Text('Loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            }
          })
    ]);
  }

  Widget _inEligibleStation() {
    LogUtil.debug(_tag, 'Fuel Station is favourite. Not displaying Hide button');
    return const SizedBox(width: 0);
  }

  Widget _eligibleStation(final BuildContext context) {
    final Future<bool> isHidden = HiddenResultDao.instance
        .containsHiddenFuelStation(widget._fuelStation.stationId, widget._fuelStation.getFuelStationSource());
    return FutureBuilder<bool>(
        future: isHidden,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool hidden = snapshot.data!;
            if (hidden) {
              return WidgetUtils.getRoundedButton(
                  context: context,
                  buttonText: 'Un-hide',
                  iconData: Icons.hide_source_outlined,
                  onTapFunction: () {
                    _unhideFuelStation(widget._fuelStation);
                  });
            } else {
              return WidgetUtils.getRoundedButton(
                  context: context,
                  buttonText: 'Hide',
                  iconData: Icons.hide_source_outlined,
                  onTapFunction: () {
                    _hideFuelStation(widget._fuelStation);
                  });
            }
          } else if (snapshot.hasError) {
            return Text('Error Loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else {
            return Text('Loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  void _hideFuelStation(final FuelStation fuelStation) {
    final Future<bool> isFavourite = FavoriteFuelStationsDao.instance
        .containsFavoriteFuelStation(widget._fuelStation.stationId, widget._fuelStation.getFuelStationSource());
    isFavourite.then((value) {
      if (value) {
        WidgetUtils.showToastMessage(context, 'Cannot hide a favourite station. First unfavourite and then try again');
      } else {
        final Future<dynamic> insertHiddenResult = HiddenResultDao.instance.insertHiddenResult(HiddenResult(
            hiddenStationId: fuelStation.stationId, hiddenStationSource: fuelStation.getFuelStationSource()));
        insertHiddenResult.then((value) {
          WidgetUtils.showToastMessage(context, 'Added to hidden list. Refresh screen to update');
          widget._onHideStatusChange();
        }, onError: (error, s) {
          WidgetUtils.showToastMessage(context, 'Error hiding fuel station.', isErrorToast: true);
        });
      }
    }, onError: (error, s) {
      WidgetUtils.showToastMessage(context, 'Error checking eligibility to hide.', isErrorToast: true);
    });
  }

  void _unhideFuelStation(final FuelStation fuelStation) {
    final Future<dynamic> deleteHiddenResult = HiddenResultDao.instance.deleteHiddenResults(
        HiddenResult(hiddenStationId: fuelStation.stationId, hiddenStationSource: fuelStation.getFuelStationSource()));
    deleteHiddenResult.then((value) {
      WidgetUtils.showToastMessage(context, 'Successfully un-hidden the fuel station');
      widget._onHideStatusChange();
    }, onError: (error, s) {
      WidgetUtils.showToastMessage(context, 'Error un-hiding the fuel station', isErrorToast: true);
    });
  }
}
