import 'package:flutter/material.dart';

void showSnakeBar({
  required BuildContext context,
  required String content,
  Color? color = Colors.white,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(content),
      ),
    );
}
