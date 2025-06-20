import 'package:darttest/widget/common/date_picker.dart';
import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../common/input.dart';
import '../../common/date_picker.dart';

class FormAddItems extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController qtnController;
  final TextEditingController invoiceController;
  final String? selectedType;
  final String? selectedItem;
  final List<Map<String, dynamic>> allItems;
  final Function(String?) onTypeChanged;
  final Function(String?) onItemChanged;
  final VoidCallback onAdd;

  const FormAddItems({
    super.key,
    required this.dateController,
    required this.qtnController,
    required this.invoiceController,
    required this.selectedType,
    required this.selectedItem,
    required this.allItems,
    required this.onTypeChanged,
    required this.onItemChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              "Add Items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: selectedType,
              items: ['Production', 'Return'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: onTypeChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a type';
                }
                return null;
              },
            ),
            if (selectedType == 'Return') ...[
              Input(
                controller: invoiceController,
                labelText: 'Noa *',
              ),
            ],
            DatePicker(controller:dateController),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Item *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: selectedItem,
              items: allItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item['item'] as String,
                  child: Text(item['item'] as String),
                );
              }).toList(),
              onChanged: onItemChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an item';
                }
                return null;
              },
            ),
            Input(
              controller: qtnController,
              labelText: 'Qtn *',
              
            ),
            Btn(title: 'Add', width: double.infinity, onTap: onAdd,),
          ],
        ),
      ),
    );
  }
}
