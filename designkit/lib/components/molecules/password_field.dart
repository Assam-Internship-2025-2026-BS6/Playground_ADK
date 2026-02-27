import 'package:flutter/material.dart';
import '../atoms/text_field.dart' as dk;

class PasswordField extends StatelessWidget {
  final String label;
  final String hintText;
  final double? width;

  const PasswordField({
    super.key,
    required this.label,
    required this.hintText,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        dk.TextField(
          hintText: hintText,
          isPassword: true,
          width: width,
        ),
      ],
    );
  }
}
