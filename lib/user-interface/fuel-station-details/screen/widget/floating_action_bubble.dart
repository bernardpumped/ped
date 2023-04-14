import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';

class FloatingActionBubble extends AnimatedWidget {
  const FloatingActionBubble(
      {Key? key,
      required this.items,
      required this.onPress,
      required Animation animation,
      this.herotag,
      this.iconData,
      this.animatedIconData})
      : assert((iconData == null && animatedIconData != null) || (iconData != null && animatedIconData == null)),
        super(listenable: animation, key: key);

  final List<Bubble> items;
  final void Function() onPress;
  final AnimatedIconData? animatedIconData;
  final Object? herotag;
  final IconData? iconData;

  get _animation => listenable;

  Widget buildItem(final BuildContext context, final int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    TextDirection textDirection = Directionality.of(context);
    double animationDirection = textDirection == TextDirection.ltr ? -1 : 1;
    final transform = Matrix4.translationValues(
        animationDirection * (screenWidth - _animation.value * screenWidth) * ((items.length - index) / 4), 0.0, 0.0);

    return Align(
        alignment: textDirection == TextDirection.ltr ? Alignment.centerRight : Alignment.centerLeft,
        child: Transform(
            transform: transform, child: Opacity(opacity: _animation.value, child: BubbleMenu(items[index]))));
  }

  @override
  Widget build(final BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
      IgnorePointer(
          ignoring: _animation.value == 0,
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 12.0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: items.length,
              itemBuilder: buildItem)),
      FloatingActionButton(
          heroTag: herotag ?? const _DefaultHeroTag(),
          backgroundColor: Theme.of(context).highlightColor,
          onPressed: onPress,
          child: iconData == null
              ? AnimatedIcon(icon: animatedIconData!, progress: _animation, color: Theme.of(context).colorScheme.background)
              : Icon(iconData, color: Theme.of(context).colorScheme.background))
    ]);
  }
}

class Bubble {
  const Bubble({required IconData icon, required String title, required this.onPress})
      : _icon = icon,
        _title = title;

  final IconData _icon;
  final String _title;
  final void Function() onPress;
}

class BubbleMenu extends StatelessWidget {
  const BubbleMenu(this.item, {Key? key}) : super(key: key);
  final Bubble item;

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
        clipBehavior: Clip.antiAlias,
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))),
        onPressed: item.onPress,
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(item._icon, color: Theme.of(context).colorScheme.background),
              const SizedBox(width: 10),
              Text(item._title, textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)
            ])));
  }
}

class _DefaultHeroTag {
  const _DefaultHeroTag();
  @override
  String toString() => '<default FloatingActionBubble tag>';
}
