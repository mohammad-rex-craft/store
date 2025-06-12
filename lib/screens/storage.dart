import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../hooks.dart';
import '../widget/screens/storage/table_storage.dart';
import '../widget/screens/storage/form_create_items.dart';
import '../widget/screens/storage/form_update_items.dart';
import '../widget/common/bar.dart';
var primeColor = hexToColor('#03A9F4');

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  List<Map<String, dynamic>> data = [];
    List<Map<String, dynamic>> indata = [];

  bool sortAscending = true;
  int? sortColumnIndex;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  Future<void> getItems() async {
    getItems2();
    try {
      final response = await Supabase.instance.client.from('store').select();
      if (response != null && response.isNotEmpty) {
        setState(() {
          data = response;
        });
        print(indata);
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> getItems2() async {
     final inputsResponse =await Supabase.instance.client.from('inputs').select();
      indata = inputsResponse;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'Storage'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormCreateItems(getItems: getItems),
                    FormUpdateItems(getItems: getItems, items: data),
                  ],
                ),
              ),
            ),
          ),
          TableStorage(data: data, getItems: getItems),
        ],
      ),
    );
  }
}









