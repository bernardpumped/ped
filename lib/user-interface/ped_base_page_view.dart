import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/about/screen/about_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/favourite/favourite_stations_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/settings_screen.dart';

import 'fuel-stations/screens/nearby/nearby_stations_screen.dart';
import 'nav-drawer/nav_drawer_widget.dart';

const double drawerWidth = 60;

class PedBasePageView extends StatefulWidget {
  static const routeName = '/ped/base-page-view';

  const PedBasePageView({Key? key}) : super(key: key);

  @override
  State<PedBasePageView> createState() => _PedBasePageViewState();
}

class _PedBasePageViewState extends State<PedBasePageView> {
  final PageController _pageController = PageController(initialPage: 0);
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Row(children: [
      NavDrawerWidget(width: drawerWidth, pageController: _pageController),
      SizedBox(
          width: MediaQuery.of(context).size.width - drawerWidth,
          child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: onPageChanged,
              children: const [NearbyStationsScreen(), FavouriteStationsScreen(), SettingsScreen(), AboutScreen()]))
    ]);
  }
}
