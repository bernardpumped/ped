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
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/model/operating_time_range.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/data/remote/model/response/get_fuel_station_operating_hrs_response.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/operating_hours_source_citation.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/app_theme.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:sprintf/sprintf.dart';

class OperatingHoursWidget extends StatefulWidget {
  final Future<GetFuelStationOperatingHrsResponse>? operatingHrsResponseFuture;
  final FuelStation fuelStation;
  const OperatingHoursWidget({Key? key, required this.operatingHrsResponseFuture, required this.fuelStation})
      : super(key: key);

  @override
  State<OperatingHoursWidget> createState() => _OperatingHoursWidgetState();
}

class _OperatingHoursWidgetState extends State<OperatingHoursWidget> {
  static const _tag = 'OperatingHoursWidget';
  late TextStyle _closedStyle;
  late TextStyle _openStatusStyle;

  bool _operatingHoursExpanded = false;

  @override
  Widget build(final BuildContext context) {
    _closedStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppTheme.stationCloseColor);
    _openStatusStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppTheme.stationOpenColor);
    return FutureBuilder<GetFuelStationOperatingHrsResponse>(
        future: widget.operatingHrsResponseFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error ${snapshot.error}');
            return Text('Error Loading Operating Hours',
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else if (snapshot.hasData) {
            final GetFuelStationOperatingHrsResponse data = snapshot.data!;
            if (data.responseCode != 'SUCCESS') {
              return ListTile(
                  title: Text('Error Loading',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                      textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor));
            } else {
              final FuelStationOperatingHrs? fuelStationOperatingHrs = data.fuelStationOperatingHrs;
              widget.fuelStation.fuelStationOperatingHrs = fuelStationOperatingHrs;
              List<OperatingHours>? weeklyOperatingHrs = fuelStationOperatingHrs?.weeklyOperatingHrs;
              if (weeklyOperatingHrs != null && weeklyOperatingHrs.isNotEmpty) {
                return ExpansionTile(
                    initiallyExpanded: false,
                    leading: const Icon(Icons.access_time_outlined, size: 36),
                    title: _getOpenClosed(weeklyOperatingHrs),
                    key: const PageStorageKey<String>("open-close"),
                    trailing: ExpandIcon(
                        isExpanded: _operatingHoursExpanded,
                        onPressed: (bool value) {
                          setState(() {});
                        }),
                    children: _buildColumnContent(weeklyOperatingHrs),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _operatingHoursExpanded = expanded;
                      });
                    });
              } else {
                return const SizedBox(height: 0);
              }
            }
          } else {
            return ListTile(
                leading: const Icon(Icons.access_time, size: 30),
                title: Text('Loading Operating Hours...', style: Theme.of(context).textTheme.headlineSmall,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor));
          }
        });
  }

  Widget _getOpenClosed(final List<OperatingHours> weeklyOperatingHrs) {
    final String currentWeekDay = DateTimeUtils.weekDayIntToShortName[DateTime.now().weekday]!;
    final OperatingHours? currentDayOperatingHrs = _getOperatingHrsForDay(weeklyOperatingHrs, currentWeekDay);
    int? currentDayOpeningHrs = currentDayOperatingHrs?.openingHrs;
    int? currentDayOpeningMins = currentDayOperatingHrs?.openingMins;
    int? currentDayClosingHrs = currentDayOperatingHrs?.closingHrs;
    int? currentDayClosingMins = currentDayOperatingHrs?.closingMins;
    if (currentDayOperatingHrs != null && OperatingTimeRange.alwaysOpen == currentDayOperatingHrs.operatingTimeRange) {
      currentDayOpeningHrs = 0;
      currentDayOpeningMins = 0;
      currentDayClosingHrs = 23;
      currentDayClosingMins = 59;
    }
    int currentHours = DateTime.now().hour;
    int currentMin = DateTime.now().minute;
    String currentStatus;
    String nextEventStatus;
    TextStyle currentStatusStyle;
    TextStyle nextEventStyle;

    if ((currentDayOpeningHrs != null &&
            currentDayOpeningMins != null &&
            currentDayClosingHrs != null &&
            currentDayClosingMins != null) &&
        (currentHours > currentDayOpeningHrs && currentHours < currentDayClosingHrs ||
            currentHours == currentDayOpeningHrs && currentHours < currentDayClosingHrs ||
            currentHours == currentDayClosingHrs && currentMin < currentDayClosingMins)) {
      if (OperatingTimeRange.alwaysOpen == currentDayOperatingHrs?.operatingTimeRange) {
        currentStatus = 'Open 24 Hours';
        currentStatusStyle = _openStatusStyle;
        nextEventStatus = '';
        nextEventStyle = _openStatusStyle;
      } else {
        currentStatus = 'Now Open. ';
        currentStatusStyle = _openStatusStyle;
        nextEventStatus = 'Closes $currentDayClosingHrs: $currentDayClosingMins';
        nextEventStyle = _closedStyle;
      }
    } else {
      currentStatus = 'Closed. ';
      currentStatusStyle = _closedStyle;
      final OperatingHours? nextDayOperatingHrs = _getOperatingHrsForNextDay(weeklyOperatingHrs, currentWeekDay);
      if (nextDayOperatingHrs != null) {
        int? nextDayOpeningHrs = nextDayOperatingHrs.openingHrs;
        int? nextDayOpeningMins = nextDayOperatingHrs.openingMins;
        if (currentDayOperatingHrs != null &&
            OperatingTimeRange.alwaysOpen == currentDayOperatingHrs.operatingTimeRange) {
          nextDayOpeningHrs = 0;
          nextDayOpeningMins = 0;
        }
        if (nextDayOpeningHrs != null && nextDayOpeningMins != null) {
          nextEventStatus = sprintf('Opens %s %02d:%02d',
              [nextDayOperatingHrs.dayOfWeek, nextDayOperatingHrs.openingHrs, nextDayOperatingHrs.openingMins]);
        } else {
          nextEventStatus = 'Opens ${nextDayOperatingHrs.dayOfWeek}';
        }
        nextEventStyle = _openStatusStyle;
      } else {
        nextEventStatus = 'Not known';
        nextEventStyle = _closedStyle;
      }
    }
    return Container(
        child: !_operatingHoursExpanded
            ? RichText(
                textAlign: TextAlign.left,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)!.scaleFactor,
                text: TextSpan(children: [
                  TextSpan(text: currentStatus, style: currentStatusStyle),
                  TextSpan(text: nextEventStatus, style: nextEventStyle)
                ]))
            : Text(currentStatus, style: currentStatusStyle,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }

  OperatingHours? _getOperatingHrsForDay(final List<OperatingHours> weeklyOperatingHrs, final String? currentWeekDay) {
    for (final OperatingHours operatingHours in weeklyOperatingHrs) {
      if (operatingHours.dayOfWeek == currentWeekDay) {
        return operatingHours;
      }
    }
    return null;
  }

  OperatingHours? _getOperatingHrsForNextDay(
      final List<OperatingHours> weeklyOperatingHrs, final String currentWeekDay) {
    String? day = currentWeekDay;
    OperatingHours? operatingHours;
    do {
      day = DateTimeUtils.getNextDay(day);
      operatingHours = _getOperatingHrsForDay(weeklyOperatingHrs, day);
    } while (day != currentWeekDay && operatingHours == null);
    return operatingHours;
  }

  List<Widget> _buildColumnContent(final List<OperatingHours> weeklyOperatingHrs) {
    final List<Widget> columnContent = [];
    for (final OperatingHours dailyOperatingHrs in weeklyOperatingHrs) {
      final String weekDay = DateTimeUtils.weekDayShortToLongName[dailyOperatingHrs.dayOfWeek]!;
      String operatingTimeRange = '';
      if (DataUtils.isNotBlank(dailyOperatingHrs.operatingTimeRange)) {
        switch (dailyOperatingHrs.operatingTimeRange) {
          case OperatingTimeRange.alwaysOpen:
            operatingTimeRange = 'Open 24 Hours';
            break;
          case OperatingTimeRange.closed:
            operatingTimeRange = 'Closed';
            break;
          default:
            operatingTimeRange = sprintf('%02d:%02d - %02d:%02d', [
              dailyOperatingHrs.openingHrs,
              dailyOperatingHrs.openingMins,
              dailyOperatingHrs.closingHrs,
              dailyOperatingHrs.closingMins
            ]);
            break;
        }
      } else {
        operatingTimeRange = '- - -';
      }
      columnContent.add(Padding(
          padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Expanded(
                flex: 6,
                child: Text(weekDay, textAlign: TextAlign.start, style: Theme.of(context).textTheme.headlineSmall,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
            Expanded(
                flex: 6,
                child:
                    Text(operatingTimeRange, textAlign: TextAlign.start, style: Theme.of(context).textTheme.headlineSmall,
                        textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
            Expanded(flex: 1, child: _getOperatingHoursSourceCitation(dailyOperatingHrs, weekDay, operatingTimeRange))
          ])));
      columnContent.add(const Divider(thickness: .5, height: 1));
    }
    return columnContent;
  }

  GestureDetector _getOperatingHoursSourceCitation(
      final OperatingHours operatingHours, final String weekDay, final String operatingTimeRange) {
    final Icon sourceIcon = (operatingHours.operatingTimeSource == 'G' || operatingHours.operatingTimeSource == 'F')
        ? const Icon(Icons.info_outline, size: 30)
        : const Icon(Icons.people_alt_outlined, size: 30);
    return GestureDetector(
        onTap: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (final BuildContext context) {
                return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    content:
                        OperatingHoursSourceCitation(operatingHours, widget.fuelStation, weekDay, operatingTimeRange));
              });
        },
        child: sourceIcon);
  }
}
