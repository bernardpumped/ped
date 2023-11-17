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

class _ScalingFactorBindingScope<T> extends InheritedWidget {
  const _ScalingFactorBindingScope({Key? key, required this.scalingFactorBindingState, required Widget child})  : super(key: key, child: child);

  final PedTextScalerState<T> scalingFactorBindingState;

  @override
  bool updateShouldNotify(final _ScalingFactorBindingScope old) {
    return true;
  }
}

class PedTextScaler<T> extends StatefulWidget {
  const PedTextScaler({Key? key, required this.initialScaleFactor, required this.child}) : super(key: key);

  final T initialScaleFactor;
  final Widget child;

  @override
  PedTextScalerState<T> createState() => PedTextScalerState<T>();

  static T? of<T>(BuildContext context) {
    final _ScalingFactorBindingScope<T>? scope = context.dependOnInheritedWidgetOfExactType<_ScalingFactorBindingScope<T>>();
    return scope?.scalingFactorBindingState.currentValue;
  }

  static void update<T>(BuildContext context, T newModel) {
    final _ScalingFactorBindingScope<dynamic>? scope = context.dependOnInheritedWidgetOfExactType<_ScalingFactorBindingScope<T>>();
    scope?.scalingFactorBindingState.updateModel(newModel);
  }
}

class PedTextScalerState<T> extends State<PedTextScaler<T>> {
  T? currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialScaleFactor;
  }

  void updateModel(T newModel) {
    if (newModel != currentValue) {
      setState(() {
        currentValue = newModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ScalingFactorBindingScope<T>(
      scalingFactorBindingState: this,
      child: widget.child,
    );
  }
}