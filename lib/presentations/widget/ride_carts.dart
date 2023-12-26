import 'package:flutter/material.dart';
import 'package:grab/presentations/widget/ride_cart.dart';


class RideCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RideCard(),
        RideCard(),
        RideCard(),
      ],
    );
  }
}