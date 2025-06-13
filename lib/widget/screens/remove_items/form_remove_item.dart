import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../common/input.dart';

class FormRemoveItem extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController qtnController;
  final TextEditingController invoiceController;
  final TextEditingController clientController;
  final TextEditingController senderController;
  final String? selectedType;
  final String? selectedItem;
  final List<Map<String, dynamic>> allItems;
  final Function(String?) onTypeChanged;
  final Function(String?) onItemChanged;
  final VoidCallback onAdd;

  const FormRemoveItem({
    super.key,
    required this.dateController,
    required this.qtnController,
    required this.invoiceController,
    required this.clientController,
    required this.senderController,
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
              "Remove Items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Input(controller: invoiceController, labelText: 'Noa'),
            Input(controller: clientController, labelText: 'Client'),
            Input(controller: senderController, labelText: 'Sender'),
            TextField(
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                      dateController.text =
                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    }
                  },
                ),
              ),
              controller: dateController,
              readOnly: true,
            ),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Item',
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
            Input(controller: qtnController, labelText: 'Qtn'),
            Btn(title: 'Add', width: double.infinity, onTap: onAdd),
          ],
        ),
      ),
    );
  }
}
