import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../database/database.dart';
import '../../common/input.dart';
import '../../common/btn.dart';

class FormCreateItems extends StatefulWidget {
  final VoidCallback onItemCreated;

  const FormCreateItems({
    Key? key,
    required this.onItemCreated,
  }) : super(key: key);

  @override
  State<FormCreateItems> createState() => _FormCreateItemsState();
}

class _FormCreateItemsState extends State<FormCreateItems> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  final DatabaseService db = DatabaseService();

  Future<void> createItem() async {
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
      await db.create(
        table: 'store',
        data: {
          'item': nameController.text,
          'qtn': 0,
          'box': int.parse(qtnController.text), 
        },
        context: context,
        successMessage: "Item created successfully",
        errorMessage: "Error creating item",
      );
      
      nameController.clear();
      qtnController.clear();
      widget.onItemCreated();
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create New Item",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Input(
              controller: nameController,
              labelText: 'Item Name',
            ),
            SizedBox(height: 16),
            Input(
              controller: qtnController,
              labelText: 'Quantity',
            ),
            SizedBox(height: 16),
            Btn(
              title: 'Create',
              onTap: createItem,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}


