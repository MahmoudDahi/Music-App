import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isObscure = false,
      this.onTap,
      this.readOnly = false});

  final String hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      obscureText: isObscure,
      validator: (value) {
        if (value!.trim().isEmpty) return "$hintText is Missing!";
        return null;
      },
    );
  }
}
