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

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/indicator.dart';

class UpdateDistributionPieChart extends StatefulWidget {
  final Map<UpdateType, double> _data;
  const UpdateDistributionPieChart(this._data, {Key? key}) : super(key: key);

  @override
  State<UpdateDistributionPieChart> createState() => _UpdateDistributionPieChartState();
}

class _UpdateDistributionPieChartState extends State<UpdateDistributionPieChart> {
  int _touchedIndex = -1;
  @override
  Widget build(final BuildContext context) {
    if (widget._data.isEmpty || noValues(widget._data)) {
      return const Center(
          child: Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No Update History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)))));
    }
    return AspectRatio(
        aspectRatio: 1,
        child: Card(
          surfaceTintColor: Colors.white,
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  const Text('Successful Updates',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.indigo)),
                  const SizedBox(height: 18),
                  Expanded(
                      child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(PieChartData(
                              pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    _touchedIndex = -1;
                                    return;
                                  }
                                  _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                });
                              }),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: _getPieChartSectionData(widget._data))))),
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getIndicators(widget._data))
                ]))));
  }

  static const Map<UpdateType, Color> _pieChartColors = {
    UpdateType.operatingTime: Color(0xffB34FAE),
    UpdateType.suggestEdit: Color(0xffF65D91),
    UpdateType.fuelStationFeatures: Color(0xffFF886F),
    UpdateType.addressDetails: Color(0xffFFC05C),
    UpdateType.price: Color(0xff3F51B5)
  };

  List<PieChartSectionData> _getPieChartSectionData(final Map<UpdateType, double> data) {
    final List<PieChartSectionData> pieChartSectionData = [];
    var i = 0;
    for (var entry in data.entries) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final double data = entry.value;
      final UpdateType updateType = entry.key;
      final double val = num.parse(data.toStringAsFixed(2)).toDouble();
      pieChartSectionData.add(PieChartSectionData(
          color: _pieChartColors[updateType],
          value: val,
          title: val.toString(),
          radius: radius,
          titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: const Color(0xffffffff))));
      i++;
    }
    return pieChartSectionData;
  }

  List<Widget> _getIndicators(final Map<UpdateType, double> data) {
    final List<Widget> indicators = [];
    for (var entry in data.entries) {
      final UpdateType updateType = entry.key;
      indicators.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Indicator(
              color: _pieChartColors[updateType]!, text: updateType.updateTypeReadableName!, isSquare: true)));
    }
    return indicators;
  }

  bool noValues(final Map<UpdateType, double> data) {
    double total = 0;
    for (var entry in data.entries) {
      total += entry.value;
    }
    return total == 0;
  }
}
