import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';

class NoUpdateHistory extends StatelessWidget {
  const NoUpdateHistory({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('No Update History', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,
                  textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
              Text(
                  "\n Your updates to fuel prices, operating hours, features or suggestions appear here.",
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                  textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
              Expanded(
                child: Text('\n You have not updated any information and hence the empty page.',
                    style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
              )
            ]));
  }
}