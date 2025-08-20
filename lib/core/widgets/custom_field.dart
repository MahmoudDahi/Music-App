import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

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
        if (keyboardType != null &&
            keyboardType == TextInputType.emailAddress) {
          const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
          final regex = RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return 'Enter a valid email';
          }
        }
        return null;
      },
    );
  }
}
