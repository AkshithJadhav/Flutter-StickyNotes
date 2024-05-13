import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final function;

  const MyButton({this.function});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: function,
      icon: const Icon(Icons.send),
    );
  }
}
