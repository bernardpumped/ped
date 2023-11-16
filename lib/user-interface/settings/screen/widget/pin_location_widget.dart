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
import 'package:pumped_end_device/data/local/dao/mock_location_dao.dart';
import 'package:pumped_end_device/data/local/model/mock_location.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/data/local/places.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class PinLocationWidget extends StatefulWidget {
  final Function() callback;
  const PinLocationWidget({Key? key, required this.callback}) : super(key: key);

  @override
  State<PinLocationWidget> createState() => _PinLocationWidgetState();
}

class _PinLocationWidgetState extends State<PinLocationWidget> {
  static const _tag = 'PinLocationWidget';
  MockLocation? _selectedMockLocation;

  @override
  Widget build(final BuildContext context) {
    LogUtil.debug(_tag, 'Build method invoked for PinLocationWidget');
    return _getFutureBuilder();
  }

  _getFutureBuilder() {
    Future<PinnedLocationAndMockLocations> future = _getPinnedLocationAndMockLocations();
    return FutureBuilder<PinnedLocationAndMockLocations>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final PinnedLocationAndMockLocations pinMockLocations = snapshot.data!;
            LogUtil.debug(_tag, 'PinnedLocationAndMockLocations Future snapShot hasData');
            return Column(children: [
              pinMockLocations.pinnedMockLocation == null
                  ? _getTileForMockLocations(pinMockLocations.allMockLocations)
                  : _getPinnedWidgetTile(pinMockLocations.pinnedMockLocation!),
              Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    pinMockLocations.pinnedMockLocation == null
                        ? _getPinningButton(context)
                        : _getUnpinButton(context, pinMockLocations.pinnedMockLocation!)
                  ]))
            ]);
          } else if (snapshot.hasError) {
            return Text('Error Loading mock Locations', style: Theme.of(context).textTheme.titleMedium,
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else {
            return Text('Loading mock Locations', style: Theme.of(context).textTheme.titleMedium,
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  Widget _getPinnedWidgetTile(final MockLocation pinnedMockLocation) {
    return ListTile(
        leading: const Icon(Icons.location_on_outlined, size: 30),
        title: Text(
            'Pinned : ${pinnedMockLocation.addressLine}, ${pinnedMockLocation.state}, ${pinnedMockLocation.country}',
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor,
            style: Theme.of(context).textTheme.titleMedium));
  }

  Widget _getPinningButton(final BuildContext context) {
    return WidgetUtils.getRoundedButton(
        context: context,
        buttonText: 'Pin Mock Location',
        onTapFunction: () async {
          if (_selectedMockLocation != null) {
            await MockLocationDao.instance.insertPinnedMockLocation(_selectedMockLocation!);
            if (mounted) {
              WidgetUtils.showToastMessage(context, 'Successfully pinned the mock location');
            }
            _selectedMockLocation = null;
            widget.callback();
          } else {
            LogUtil.debug(_tag, 'No mock Location selected for Pinning');
          }
        });
  }

  _getUnpinButton(final BuildContext context, final MockLocation pinnedMockLocation) {
    return WidgetUtils.getRoundedButton(
        context: context,
        buttonText: 'Unpin Mock Location',
        onTapFunction: () async {
          dynamic result = await MockLocationDao.instance.deletePinnedMockLocation();
          LogUtil.debug(_tag, 'Delete result for Pinned Mock Location. Result : $result');
          if (mounted) {
            WidgetUtils.showToastMessage(context, 'Successfully unpinned, the pinned mock location');
          }
          widget.callback();
        });
  }

  Future<PinnedLocationAndMockLocations> _getPinnedLocationAndMockLocations() async {
    LogUtil.debug(_tag, 'Creating PinnedLocationAndMockLocations Future');
    final MockLocation? pinnedLocation = await MockLocationDao.instance.getPinnedMockLocation();
    final List<MockLocation> allLocations = await MockLocationDao.instance.getAllMockLocations();
    LogUtil.debug(_tag, 'Returning PinnedLocationAndMockLocations Instance');
    return PinnedLocationAndMockLocations(pinnedLocation, allLocations);
  }

  _getTileForMockLocations(final List<MockLocation> mockLocations) {
    final titleTxt = _selectedMockLocation != null
        ? 'Pin : ${_selectedMockLocation!.addressLine}, ${_selectedMockLocation!.state}, ${_selectedMockLocation!.country}'
        : 'Pin a Location';
    return ExpansionTile(
        title: Text(titleTxt, style: Theme.of(context).textTheme.titleMedium,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
        leading: const Icon(Icons.location_on_outlined, size: 30),
        children: _getLocationRadioTiles(mockLocations));
  }

  _getLocationRadioTiles(final List<MockLocation> mockLocations) {
    final List<Widget> placeWidgets = [];
    Places.getPlaces().forEach((place) {
      final MockLocation mockLocation = MockLocation(
          id: 'un-deletable',
          addressLine: place.addressLine,
          city: '',
          state: place.state,
          country: place.country,
          latitude: place.latitude,
          longitude: place.longitude);
      placeWidgets.add(_getLocationRadioTile(mockLocation));
    });
    for (var location in mockLocations) {
      placeWidgets.add(_getLocationRadioTile(location));
    }
    return placeWidgets;
  }

  _getLocationRadioTile(final MockLocation mockLocation) {
    return RadioListTile<MockLocation>(
        value: mockLocation,
        groupValue: _selectedMockLocation,
        onChanged: (newVal) {
          setState(() {
            if (newVal != null) {
              _selectedMockLocation = newVal;
            }
          });
        },
        title: Text('${mockLocation.addressLine}, ${mockLocation.state}, ${mockLocation.country}',
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor,
            style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(
            'lat : ${mockLocation.latitude.toStringAsFixed(5)}, long : ${mockLocation.longitude.toStringAsFixed(5)}',
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor,
            style: Theme.of(context).textTheme.bodyMedium));
  }
}

class PinnedLocationAndMockLocations {
  final MockLocation? pinnedMockLocation;
  final List<MockLocation> allMockLocations;

  PinnedLocationAndMockLocations(this.pinnedMockLocation, this.allMockLocations);
}
