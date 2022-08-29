import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel-station-sorter/floating_panel_widget.dart';

class FuelStationSorterWidget extends StatefulWidget {
  final Function parentUpdateFunction;
  const FuelStationSorterWidget({Key? key, required this.parentUpdateFunction}) : super(key: key);

  @override
  State<FuelStationSorterWidget> createState() => _FuelStationSorterWidgetState();
}

class _FuelStationSorterWidgetState extends State<FuelStationSorterWidget> {
  int sortOrder = 1;
  static const Map<int, IconData> sortIcons = {
    0: Icons.label,
    1: Icons.attach_money,
    2: Icons.navigation,
    3: Icons.shopping_cart
  };

  static const Map<int, String> sortHeaders = {0: 'Brand', 1: 'Price', 2: 'Distance', 3: 'Offers'};

  @override
  Widget build(final BuildContext context) {
    return FloatBoxPanelWidget(
        iconSize: 24,
        size: 50,
        panelIcon: Icons.sort_outlined,
        backgroundColor: Theme.of(context).primaryColor,
        contentColor: const Color(0xFFffd629),
        nonSelColor: Theme.of(context).backgroundColor,
        buttons: sortIcons.values.toList(),
        buttonLabels: sortHeaders.values.toList(),
        selIndex: sortOrder,
        onPressed: (index) {
          setState(() {
            sortOrder = index;
            widget.parentUpdateFunction(sortOrder);
          });
        });
  }
}
