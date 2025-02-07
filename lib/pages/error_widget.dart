import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final String message;
  final Color color;

  const ErrorWidgetCustom(
      {super.key, required this.message, this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
