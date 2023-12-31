import 'package:flutter/material.dart';

class NavBarAcceptRide extends StatelessWidget {
  final String title;

  NavBarAcceptRide({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        ElevatedButton(
          onPressed: () {
            // Your back button action
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text(
            'Back',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}