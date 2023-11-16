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
import 'package:pumped_end_device/data/local/dao2/ui_settings_dao.dart';
import 'package:pumped_end_device/data/local/model/ui_settings.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:pumped_end_device/util/text_scale.dart';

class TextScalingScreen extends StatefulWidget {
  const TextScalingScreen({Key? key}) : super(key: key);

  @override
  State<TextScalingScreen> createState() => _TextScalingScreenState();
}

class _TextScalingScreenState extends State<TextScalingScreen> {
  static const _tag = 'TextScalingScreen';

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Row(children: [
                  const Icon(Icons.linear_scale_rounded, size: 35),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Text Scaling', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.left,
                        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                  )
                ])),
            _childWidget(),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  WidgetUtils.getRoundedButton(
                      context: context,
                      buttonText: 'Scale Text',
                      iconData: Icons.linear_scale_rounded,
                      onTapFunction: () {})
                ])))
          ]),
        ));
  }

  Widget _childWidget() {
    return FutureBuilder(
        future: _getUiSettings(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            UiSettings? uiSettings = snapShot.data as UiSettings?;
            if (uiSettings != null) {
              LogUtil.debug(_tag, 'Read UiSettings.textScale : ${uiSettings.textScale}');
              uiSettings.textScale ??= TextScale.systemTextScale;
            } else {
              uiSettings = UiSettings(textScale: TextScale.systemTextScale);
            }
            return Card(
                child: Column(children: [
                  _getMenuItem(TextScale.systemTextScale, uiSettings),
                  _getMenuItem(TextScale.smallTextScale, uiSettings),
                  _getMenuItem(TextScale.mediumTextScale, uiSettings),
                  _getMenuItem(TextScale.largeTextScale, uiSettings),
                  _getMenuItem(TextScale.hugeTextScale, uiSettings)
                ]));
          } else if (snapShot.hasError) {
            LogUtil.debug(_tag, 'Error found while loading UiSettings ${snapShot.error}');
            return Text('Error Loading',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.error),
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else {
            return Text('Loading', style: Theme.of(context).textTheme.titleMedium,
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        }
    );
  }

  Future<UiSettings?>? _getUiSettings() {
    return UiSettingsDao.instance.getUiSettings();
  }

  RadioListTile<String> _getMenuItem(final String textScale, final UiSettings uiSettings) {
    return RadioListTile<String>(
        value: textScale,
        selected: textScale == uiSettings.textScale,
        groupValue:  uiSettings.textScale,
        onChanged: (newTextScale) {
          LogUtil.debug(_tag, 'Selected TextScale $newTextScale');
          uiSettings.textScale = newTextScale!;
          double textScaleValue = TextScale.getTextScaleValue(newTextScale) as double;
          UiSettingsDao.instance.insertUiSettings(uiSettings).whenComplete(() {
            PedTextScaler.update(context, TextScalingFactor(scaleFactor: textScaleValue));
            LogUtil.debug(_tag, 'Inserted instance $newTextScale');
            if (mounted) {
              LogUtil.debug(_tag, 'Still mounted, calling setState');
              setState(() {});
            }
          });
          PedTextScaler.update(context, TextScalingFactor(scaleFactor: textScaleValue));
        },
        title: Text(TextScale.getTextScale(textScale), style: Theme.of(context).textTheme.titleLarge,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }
}
