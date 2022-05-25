import 'package:flutter/material.dart';

class FuelStationLogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final ImageProvider image;
  final double padding;
  final double borderRadius;
  const FuelStationLogoWidget(
      {Key? key,
      required this.width,
      required this.height,
      required this.image,
      this.padding = 8,
      this.borderRadius = 10})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Material(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(padding),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(fit: BoxFit.scaleDown, image: image)))));
  }
}
