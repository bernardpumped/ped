import 'package:flutter/material.dart';

class NoUpdateHistory extends StatelessWidget {
  const NoUpdateHistory({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('No Update History', style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center),
              Text(
                  "\n Your updates to fuel prices, operating hours, features or suggestions appear here.",
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center),
              Text('\n You have not updated any information and hence the empty page.',
                  style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.center)
            ]));
  }
}