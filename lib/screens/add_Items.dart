import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widget/common/bar.dart';
import '../widget/screens/add_items/form_add_items.dart';
import '../widget/screens/add_items/table_add_items.dart';
import '../database/database.dart';
import '../l10n/app_localizations.dart';

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
  bool isLoading = true; 
  List<Map<String, dynamic>> allClients = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData(); // تم التعديل هنا لتحميل البيانات بعد تهيئة الـ context
    });
  }

  Future<void> loadInitialData() async {
    setState(() => isLoading = true);
    await Future.wait([getStore(), getClients()]);
    setState(() => isLoading = false);
  }

  Future<void> getClients() async {
    final l10n = AppLocalizations.of(context);
    try {
      final response = await db.readAll(
        table: 'client',
        context: context,
        errorMessage:
            l10n?.networkError ??
            "Network error occurred while fetching clients",
      );
      setState(() {
        allClients = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      // Error is handled by showAlert in DatabaseService
    }
  }

  Future<void> getStore() async {
    final l10n = AppLocalizations.of(context);
    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage:
            l10n?.networkError ?? "Network error occurred while fetching items",
      );
      List<Map<String, dynamic>> sortedData = List<Map<String, dynamic>>.from(
        response,
      );
      sortedData.sort((a, b) {
        int idA = a['id'] ?? 0;
        int idB = b['id'] ?? 0;
        return idA.compareTo(idB);
      });

      setState(() {
        allItems = sortedData;
      });
    } catch (e) {
      // Error is handled by showAlert in DatabaseService
    }
  }

  Future<void> refreshStoreData() async {
    setState(() => isLoading = true);
    await getStore();
    setState(() => isLoading = false);
  }

  void addItem() {
    final l10n = AppLocalizations.of(context);

    if (selectedItems == null ||
        selectedItems!.isEmpty ||
        qtnController.text.isEmpty) {
      db.showAlert(
        context,
        title: l10n?.warning ?? "Warning",
        message: l10n?.pleaseFillAllFields ?? "Please fill in all fields",
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
        title: l10n?.warning ?? "Warning",
        message:
            l10n?.oneormoreitem ??
            "One or more items already exist in the list",
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
    final l10n = AppLocalizations.of(context);

    if (selectedType == null ||
        dateController.text == '' ||
        (selectedType == 'Return' &&
            invoiceController.text == '' &&
            clientController.text == '')) {
      db.showAlert(
        context,
        title: l10n?.warning ?? "Warning",
        message: l10n?.pleaseFillAllFields ?? "Please fill in all fields",
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
          'client': selectedType == 'Return' ? clientController.text : null,
        };

        await db.create(
          table: 'inputs',
          data: inputData,
          context: context,
          successMessage: l10n?.success ?? "Items added successfully",
          errorMessage: l10n?.error ?? "Error while saving data",
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
            errorMessage: l10n?.error ?? "Error updating item quantity",
          );
        }

        setState(() {
          items = [];
          selectedType = null;
          invoiceController.clear();
          selectedClientId = null;
          dateController.clear();
        });
      } catch (e) {
        // Error is handled by showAlert in DatabaseService
      } finally {
        setState(() => isLoading = false);
        refreshStoreData();
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
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: Bar(title: l10n?.additem ?? 'Add Items', color: Colors.green),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                            selectedClient = allClients.firstWhere(
                              (c) => c['id'] == selectedClientId,
                            )['name'];
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
     
      ],
    );
  }
}
