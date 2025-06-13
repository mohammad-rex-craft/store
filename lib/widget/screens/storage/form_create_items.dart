import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../hooks.dart';
import '../../common/btn.dart';
import '../../common/input.dart';


class FormCreateItems extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController boxController = TextEditingController();
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
        'box': int.parse(boxController.text),
      });
      nameController.clear();
      boxController.clear();
      await getItems();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
            elevation: 8,
            child: Padding(padding: EdgeInsets.all(15),
            child: Column(
              spacing: 16,
              children: [
                Text(
                  'Add Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Input(controller: nameController, labelText: 'Item Name'),
                Input(controller: boxController, labelText: 'In Box'),
                Btn(title: 'Add', onTap: () => store(), width: double.infinity),
              ],
            ),)
          );
  }
}