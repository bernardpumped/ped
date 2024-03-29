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
import 'package:pumped_end_device/data/local/dao2/mock_location_dao.dart';
import 'package:pumped_end_device/data/local/model/mock_location.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class DeleteMockLocation extends StatefulWidget {
  final Function() callback;
  const DeleteMockLocation({super.key, required this.callback});

  @override
  State<DeleteMockLocation> createState() => _DeleteMockLocationState();
}

class _DeleteMockLocationState extends State<DeleteMockLocation> {
  static const _tag = 'DeleteMockLocation';
  MockLocation? _selectedMockLocation;

  @override
  Widget build(final BuildContext context) {
    return Column(children: [
      _getFutureBuilder(),
      Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 15.0, bottom: 15.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            OutlinedButton(
                onPressed: () async {
                  if (_selectedMockLocation != null) {
                    dynamic result = await MockLocationDao.instance.deleteMockLocation(_selectedMockLocation!);
                    LogUtil.debug(_tag, 'Delete result for Mock Location. Result : $result');
                    if (mounted) {
                      if (result) {
                        WidgetUtils.showToastMessage(context, 'Successfully deleted the mock location');
                      } else {
                        WidgetUtils.showToastMessage(context, 'Cannot delete the mock location, as it is pinned');
                      }
                    }
                    _selectedMockLocation = null;
                    widget.callback();
                  } else {
                    LogUtil.debug(_tag, 'No mock Location selected for delete');
                  }
                },
                child: Text('Delete Mock Location', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
          ]))
    ]);
  }

  _getFutureBuilder() {
    Future<List<MockLocation>> future = MockLocationDao.instance.getAllMockLocations();
    final titleTxt = _selectedMockLocation != null
        ? 'Delete : ${_selectedMockLocation!.addressLine}, ${_selectedMockLocation!.state}, ${_selectedMockLocation!.country}'
        : 'Select a Location to delete';
    return FutureBuilder<List<MockLocation>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<MockLocation> allMockLocations = snapshot.data!;
            if (allMockLocations.isNotEmpty) {
              return ExpansionTile(
                  title: Expanded(
                    child: Text(titleTxt, style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                  ),
                  leading: const Icon(Icons.edit_location_outlined, size: 30),
                  children: _getLocationWidgets(allMockLocations));
            } else {
              return ListTile(
                  leading: const Icon(Icons.edit_location_outlined, size: 30),
                  title: Text('No custom mock locations present', style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
            }
          } else if (snapshot.hasError) {
            return ListTile(
                leading: const Icon(Icons.edit_location_outlined, size: 30),
                title: Text('Error Loading mock Locations', style: Theme.of(context).textTheme.titleMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
          } else {
            return ListTile(
                leading: const Icon(Icons.edit_location_outlined, size: 30),
                title: Text('Loading mock Locations', style: Theme.of(context).textTheme.titleMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
          }
        });
  }

  _getLocationWidgets(final List<MockLocation> allMockLocations) {
    final List<Widget> placeWidgets = [];
    for (var mockLocation in allMockLocations) {
      placeWidgets.add(_getLocationRadioTile(mockLocation));
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
            } else {
              LogUtil.debug(_tag, 'changed newVal is null');
            }
          });
        },
        title: Text('${mockLocation.addressLine}, ${mockLocation.state}, ${mockLocation.country}',
            style: Theme.of(context).textTheme.bodyLarge, textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
        subtitle: Text(
            'lat : ${mockLocation.latitude.toStringAsFixed(5)}, long : ${mockLocation.longitude.toStringAsFixed(5)}',
            style: Theme.of(context).textTheme.bodyMedium, textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }
}
