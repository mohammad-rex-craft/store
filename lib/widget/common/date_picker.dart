import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String? defaultValue;
  DatePicker({super.key, required this.controller, this.defaultValue}) {
    if (defaultValue != null) {
      controller.text = defaultValue!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Date *',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              controller.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
        ),
      ),
      controller: controller,

      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }
}
