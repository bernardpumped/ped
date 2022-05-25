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

enum PanelShape { rectangle, rounded }

enum DockType { inside, outside }

enum PanelState { open, closed }

class FloatBoxPanelWidget extends StatefulWidget {
  final double? positionTop;
  final double? positionLeft;
  final Color? borderColor;
  final double? borderWidth;
  final double? size;
  final double? iconSize;
  final IconData? panelIcon;
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color contentColor;
  final Color nonSelColor;
  final PanelShape? panelShape;
  final PanelState? panelState;
  final double? panelOpenOffset;
  final int? panelAnimDuration;
  final Curve? panelAnimCurve;
  final DockType? dockType;
  final double? dockOffset;
  final int? dockAnimDuration;
  final Curve? dockAnimCurve;
  final List<IconData> buttons;
  final Function(int) onPressed;
  final int selIndex;

  const FloatBoxPanelWidget(
      {required this.buttons,
      this.positionTop,
      this.positionLeft,
      this.borderColor,
      this.borderWidth,
      this.iconSize,
      this.panelIcon,
      this.size,
      this.borderRadius,
      this.panelState,
      this.panelOpenOffset,
      this.panelAnimDuration,
      this.panelAnimCurve,
      required this.backgroundColor,
      required this.contentColor,
      required this.nonSelColor,
      this.panelShape,
      this.dockType,
      this.dockOffset,
      this.dockAnimCurve,
      this.dockAnimDuration,
      required this.onPressed,
      required this.selIndex,
      key})
      : super(key: key);

  @override
  State<FloatBoxPanelWidget> createState() => _FloatBoxState();
}

class _FloatBoxState extends State<FloatBoxPanelWidget> {
  static const _defaultWidth = 55.0;
  // Required to set the default state to closed when the widget gets initialized;
  PanelState _panelState = PanelState.closed;

  // Default positions for the panel;
  double _positionTop = 0.0;
  double _positionLeft = 0.0;

  // ** PanOffset ** is used to calculate the distance from the edge of the panel
  // to the cursor, to calculate the position when being dragged;
  double _panOffsetTop = 0.0;
  double _panOffsetLeft = 0.0;

  @override
  void initState() {
    _positionTop = widget.positionTop ?? 0;
    _positionLeft = widget.positionLeft ?? 0;

    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    // Width and height of page is required for the dragging the panel;
    final double pageWidth = MediaQuery.of(context).size.width;
    final double pageHeight = MediaQuery.of(context).size.height;

    // All Buttons;
    final List<IconData> buttons = widget.buttons;

    // Dock offset creates the boundary for the page depending on the DockType;
    final double dockOffset = widget.dockOffset ?? 20.0;

    // Widget size if the width of the panel;
    final double widgetSize = widget.size ?? _defaultWidth;

    // **** METHODS ****

    // Dock boundary is calculated according to the dock offset and dock type.
    double _dockBoundary() {
      if (widget.dockType != null && widget.dockType == DockType.inside) {
        // If it's an 'inside' type dock, dock offset will remain the same;
        return dockOffset;
      } else {
        // If it's an 'outside' type dock, dock offset will be inverted, hence
        // negative value;
        return -dockOffset;
      }
    }

    // If panel shape is set to rectangle, the border radius will be set to custom
    // border radius property of the WIDGET, else it will be set to the size of
    // widget to make all corners rounded.
    BorderRadius _borderRadius() {
      if (widget.panelShape != null && widget.panelShape == PanelShape.rectangle) {
        // If panel shape is 'rectangle', border radius can be set to custom or 0;
        return widget.borderRadius ?? BorderRadius.circular(0);
      } else {
        // If panel shape is 'rounded', border radius will be the size of widget
        // to make it rounded;
        return BorderRadius.circular(widgetSize);
      }
    }

    // Total buttons are required to calculate the height of the panel;
    double _totalButtons() {
      return widget.buttons.length.toDouble();
    }

    // Height of the panel according to the panel state;
    double _panelHeight() {
      if (_panelState == PanelState.open) {
        // Panel height will be in multiple of total buttons, I have added "1"
        // digit height for each button to fix the overflow issue. Don't know
        // what's causing this, but adding "1" fixed the problem for now.
        return (widgetSize + (widgetSize + 1) * _totalButtons()) + (widget.borderWidth ?? 0);
      } else {
        return widgetSize + (widget.borderWidth ?? 0) * 2;
      }
    }

    // Panel top needs to be recalculated while opening the panel, to make sure
    // the height doesn't exceed the bottom of the page;
    void _calcPanelTop() {
      if (_positionTop + _panelHeight() > pageHeight + _dockBoundary()) {
        _positionTop = pageHeight - _panelHeight() + _dockBoundary();
      }
    }

    // Dock Left position when open;
    double _openDockLeft() {
      if (_positionLeft < (pageWidth / 2)) {
        // If panel is docked to the left;
        return widget.panelOpenOffset ?? 30.0;
      } else {
        // If panel is docked to the right;
        return ((pageWidth - widgetSize)) - (widget.panelOpenOffset ?? 30.0);
      }
    }

    // Panel border is only enabled if the border width is greater than 0;
    Border? _panelBorder() {
      if (widget.borderWidth != null && widget.borderWidth! > 0) {
        return Border.all(
          color: widget.borderColor ?? const Color(0xFF333333),
          width: widget.borderWidth ?? 0.0,
        );
      } else {
        return null;
      }
    }

    // Force dock will dock the panel to it's nearest edge of the screen;
    void _forceDock() {
      // Calculate the center of the panel;
      final double center = _positionLeft + (widgetSize / 2);
      // Check if the position of center of the panel is less than half of the
      // page;
      if (center < pageWidth / 2) {
        // Dock to the left edge;
        _positionLeft = 0.0 + _dockBoundary();
      } else {
        // Dock to the right edge;
        _positionLeft = (pageWidth - widgetSize) - _dockBoundary();
      }
    }

    // Animated positioned widget can be moved to any part of the screen with
    // animation;
    return AnimatedContainer(
        duration: Duration(milliseconds: widget.panelAnimDuration ?? 600),
        width: widgetSize,
        height: _panelHeight(),
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: _borderRadius(),
            border: _panelBorder()),
        curve: widget.panelAnimCurve ?? Curves.fastLinearToSlowEaseIn,
        child: Wrap(direction: Axis.horizontal, children: [
          // Gesture detector is required to detect the tap and drag on the panel;
          GestureDetector(
              onPanEnd: (event) {
                setState(() {
                  _forceDock();
                });
              },
              onPanStart: (event) {
                // Detect the offset between the top and left side of the panel and
                // x and y position of the touch(click) event;
                _panOffsetTop = event.globalPosition.dy - _positionTop;
                _panOffsetLeft = event.globalPosition.dx - _positionLeft;
              },
              onPanUpdate: (event) {
                setState(() {
                  // Close Panel if opened;
                  _panelState = PanelState.closed;
                  // Reset Movement Speed;
                  _positionTop = event.globalPosition.dy - _panOffsetTop;
                  // Check if the top position is exceeding the dock boundaries;
                  if (_positionTop < 0 + _dockBoundary()) {
                    _positionTop = 0 + _dockBoundary();
                  }
                  if (_positionTop > (pageHeight - _panelHeight()) - _dockBoundary()) {
                    _positionTop = (pageHeight - _panelHeight()) - _dockBoundary();
                  }
                  // Calculate the Left position of the panel according to pan;
                  _positionLeft = event.globalPosition.dx - _panOffsetLeft;
                  // Check if the left position is exceeding the dock boundaries;
                  if (_positionLeft < 0 + _dockBoundary()) {
                    _positionLeft = 0 + _dockBoundary();
                  }
                  if (_positionLeft > (pageWidth - widgetSize) - _dockBoundary()) {
                    _positionLeft = (pageWidth - widgetSize) - _dockBoundary();
                  }
                });
              },
              onTap: () {
                setState(() {
                  // Set the animation speed to custom duration;
                  if (_panelState == PanelState.open) {
                    // If panel state is "open", set it to "closed";
                    _panelState = PanelState.closed;
                    // Reset panel position, dock it to nearest edge;
                    _forceDock();
                  } else {
                    // If panel state is "closed", set it to "open";
                    _panelState = PanelState.open;
                    // Set the left side position;
                    _positionLeft = _openDockLeft();
                    _calcPanelTop();
                  }
                });
              },
              child: _FloatButton(
                  size: widget.size ?? _defaultWidth,
                  icon: getTopIcon(),
                  color: widget.contentColor,
                  iconSize: widget.iconSize ?? 24.0)),
          Visibility(
              visible: _panelState == PanelState.open,
              child: Column(
                  children: List.generate(buttons.length, (index) {
                return GestureDetector(
                    onTap: () {
                      widget.onPressed(index);
                    },
                    child: _FloatButton(
                        size: widget.size ?? _defaultWidth,
                        icon: buttons[index],
                        color: (index != widget.selIndex ? widget.nonSelColor : widget.contentColor),
                        iconSize: widget.iconSize ?? 24.0));
              })))
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
    return widget.panelIcon ?? Icons.add;
  }
}

class _FloatButton extends StatelessWidget {
  final double? size;
  final Color? color;
  final IconData? icon;
  final double? iconSize;

  const _FloatButton({this.size, this.color, this.icon, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white.withOpacity(0.0),
        width: size ?? _FloatBoxState._defaultWidth,
        height: size ?? _FloatBoxState._defaultWidth,
        child: Icon(icon ?? Icons.add, color: color ?? Colors.white, size: iconSize ?? 24.0));
  }
}
