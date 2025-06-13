import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../hooks.dart';
import '../../common/btn.dart';
import '../../common/input.dart';
import '../../common/selector.dart';

class FormUpdateItems extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function getItems;
  final primeColor = hexToColor('#03A9F4');

  FormUpdateItems({required this.getItems, required this.items, super.key});

  @override
  State<FormUpdateItems> createState() => _FormUpdateItemsState();
}

class _FormUpdateItemsState extends State<FormUpdateItems> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  Map<String, dynamic>? selectedItem;

  update() async {
    if (selectedItem == null) return;

    try {
      final Map<String, dynamic> updateData = {};
      if (nameController.text.isNotEmpty) {
        updateData['item'] = nameController.text;
      }
      if (qtnController.text.isNotEmpty) {
        updateData['qtn'] = int.parse(qtnController.text);
      }

      if (updateData.isNotEmpty) {
        await Supabase.instance.client
            .from('store')
            .update(updateData)
            .eq('id', selectedItem!['id']);
        await widget.getItems();
        nameController.clear();
        qtnController.clear();
        setState(() {
          selectedItem = null;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              'Update Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            Input(
              controller: nameController,
              labelText: 'New Item Name',
            ),
            SizedBox(height: 16),
            Input(
              controller: qtnController,
              labelText: 'New Quantity',
            ),
            SizedBox(height: 16),
            Btn(title: 'Update', onTap: () => update(), width: double.infinity),
          ],
        ),
      ),
    );
  }
}
