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
  final TextEditingController clientController = TextEditingController();
  String? selectedClient;
  int? selectedClientId;
  DateTime selectedDate = DateTime.now();
  String? selectedType;
  List<String>? selectedItems;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> allItems = [];
  bool isLoading = false;
  List<Map<String, dynamic>> allClients = [];

  @override
  void initState() {
    super.initState();
    getStoreAndClients();
  }

  Future<void> getStoreAndClients() async {
    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      // Sort data by ID in ascending order
      List<Map<String, dynamic>> sortedData = List<Map<String, dynamic>>.from(
        response,
      );
      sortedData.sort((a, b) {
        int idA = a['id'] ?? 0;
        int idB = b['id'] ?? 0;
        return idA.compareTo(idB);
      });
      final responseClients = await db.readAll(
        table: 'client',
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      setState(() {
        allItems = sortedData;
        allClients = responseClients ?? [];
      });
        } catch (e) {
      print(e);
    }
  }

  void addItem() {
    if (selectedItems == null ||
        selectedItems!.isEmpty ||
        qtnController.text.isEmpty) {
      db.showAlert(
        context,
        title: "Warning",
        message: "Please fill in all fields",
        type: AlertType.warning,
      );
      return;
    }

    bool itemExists = false;
    for (var selectedItem in selectedItems!) {
      if (items.any((item) => item['item'] == selectedItem)) {
        itemExists = true;
        break;
      }
    }

    if (itemExists) {
      db.showAlert(
        context,
        title: "Warning",
        message: "One or more items already exist in the list",
        type: AlertType.warning,
      );
      return;
    }

    final newItems = <Map<String, dynamic>>[];
    for (var selectedItem in selectedItems!) {
      final item = allItems.firstWhere((item) => item['item'] == selectedItem);
      newItems.add({
        'item': selectedItem,
        'qtn': int.parse(qtnController.text),
        'id': item['id'],
      });
    }

    setState(() {
      items.addAll(newItems);
      selectedItems = null;
    });
    qtnController.clear();
  }

  Future<void> submitData() async {
    if (selectedType == null ||
        dateController.text == '' ||
        (selectedType == 'Return' && invoiceController.text == '' && clientController.text == '')) {
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
        final inputData = {
          'date': dateController.text,
          'type': selectedType,
          'noa': selectedType == 'Return' ? invoiceController.text : null,
          'items': items,
          'items_ids': items.map((item) => item['id']).toList(),
          'client_id': selectedType == 'Return' ? selectedClientId : null,
          'client': selectedType == 'Return'
              ? clientController.text
              : null,
        };

        await db.create(
          table: 'inputs',
          data: inputData,
          context: context,
          successMessage: "Items added successfully",
          errorMessage: "Error while saving data",
        );

        for (var item in items) {
          await db.update(
            table: 'store',
            id: item['id'],
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

        setState(() {
          items = [];
          selectedType = null;
          invoiceController.clear();
          isLoading = false;
          selectedClientId = null;
          dateController.clear();
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
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
          appBar: const Bar(title: 'Add Items', color: Colors.green),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FormAddItems(
                  dateController: dateController,
                  qtnController: qtnController,
                  invoiceController: invoiceController,
                  selectedType: selectedType,
                  selectedItems: selectedItems,
                  allItems: allItems,
                  onTypeChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  allClients: allClients,
                  onClientChanged: (value) {
                     setState(() {
                      selectedClientId = int.parse(value);
                      selectedClient = allClients
                          .firstWhere((c) => c['id'] == selectedClientId)['name'];
                      clientController.text = selectedClient!;
                    });
                  },
                  selectedClientId: selectedClientId,
                  onItemChanged: (value) {
                    setState(() {
                      selectedItems = value;
                    });
                  },
                  onAdd: addItem,
                ),
                const SizedBox(height: 16),
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
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
