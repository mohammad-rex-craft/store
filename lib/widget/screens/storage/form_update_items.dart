import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../database/database.dart';
import '../../common/input.dart';

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
        id: selectedItem!['id'],
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
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  "Update item",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          // Form Fields
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'Select item',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      prefixIcon: Icon(Icons.inventory, color: Colors.orange.shade600),
                    ),
                    value: selectedItem,
                    items: widget.items.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item['item'] ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
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
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.orange.shade600),
                  ),
                ),
                SizedBox(height: 20),
                
                Input(
                  controller: nameController,
                  labelText: 'New name',
                  prefixIcon: Icons.edit,
                ),
                SizedBox(height: 20),
                
                Input(
                  controller: qtnController,
                  labelText: 'New quantity',
                  prefixIcon: Icons.numbers,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 25),
                
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.orange.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: update,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Update item',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
