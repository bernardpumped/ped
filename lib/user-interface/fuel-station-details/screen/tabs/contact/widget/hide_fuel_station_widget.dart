import 'package:flutter/material.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';

class HideFuelStationWidget extends StatefulWidget {
  final FuelStation _fuelStation;
  final Function _onFavouriteStatusChange;
  const HideFuelStationWidget(this._fuelStation, this._onFavouriteStatusChange, {Key? key}) : super(key: key);

  @override
  State<HideFuelStationWidget> createState() => _HideFuelStationWidgetState();
}

class _HideFuelStationWidgetState extends State<HideFuelStationWidget> {
  @override
  Widget build(final BuildContext context) {
    return _getWidget(Icons.hide_source_outlined, 'Hide ', () {});
  }

  Widget _getWidget(final IconData icon, final String text, final GestureTapCallback callback) {
    return GestureDetector(
        onTap: callback,
        child: WidgetUtils.wrapWithRoundedContainer(
            context: context,
            radius: 24,
            child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(children: [
                  Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Icon(icon, size: 24)
                ]))));
  }
}
