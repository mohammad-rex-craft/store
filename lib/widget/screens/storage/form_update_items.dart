import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../hooks.dart';

class FormUpdateItems extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function getItems;
  final primeColor = hexToColor('#03A9F4');

  FormUpdateItems({
    required this.getItems,
    required this.items,
    super.key
  });

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
        await Supabase.instance.client.from('store')
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
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
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
              border: OutlineInputBorder(),
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
          TextField(
            decoration: InputDecoration(
              labelText: 'New Item Name (Optional)',
              border: OutlineInputBorder(),
            ),
            controller: nameController,
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'New Quantity (Optional)',
              border: OutlineInputBorder(),
            ),
            controller: qtnController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => update(),
            child: Text('Update'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primeColor,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
