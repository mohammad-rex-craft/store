import '../../common/date_picker.dart';
import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../common/input.dart';
import '../../common/selector.dart';

class FormAddItems extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController qtnController;
  final TextEditingController invoiceController;
  final String? selectedType;
  final List<String>? selectedItems;
  final List<Map<String, dynamic>> allItems;
  final Function(String?) onTypeChanged;
  final Function(List<String>?) onItemChanged;
  final VoidCallback onAdd;

  const FormAddItems({
    super.key,
    required this.dateController,
    required this.qtnController,
    required this.invoiceController,
    required this.selectedType,
    required this.selectedItems,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Selector(
              controller: TextEditingController(text: selectedType ?? ''),
              allItems: ['Production', 'Return']
                  .map((type) => {'type': type})
                  .toList(),
              labelText: 'Type *',
              valueKey: 'type',
              displayKey: 'type',
              onItemChanged: (newValue) => onTypeChanged(newValue),
            ),
            if (selectedType == 'Return') ...[
              const SizedBox(height: 16),
              Input(
                controller: invoiceController,
                labelText: 'Noa *',
              ),
            ],
            const SizedBox(height: 16),
            DatePicker(controller: dateController),
            const SizedBox(height: 16),
            Selector(
              key: Key(selectedItems?.join(',') ?? ''),
              isMultiple: true,
              controller: TextEditingController(),
              allItems: allItems,
              labelText: 'Item *',
              onItemChanged: (newValue) => onItemChanged(newValue.cast<String>()),
              initialValue: selectedItems,
            ),
            const SizedBox(height: 16),
            Input(
              controller: qtnController,
              labelText: 'Qtn *',
            ),
            const SizedBox(height: 16),
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
