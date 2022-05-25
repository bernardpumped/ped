import 'package:flutter/material.dart';

class NoFuelPricesWidget extends StatelessWidget {
  const NoFuelPricesWidget({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('No Fuel Prices',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center),
              Text(
                  "\n Click here if you'd appreciate this station providing accurate prices we'll let them know",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center),
              Text('\n Come back again soon.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center)
            ]));
  }

}