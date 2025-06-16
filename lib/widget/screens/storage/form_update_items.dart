import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../database/database.dart';
import '../../common/input.dart';
import '../../common/btn.dart';

class FormUpdateItems extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final VoidCallback onItemUpdated;

  const FormUpdateItems({
    Key? key,
    required this.items,
    required this.onItemUpdated,
  }) : super(key: key);

  @override
  State<FormUpdateItems> createState() => _FormUpdateItemsState();
}

class _FormUpdateItemsState extends State<FormUpdateItems> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  final DatabaseService db = DatabaseService();
  Map<String, dynamic>? selectedItem;

  Future<void> update() async {
    if (selectedItem == null) {
      db.showAlert(
        context,
        title: "Warning",
        message: "Please select an item to update",
        type: AlertType.warning,
      );
      return;
    }

    if (nameController.text.isEmpty || qtnController.text.isEmpty) {
      db.showAlert(
        context,
        title: "Warning",
        message: "Please fill in all fields",
        type: AlertType.warning,
      );
      return;
    }

    try {
      await db.update(
        table: 'store',
        id: selectedItem!['id'].toString(),
        data: {
          'item': nameController.text,
          'qtn': int.parse(qtnController.text),
        },
        context: context,
        successMessage: "Item updated successfully",
        errorMessage: "Error updating item",
      );
      
      nameController.clear();
      qtnController.clear();
      setState(() {
        selectedItem = null;
      });
      widget.onItemUpdated();
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          spacing: 16,
          children: [
            Text(
              'Update Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: InputDecoration(
                labelText: 'Select Item',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: selectedItem,
              items: widget.items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item['item'] ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                  if (value != null) {
                    nameController.text = value['item'] ?? '';
                    qtnController.text = value['qtn']?.toString() ?? '0';
                  }
                });
              },
            ),
            Input(
              controller: nameController,
              labelText: 'New Item Name',
            ),
            Input(
              controller: qtnController,
              labelText: 'New Quantity',
            ),
            Btn(title: 'Update', onTap: update, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
