import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTextBox extends StatelessWidget {
  final String text;

  MyTextBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 150,
          color: Colors.yellow[300],
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(child: Center(child: Text(text))),
        ),
      ),
    );
  }
}
