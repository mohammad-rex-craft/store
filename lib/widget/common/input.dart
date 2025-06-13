import 'package:flutter/material.dart';




class Input extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  const Input({
    super.key,
    required this.controller,
    required this.labelText,
  });
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
          );
  }
}