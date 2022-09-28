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

class UpdateHistoryDetailsSuggestEditItemWidget extends StatelessWidget {
  final String valueType;
  final dynamic originalValue;
  final dynamic updateValue;
  final Map<String, dynamic>? serverExceptions;
  final List<dynamic>? recordLevelExceptions;

  const UpdateHistoryDetailsSuggestEditItemWidget(
      {Key? key,
      required this.valueType,
      this.originalValue,
      this.updateValue,
      this.serverExceptions,
      this.recordLevelExceptions})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final updateStatus = _getUpdateResult();
    return Card(
        margin: const EdgeInsets.all(2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Text('Suggestion', style: Theme.of(context).textTheme.bodyText1)),
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Text(updateValue,
                  style: Theme.of(context).textTheme.bodyText1,
                  softWrap: true,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis)),
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 12),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('Status', style: Theme.of(context).textTheme.bodyText1)),
                Expanded(flex: 1, child: Text(updateStatus, style: Theme.of(context).textTheme.bodyText1))
              ]))
        ]));
  }

  String _getUpdateResult() {
    if (serverExceptions == null || serverExceptions!.isEmpty) {
      return 'Success';
    } else {
      return _getTranslatedUpdateResult();
    }
  }

  String _getTranslatedUpdateResult() {
    return 'Failed';
  }
}
