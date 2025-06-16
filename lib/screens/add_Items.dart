import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widget/common/bar.dart';
import '../widget/screens/add_items/form_add_items.dart';
import '../widget/screens/add_items/table_add_items.dart';
import '../database/database.dart';

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
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      if (response != null) {
        setState(() {
          allItems = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  void addItem() {
    if (selectedItem == null || qtnController.text.isEmpty) {
      db.showAlert(
        context,
        title: "Warning",
        message: "Please fill in all fields",
        type: AlertType.warning,
      );
      return;
    }

    // Check if item already exists in the list
    if (items.any((item) => item['item'] == selectedItem)) {
      db.showAlert(
        context,
        title: "Warning",
        message: "This item already exists in the list",
        type: AlertType.warning,
      );
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
    if (selectedType == null ||
        dateController.text == '' ||
        (selectedType == 'Return' && invoiceController.text == '')) {
      db.showAlert(
        context,
        title: "Warning",
        message: "Please fill in all fields",
        type: AlertType.warning,
      );
      return;
    } else {
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
          'items_ids': items.map((item) => item['id']).toList(),
        };

        await db.create(
          table: 'inputs',
          data: inputData,
          context: context,
          successMessage: "Items added successfully",
          errorMessage: "Error while saving data",
        );

        // Process all items
        for (var item in items) {
          await db.update(
            table: 'store',
            id: item['id'].toString(),
            data: {
              'qtn':
                  allItems.firstWhere(
                    (element) => element['id'] == item['id'],
                  )['qtn'] +
                  item['qtn'],
            },
            context: context,
            successMessage: null,
            errorMessage: "Error updating item quantity",
          );
        }

        // Reset form
        setState(() {
          items = [];
          selectedType = null;
          invoiceController.clear();
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // Error is already handled by DatabaseService
      }
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
                TableAddItems(
                  items: items,
                  onSubmit: submitData,
                  onDelete: deleteItem,
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
