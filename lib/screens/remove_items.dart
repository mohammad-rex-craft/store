import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widget/common/bar.dart';
import '../widget/screens/remove_items/form_remove_item.dart';
import '../widget/screens/remove_items/table_remove_items.dart';
import '../database/database.dart';
import '../l10n/app_localizations.dart';

class RemoveItems extends StatefulWidget {
  const RemoveItems({super.key});

  @override
  State<RemoveItems> createState() => _RemoveItemsState();
}

class _RemoveItemsState extends State<RemoveItems> {
  final DatabaseService db = DatabaseService();
  final TextEditingController qtnController = TextEditingController();
  final TextEditingController invoiceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController senderController = TextEditingController();
  String? selectedClient;
  int? selectedClientId;
  List<Map<String, dynamic>> allClients = [];
  List<String> selectedItems = [];
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> allItems = [];
  bool isLoading = false;
  

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
        errorMessage: l10n?.networkError ?? "Network error occurred while fetching clients",
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
        errorMessage: l10n?.networkError ?? "Network error occurred while fetching items",
      );
      List<Map<String, dynamic>> sortedData = List<Map<String, dynamic>>.from(response);
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
    await getStore();
  }

  void addItem() {
    final l10n = AppLocalizations.of(context);

    if (selectedItems.isEmpty || qtnController.text.isEmpty) {
      db.showAlert(
        context,
        title: l10n?.warning ?? "Warning",
        message: l10n?.pleaseSelectAtLeastOne ?? "Please select at least one item and fill in the quantity",
        type: AlertType.warning,
      );
      return;
    }

    bool hasDuplicates =
        selectedItems.any((selItem) => items.any((item) => item['item'] == selItem));
    if (hasDuplicates) {
      db.showAlert(
        context,
        title: l10n?.warning ?? "Warning",
        message: l10n?.oneormoreitem ?? "One or more selected items are already in the list.",
        type: AlertType.warning,
      );
      return;
    }

    setState(() {
      for (var selItem in selectedItems) {
        final item = allItems.firstWhere((item) => item['item'] == selItem);
        items.add({
          'item': selItem,
          'qtn': int.parse(qtnController.text),
          'id': item['id'],
        });
      }

      selectedItems = [];
      qtnController.clear();
    });
  }

  Future<void> submitData() async {
    final l10n = AppLocalizations.of(context);

    if (dateController.text ==''||
        clientController.text ==''||
        senderController.text ==''||
        invoiceController.text =='') {
      db.showAlert(
        context,
        title: l10n?.warning ?? "Warning",
        message: l10n?.pleaseFillAllFields ?? "Please fill in all fields",
        type: AlertType.warning,
      );
      return;
    }
  
    setState(() {
      isLoading = true;
    });

    try {
      final inputData = {
        'date': dateController.text,
        'client': clientController.text,
        'sender': senderController.text,
        'noa': invoiceController.text,
        'items': items,
        'items_ids': items.map((item) => item['id']).toList(),
        'client_id': selectedClientId,
      };

      await db.create(
        table: 'orders',
        data: inputData,
        context: context,
        successMessage: l10n?.success ?? "Items removed successfully",
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
                )['qtn'] -
                item['qtn'],
          },
          context: context,
          successMessage: null,
          errorMessage: l10n?.error ?? "Error updating item quantity",
        );
      }

      setState(() {
        items = [];
        clientController.clear();
        senderController.clear();
        invoiceController.clear();
        dateController.clear();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    } finally {
      refreshStoreData();
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
          appBar: Bar(title: l10n?.removeitem ?? 'Remove Items',color: Colors.red),
          body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FormRemoveItem(
                  dateController: dateController,
                  qtnController: qtnController,
                  invoiceController: invoiceController,
                  senderController: senderController,
                  selectedItems: selectedItems,
                  allItems: allItems,
                  selectedClientId: selectedClientId,
                  allClients: allClients,
                  onClientChanged: (value) {
                    setState(() {
                      selectedClientId = int.parse(value);
                      selectedClient = allClients
                          .firstWhere((c) => c['id'] == selectedClientId)['name'];
                      clientController.text = selectedClient!;
                    });
                  },
                  onItemChanged: (value) {
                    setState(() {
                      selectedItems = List<String>.from(value);
                    });
                  },
                  onAdd: addItem,
                ),
                const SizedBox(height: 16),
                TableRemoveItems(
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
