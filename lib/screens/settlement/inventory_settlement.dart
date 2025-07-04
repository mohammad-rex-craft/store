import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../database/database.dart';
import '../../widget/common/bar.dart';
import '../../widget/common/btn.dart';
import '../../widget/common/input.dart';
import '../../widget/common/selector.dart';
import '../../l10n/app_localizations.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dateController.text = DateTime.now().toIso8601String().substring(0, 10);
      loadInitialData(); 
    });
  }

  Future<void> loadInitialData() async {
    setState(() => isLoading = true);
    await Future.wait([getStore()]);
    setState(() => isLoading = false);
  }

  Future<void> getStore() async {
    final l10n = AppLocalizations.of(context);

    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: l10n?.networkError ?? "Network error occurred while fetching items",
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
    final l10n = AppLocalizations.of(context);

    if (itemController.text.isEmpty || adjustmentController.text.isEmpty) {
      db.showAlert(context,
          title: l10n?.warning ?? "Warning",
          message: l10n?.pleaseSelectItemAndQty ?? "Please select an item and enter the adjustment quantity.",
          type: AlertType.warning);
      return;
    }



    final adjustmentQuantity = int.tryParse(adjustmentController.text);
    if (adjustmentQuantity == null || adjustmentQuantity == 0) {
      db.showAlert(context,
          title: l10n?.warning ?? "Warning",
          message: l10n?.pleaseEnterValidQty ?? "Please enter a valid non-zero quantity.",
          type: AlertType.warning);
      return;
    }

    if (settlementItems.any((item) => item['item'] == itemController.text)) {
      db.showAlert(context,
          title: l10n?.warning ?? "Warning",
          message: l10n?.itemAlreadyInSettlement ?? "This item is already in the settlement list.",
          type: AlertType.warning);
      return;
    }

    final selectedItemData =
        allItems.firstWhere((item) => item['item'] == itemController.text);

    // Check for sufficient quantity if adjustment is negative
    if (adjustmentQuantity < 0 &&
        selectedItemData['qtn'] < adjustmentQuantity.abs()) {
      db.showAlert(context,
          title: l10n?.warning ?? "Warning",
          message:
              l10n?.adjustmentQuantityExceedsStock(adjustmentQuantity, selectedItemData['qtn']) ?? "The adjustment quantity ($adjustmentQuantity) exceeds the available stock (${selectedItemData['qtn']}).",
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
    final l10n = AppLocalizations.of(context);

    if (settlementItems.length < 2) {
      db.showAlert(context,
          title: l10n?.warning ?? "Warning",
          message: l10n?.youMustAdjustAtLeastTwoItems ?? "You must adjust at least two items.",
          type: AlertType.warning);
      return;
    }

    if (totalAdjustment != 0) {
      db.showAlert(context,
          title: l10n?.error ?? "Error",
          message:
              l10n?.totalAdjustmentMustBeZero ?? "The total adjustment must be zero. Current total: $totalAdjustment",
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
        title: l10n?.success ?? "Success",
        message: l10n?.inventorySettlementRecordedSuccessfully ?? "Inventory settlement recorded successfully.",
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
          title: l10n?.error ?? "Error",
          message: l10n?.error ?? "An error occurred: $e",
          type: AlertType.error);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: Bar(title: l10n?.inventorySettlement ?? 'Inventory Settlement', color: Colors.indigo),
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
    final l10n = AppLocalizations.of(context);

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
            labelText: l10n?.selectItem ?? 'Select Item',
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
            labelText: l10n?.adjustmentQuantity ?? 'Adjustment Quantity (+/-)',
            controller: adjustmentController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Btn(
            title: l10n?.addToSettlement ?? 'Add to Settlement',
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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          l10n?.settlementSummary ?? 'Settlement Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        DataTable(
          columns:  [
            DataColumn(label: Text(l10n?.item ?? 'Item')),
            DataColumn(label: Text(l10n?.adjustment ?? 'Adjustment'), numeric: true),
            DataColumn(label: Text(l10n?.action ?? 'Action')),
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
          title: Text(l10n?.totalAdjustment ?? 'Total Adjustment',
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
            labelText: l10n?.date ?? 'Date',
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
                labelText: l10n?.noa ??  'Noa *',
              ),
                      const SizedBox(height: 16),

        Input(
          labelText: l10n?.reason ?? 'Reason / Notes (Optional)',
          controller: reasonController,
          maxLines: 2,
        ),
        const SizedBox(height: 20),
        Btn(
          title: l10n?.submitSettlement ?? 'Submit Settlement',
          onTap: submitSettlement,
          backgroundColor: canSubmit ? Colors.indigo : Colors.grey,
          enabled: canSubmit,
        ),
      ],
    );
  }
}
