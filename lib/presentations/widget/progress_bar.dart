import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: 30,
      height: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: LinearProgressIndicator(
          value: 0.7,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD6D6D6)),
          backgroundColor: Color(0xffD6D6D6),
        ),
      ),
    );
  }
}
