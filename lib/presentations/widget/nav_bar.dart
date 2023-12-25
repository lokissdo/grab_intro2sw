import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String backText;
  final String title;
  const NavBar({ 
    Key? key,
    required this.title,
     this.backText = "Trở lại" ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-20, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, maxWidth: 48),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
           Text(backText),
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(
                    right: 50.0), // Adjust the right margin as needed
                child:  Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
