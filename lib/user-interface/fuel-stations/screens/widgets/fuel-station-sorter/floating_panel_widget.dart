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
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';

enum PanelState { open, closed }

enum ExpansionDirection { horizontal, vertical }

class FloatBoxPanelWidget extends StatefulWidget {
  final double size;
  final double iconSize;
  final IconData panelIcon;
  final Color backgroundColor;
  final Color contentColor;
  final Color nonSelColor;
  final List<IconData> buttons;
  final List<String> buttonLabels;
  final Function(int) onPressed;
  final int selIndex;
  final ExpansionDirection expansionDirection;

  const FloatBoxPanelWidget(
      {required this.buttons,
      required this.buttonLabels,
      required this.iconSize,
      required this.panelIcon,
      required this.size,
      required this.backgroundColor,
      required this.contentColor,
      required this.nonSelColor,
      required this.onPressed,
      required this.selIndex,
      this.expansionDirection = ExpansionDirection.horizontal,
      key})
      : super(key: key);

  @override
  State<FloatBoxPanelWidget> createState() => _FloatBoxState();
}

class _FloatBoxState extends State<FloatBoxPanelWidget> {
  PanelState _panelState = PanelState.closed;

  @override
  Widget build(final BuildContext context) {
    final List<IconData> buttons = widget.buttons;

    double totalButtons() {
      return widget.buttons.length.toDouble();
    }

    double panelHeight() {
      if (widget.expansionDirection == ExpansionDirection.vertical) {
        if (_panelState == PanelState.open) {
          return (widget.size + (widget.size + 1) * totalButtons());
        } else {
          return widget.size;
        }
      }
      return widget.size;
    }

    double panelWidth() {
      if (widget.expansionDirection == ExpansionDirection.horizontal) {
        if (_panelState == PanelState.open) {
          return (widget.size + (widget.size + 1) * totalButtons()) * 1.6;
        } else {
          return widget.size;
        }
      }
      return widget.size;
    }

    getActionButtonList() {
      return List.generate(buttons.length, (index) {
        return GestureDetector(
            onTap: () {
              widget.onPressed(index);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: _FloatButton(
                  expansionDirection: widget.expansionDirection,
                  size: widget.size,
                  icon: buttons[index],
                  label: widget.buttonLabels[index],
                  color: (index != widget.selIndex ? widget.nonSelColor : widget.contentColor),
                  iconSize: widget.iconSize),
            ));
      });
    }

    getActionButton() {
      if (widget.expansionDirection == ExpansionDirection.horizontal) {
        return Row(children: getActionButtonList());
      } else {
        return Column(children: getActionButtonList());
      }
    }

    getWrapDirection() {
      if (widget.expansionDirection == ExpansionDirection.horizontal) {
        return Axis.vertical;
      }
      return Axis.horizontal;
    }

    return AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        width: panelWidth(),
        height: panelHeight(),
        decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(55)),
        curve: Curves.fastLinearToSlowEaseIn,
        child: Wrap(direction: getWrapDirection(), children: [
          GestureDetector(
              onPanUpdate: (event) {
                setState(() {
                  _panelState = PanelState.closed;
                });
              },
              onTap: () {
                setState(() {
                  if (_panelState == PanelState.open) {
                    _panelState = PanelState.closed;
                  } else {
                    _panelState = PanelState.open;
                  }
                });
              },
              child: _FloatButton(
                size: widget.size,
                icon: getTopIcon(),
                color: widget.contentColor,
                iconSize: widget.iconSize,
                label: '',
              )),
          Visibility(visible: _panelState == PanelState.open, child: getActionButton())
        ]));
  }

  IconData getTopIcon() {
    if (_panelState == PanelState.open) {
      return Icons.close;
    }
    if (_panelState == PanelState.closed) {
      if (widget.selIndex >= 0) {
        return widget.buttons[widget.selIndex];
      }
    }
    return widget.panelIcon;
  }
}

class _FloatButton extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;
  final String label;
  final double iconSize;
  final ExpansionDirection expansionDirection;

  const _FloatButton(
      {required this.size,
      required this.color,
      required this.icon,
      required this.iconSize,
      this.expansionDirection = ExpansionDirection.vertical,
      required this.label});

  @override
  Widget build(final BuildContext context) {
    if (expansionDirection == ExpansionDirection.horizontal) {
      return Container(
          color: Theme.of(context).colorScheme.background.withOpacity(0.0),
          width: size * 1.7,
          height: size,
          child: Row(
            children: [
              Icon(icon, color: color, size: iconSize),
              const SizedBox(width: 3),
              Expanded(
                  child: Text(label,
                      textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(overflow: TextOverflow.ellipsis, color: Theme.of(context).colorScheme.background)))
            ],
          ));
    }
    return Container(
        color: Theme.of(context).colorScheme.background.withOpacity(0.0),
        width: size,
        height: size,
        child: Icon(icon, color: color, size: iconSize));
  }
}
