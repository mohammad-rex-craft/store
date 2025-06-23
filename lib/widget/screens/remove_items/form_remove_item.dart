import '../../common/date_picker.dart';
import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../common/input.dart';
import '../../common/selector.dart';

class FormRemoveItem extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController qtnController;
  final TextEditingController invoiceController;
  final TextEditingController clientController;
  final TextEditingController senderController;
  final List<String> selectedItems;
  final List<Map<String, dynamic>> allItems;
  final Function(dynamic) onItemChanged;
  final VoidCallback onAdd;

  const FormRemoveItem({
    super.key,
    required this.dateController,
    required this.qtnController,
    required this.invoiceController,
    required this.clientController,
    required this.senderController,
    required this.selectedItems,
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
            Selector(
              isMultiple: true,
              controller: TextEditingController(),
              initialValue: selectedItems,
              allItems: allItems,
              labelText: 'Item *',
              onItemChanged: onItemChanged,
            ),
            Input(
              controller: qtnController,
              labelText: 'Qtn *',
            ),
            Btn(
              title: 'Add', 
              width: double.infinity, 
              onTap: onAdd,
              btnType: BtnType.warning,
              icon: Icons.remove,
            ),
          ],
        ),
      ),
    );
  }
}
