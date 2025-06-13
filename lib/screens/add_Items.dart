import 'package:flutter/material.dart';
import '../widget/common/bar.dart';
import '../widget/screens/add_items/form_add_items.dart';
import '../widget/screens/add_items/table_add_items.dart';
import '../database/database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final DatabaseService db = DatabaseService();
  final TextEditingController qtnController = TextEditingController();
  final TextEditingController invoiceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedType;
  String? selectedItem;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> allItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getStore();
  }

  Future<void> getStore() async {
    try {
      final response = await db.readAll(table: 'store');
      if (response != null) {
        setState(() {
          allItems = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "error",
        desc: "network error: ${e.toString()}",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  void addItem() {
    if (selectedItem == null || qtnController.text.isEmpty) return;

    // Check if item already exists in the list
    if (items.any((item) => item['item'] == selectedItem)) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "warning",
        desc: "this item already exists in the list",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
      return;
    }

    final item = allItems.firstWhere((item) => item['item'] == selectedItem);
    setState(() {
      items.add({
        'item': selectedItem,
        'qtn': int.parse(qtnController.text),
        'id': item['id'],
      });
    });
    
    // Reset fields
    selectedItem = null;
    qtnController.clear();
  }

  Future<void> submitData() async {
    if (items.isEmpty) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "warning",
        desc: "please add at least one item",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Insert into inputs table
      final inputData = {
        'date': dateController.text,
        'type': selectedType,
        'noa': selectedType == 'Return' ? invoiceController.text : null,
        'items': items,
      };
      await db.create(table: 'inputs', data: inputData).then((_) {
        items.forEach((item) {
          db
              .update(
                table: 'store',
                id: item['id'].toString(),
                data: {
                  'qtn':
                      allItems.firstWhere(
                        (element) => element['id'] == item['id'],
                      )['qtn'] +
                      item['qtn'],
                },
              )
              .then((_) {
                setState(() {
                  items = [];
                  selectedType = null;
                  invoiceController.clear();
                  isLoading = false;
                });
                Alert(
                  context: context,
                  type: AlertType.success,
                  title: "success",
                  desc: "items added successfully",
                  buttons: [
                    DialogButton(
                      onPressed: () => Navigator.pop(context),
                      width: 120,
                      child: Text(
                        "ok",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ).show();
              });
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Alert(
        context: context,
        type: AlertType.error,
        title: "error",
        desc: "error while saving data: ${e.toString()}",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: Bar(title: 'Add Items'),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                FormAddItems(
                  dateController: dateController,
                  qtnController: qtnController,
                  invoiceController: invoiceController,
                  selectedType: selectedType,
                  selectedItem: selectedItem,
                  allItems: allItems,
                  onTypeChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  onItemChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                  onAdd: addItem,
                ),
                SizedBox(height: 16),
                TableAddItems(items: items, onSubmit: submitData, onDelete: deleteItem),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}




