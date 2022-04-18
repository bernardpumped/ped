import 'package:flutter/material.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped-app-bar-color-scheme.dart';

class PumpedAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PumpedAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<PumpedAppBar> createState() => _PumpedAppBarState();
}

class _PumpedAppBarState extends State<PumpedAppBar> {
  final PumpedAppBarColorScheme colorScheme = getIt.get<PumpedAppBarColorScheme>(instanceName: appBarColorSchemeName);

  @override
  Widget build(final BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: colorScheme.backgroundColor,
        iconTheme: IconThemeData(color: colorScheme.iconThemeColor),
        centerTitle: false,
        foregroundColor: colorScheme.foregroundColor,
        automaticallyImplyLeading: true,
        title:
            Text('Pumped', style: TextStyle(fontSize: 28, color: colorScheme.titleColor, fontWeight: FontWeight.bold)));
  }
}
