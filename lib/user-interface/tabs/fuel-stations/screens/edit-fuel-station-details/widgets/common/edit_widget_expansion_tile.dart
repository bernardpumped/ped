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

class EditWidgetExpansionTile extends StatefulWidget {
  final Function widgetExpanded;
  final Function setStateFunction;
  final String titleText;
  final Widget leadingWidget;
  final Icon leadingWidgetIcon;
  final String widgetKey;
  final bool cupertinoIcon;
  final List<Widget> children;

  const EditWidgetExpansionTile(
    this.leadingWidgetIcon,
    this.titleText,
    this.widgetKey,
    this.children,
    this.widgetExpanded,
    this.setStateFunction, {Key key,
    this.leadingWidget,
    this.cupertinoIcon = true,
  }) : super(key: key);
  @override
  _EditWidgetExpansionTileState createState() => _EditWidgetExpansionTileState();
}

class _EditWidgetExpansionTileState extends State<EditWidgetExpansionTile> {
  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).copyWith(backgroundColor: Colors.white);
    var title =
        Text(widget.titleText, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500));
    Widget leading;
    if (widget.leadingWidget != null) {
      leading = widget.leadingWidget;
    } else if (widget.leadingWidgetIcon != null) {
      leading = widget.leadingWidgetIcon;
    } else {
      leading = null;
    }
    return Theme(
        data: theme,
        child: ExpansionTile(
            initiallyExpanded: widget.widgetExpanded(),
            leading: leading,
            title: title,
            key: PageStorageKey<String>(widget.widgetKey),
            children: widget.children,
            onExpansionChanged: (expanded) {
              setState(() {
                widget.setStateFunction(expanded);
              });
            }));
  }
}
