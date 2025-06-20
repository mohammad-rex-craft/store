import 'package:flutter/material.dart';




class Input extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? defaultValue;
  final TextInputType? keyboardType;
  Input({
    super.key,
    required this.controller,
    required this.labelText,
    this.defaultValue,
    this.keyboardType,
  }) {
    if (defaultValue != null) {
      controller.text = defaultValue!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            controller: controller,
            keyboardType: keyboardType,
          );
  }
}