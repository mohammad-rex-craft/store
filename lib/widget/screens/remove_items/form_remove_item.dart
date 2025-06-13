import 'package:flutter/material.dart';
import '../../common/btn.dart';

class FormRemoveItem extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController qtnController;
  final TextEditingController invoiceController;
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              value: selectedType,
              items: ['Production', 'Return'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: onTypeChanged,
            ),
            SizedBox(height: 16),
            if (selectedType == 'Return') ...[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Noa',
                  border: OutlineInputBorder(),
                ),
                controller: invoiceController,
              ),
              SizedBox(height: 16),
            ],
            TextField(
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
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
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Item',
                border: OutlineInputBorder(),
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
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Qtn',
                border: OutlineInputBorder(),
              ),
              controller: qtnController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Btn(title: 'Add', width: double.infinity, onTap: onAdd),
          ],
        ),
      ),
    );
  }
}
