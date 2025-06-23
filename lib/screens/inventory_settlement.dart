import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../database/database.dart';
import '../widget/common/bar.dart';
import '../widget/common/btn.dart';
import '../widget/common/input.dart';
import '../widget/common/selector.dart';

class InventorySettlement extends StatefulWidget {
  const InventorySettlement({super.key});

  @override
  State<InventorySettlement> createState() => _InventorySettlementState();
}

class _InventorySettlementState extends State<InventorySettlement> {
  final DatabaseService db = DatabaseService();
  final TextEditingController adjustmentController = TextEditingController();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController noaController = TextEditingController();  
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> settlementItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dateController.text = DateTime.now().toIso8601String().substring(0, 10);
    getStore();
  }

  Future<void> getStore() async {
    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      List<Map<String, dynamic>> sortedData =
          List<Map<String, dynamic>>.from(response);
      sortedData.sort((a, b) => (a['id'] ?? 0).compareTo(b['id'] ?? 0));
      setState(() {
        allItems = sortedData;
      });
    } catch (e) {
      // Handle error
    }
  }

  void addItemToSettlement() {
    if (itemController.text.isEmpty || adjustmentController.text.isEmpty) {
      db.showAlert(context,
          title: "Warning",
          message: "Please select an item and enter the adjustment quantity.",
          type: AlertType.warning);
      return;
    }



    final adjustmentQuantity = int.tryParse(adjustmentController.text);
    if (adjustmentQuantity == null || adjustmentQuantity == 0) {
      db.showAlert(context,
          title: "Warning",
          message: "Please enter a valid non-zero quantity.",
          type: AlertType.warning);
      return;
    }

    if (settlementItems.any((item) => item['item'] == itemController.text)) {
      db.showAlert(context,
          title: "Warning",
          message: "This item is already in the settlement list.",
          type: AlertType.warning);
      return;
    }

    final selectedItemData =
        allItems.firstWhere((item) => item['item'] == itemController.text);

    // Check for sufficient quantity if adjustment is negative
    if (adjustmentQuantity < 0 &&
        selectedItemData['qtn'] < adjustmentQuantity.abs()) {
      db.showAlert(context,
          title: "Warning",
          message:
              "The adjustment quantity (${adjustmentQuantity}) exceeds the available stock (${selectedItemData['qtn']}).",
          type: AlertType.warning);
      return;
    }

    setState(() {
      settlementItems.add({
        'id': selectedItemData['id'],
        'item': selectedItemData['item'],
        'qtn': adjustmentQuantity,
      });
      itemController.clear();
      adjustmentController.clear();
    });
  }

  void deleteItem(int index) {
    setState(() {
      settlementItems.removeAt(index);
    });
  }

  int get totalAdjustment {
    if (settlementItems.isEmpty) return 0;
    return settlementItems.fold(0, (sum, item) => sum + (item['qtn'] as int));
  }

  Future<void> submitSettlement() async {
    if (settlementItems.length < 2) {
      db.showAlert(context,
          title: "Warning",
          message: "You must adjust at least two items.",
          type: AlertType.warning);
      return;
    }

    if (totalAdjustment != 0) {
      db.showAlert(context,
          title: "Error",
          message:
              "The total adjustment must be zero. Current total: $totalAdjustment",
          type: AlertType.error);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final settlementData = {
        'date': dateController.text,
        'reason': reasonController.text,
        'items': settlementItems,
        'items_ids': settlementItems.map((item) => item['id']).toList(),
        'noa': noaController.text,
      };

      await db.create(
        table: 'inventory_settlements',
        data: settlementData,
        context: context,
      );

      // Update quantities in the store
      for (var item in settlementItems) {
        final currentItem = allItems.firstWhere((i) => i['id'] == item['id']);
        final newQuantity = currentItem['qtn'] + item['qtn'];
        await db.update(
          table: 'store',
          id: item['id'],
          data: {'qtn': newQuantity},
          context: context,
        );
      }
      db.showAlert(
        context,
        title: "Success",
        message: "Inventory settlement recorded successfully.",
        type: AlertType.success,
      );

      setState(() {
        settlementItems = [];
        reasonController.clear();
        isLoading = false;
        getStore();
      });
    } catch (e) {
      db.showAlert(context,
          title: "Error",
          message: "An error occurred: $e",
          type: AlertType.error);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: Bar(title: 'Inventory Settlement', color: Colors.indigo),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSettlementForm(),
                const SizedBox(height: 20),
                _buildSettlementTable(),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildSettlementForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Selector(
            labelText: 'Select Item',
            controller: itemController,
            allItems: allItems,
            onItemChanged: (value) {
              setState(() {
                itemController.text = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Input(
            labelText: 'Adjustment Quantity (+/-)',
            controller: adjustmentController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Btn(
            title: 'Add to Settlement',
            onTap: addItemToSettlement,
            icon: Icons.add_circle_outline,
            btnType: BtnType.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementTable() {
    final bool canSubmit = totalAdjustment == 0 && settlementItems.length >= 2;

    return Column(
      children: [
        Text(
          'Settlement Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        DataTable(
          columns: const [
            DataColumn(label: Text('Item')),
            DataColumn(label: Text('Adjustment'), numeric: true),
            DataColumn(label: Text('Action')),
          ],
          rows: settlementItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(item['item'].toString())),
                DataCell(
                  Text(
                    item['qtn'].toString(),
                    style: TextStyle(
                      color:
                          (item['qtn'] as int) > 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => deleteItem(index),
                  ),
                ),
              ],
            );
          }).toList(),
          showBottomBorder: true,
        ),
        const SizedBox(height: 10),
        ListTile(
          title: const Text('Total Adjustment',
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(
            totalAdjustment.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: totalAdjustment == 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
        const Divider(),
        const SizedBox(height: 10),
        Input(
            labelText: 'Date',
            controller: dateController,
            readOnly: true,
            onTap: () async {
              DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));
              if (picked != null) {
                setState(() {
                  dateController.text =
                      picked.toIso8601String().substring(0, 10);
                });
              }
            }),
        const SizedBox(height: 16),
        Input(
                controller: noaController,
                labelText: 'Noa *',
              ),
                      const SizedBox(height: 16),

        Input(
          labelText: 'Reason / Notes (Optional)',
          controller: reasonController,
          maxLines: 2,
        ),
        const SizedBox(height: 20),
        Btn(
          title: 'Submit Settlement',
          onTap: submitSettlement,
          backgroundColor: canSubmit ? Colors.indigo : Colors.grey,
          enabled: canSubmit,
        ),
      ],
    );
  }
}
