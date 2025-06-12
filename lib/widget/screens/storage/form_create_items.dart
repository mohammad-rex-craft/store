import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../hooks.dart';


class FormCreateItems extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  final Function getItems;
  final primeColor = hexToColor('#03A9F4');

   FormCreateItems({
     required this.getItems,
     super.key
   });


   store() async {
    try {
      await Supabase.instance.client.from('store').insert({
        'item': nameController.text,
        'qtn': 0,
        'box': int.parse(qtnController.text),
      });
      nameController.clear();
      qtnController.clear();
      await getItems();
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
                  'Add Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Item Quantity',
                    border: OutlineInputBorder(),
                  ),
                  controller: qtnController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => store(),
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primeColor,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          );
  }
}