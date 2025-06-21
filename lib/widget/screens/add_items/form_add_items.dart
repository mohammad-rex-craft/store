import 'package:darttest/widget/common/date_picker.dart';
import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../common/input.dart';
import '../../common/selector.dart';
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
            Selector(
              controller: TextEditingController(text: selectedType ?? ''),
              allItems: ['Production', 'Return'].map((type) => {'type': type}).toList(),
              labelText: 'Type *',
              valueKey: 'type',
              displayKey: 'type',
              onItemChanged: (newValue, oldValue) => onTypeChanged(newValue),
            ),
            if (selectedType == 'Return') ...[
              Input(
                controller: invoiceController,
                labelText: 'Noa *',
              ),
            ],
            DatePicker(controller: dateController),
            Selector(
              controller: TextEditingController(text: selectedItem ?? ''),
              allItems: allItems,
              labelText: 'Item *',
              onItemChanged: (newValue, oldValue) => onItemChanged(newValue),
            ),
            Input(
              controller: qtnController,
              labelText: 'Qtn *',
            ),
            Btn(
              title: 'Add', 
              width: double.infinity, 
              onTap: onAdd,
              btnType: BtnType.success,
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
