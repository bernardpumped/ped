import 'package:flutter/material.dart';

class Invisible extends StatelessWidget {
  final bool invisible;
  final Widget? child;
  const Invisible({
    super.key,
    this.child,
    this.invisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !invisible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: child!,
    );
  }
}