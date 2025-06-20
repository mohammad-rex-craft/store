import 'package:darttest/widget/common/date_picker.dart';
import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../common/input.dart';

class FormRemoveItem extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController qtnController;
  final TextEditingController invoiceController;
  final TextEditingController clientController;
  final TextEditingController senderController;
  final String? selectedItem;
  final List<Map<String, dynamic>> allItems;
  final Function(String?) onItemChanged;
  final VoidCallback onAdd;

  const FormRemoveItem({
    super.key,
    required this.dateController,
    required this.qtnController,
    required this.invoiceController,
    required this.clientController,
    required this.senderController,
    required this.selectedItem,
    required this.allItems,
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
              "Remove Items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Input(
              controller: invoiceController,
              labelText: 'Noa *',
              
            ),
            Input(
              controller: clientController,
              labelText: 'Client *',
              
            ),
            Input(
              controller: senderController,
              labelText: 'Sender *',
              
            ),
            DatePicker(controller: dateController),
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
              
            ),
            Input(
              controller: qtnController,
              labelText: 'Qtn *',
              
            ),
            Btn(title: 'Add', width: double.infinity, onTap: onAdd),
          ],
        ),
      ),
    );
  }
}
