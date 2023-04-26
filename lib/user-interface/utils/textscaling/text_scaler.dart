import 'package:flutter/material.dart';

class _ScalingFactorBindingScope<T> extends InheritedWidget {
  const _ScalingFactorBindingScope({Key? key, required this.scalingFactorBindingState, required Widget child})  : super(key: key, child: child);

  final TextScalerState<T> scalingFactorBindingState;

  @override
  bool updateShouldNotify(final _ScalingFactorBindingScope old) {
    return true;
  }
}

class TextScaler<T> extends StatefulWidget {
  const TextScaler({Key? key, required this.initialScaleFactor, required this.child}) : super(key: key);

  final T initialScaleFactor;
  final Widget child;

  @override
  TextScalerState<T> createState() => TextScalerState<T>();

  static T? of<T>(BuildContext context) {
    final _ScalingFactorBindingScope<T>? scope = context.dependOnInheritedWidgetOfExactType<_ScalingFactorBindingScope<T>>();
    return scope?.scalingFactorBindingState.currentValue;
  }

  static void update<T>(BuildContext context, T newModel) {
    final _ScalingFactorBindingScope<dynamic>? scope = context.dependOnInheritedWidgetOfExactType<_ScalingFactorBindingScope<T>>();
    scope?.scalingFactorBindingState.updateModel(newModel);
  }
}

class TextScalerState<T> extends State<TextScaler<T>> {
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