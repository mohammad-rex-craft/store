import 'package:flutter/material.dart';

class Selector extends StatelessWidget {
  final TextEditingController controller;
  final String? defaultValue;
  final List<Map<String, dynamic>> allItems;
  final Function(String,String) onItemChanged;
  Selector({super.key, required this.controller, this.defaultValue, required this.allItems, required this.onItemChanged}) {
    if (defaultValue != null) {
      controller.text = defaultValue!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Item *',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: controller.text,
      items: allItems.map((item) {
        return DropdownMenuItem<String>(
          value: item['item'] as String,
          child: Text(item['item'] as String),
        );
      }).toList(),
      onChanged: (newValue) => onItemChanged(newValue ?? '',controller.text),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an item';
        }
        return null;
      },
    );
  }
}
