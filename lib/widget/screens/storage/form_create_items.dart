import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../database/database.dart';
import '../../common/input.dart';
import '../../../l10n/app_localizations.dart';

class FormCreateItems extends StatefulWidget {
  final VoidCallback onItemCreated;

  const FormCreateItems({super.key, required this.onItemCreated});

  @override
  State<FormCreateItems> createState() => _FormCreateItemsState();
}

class _FormCreateItemsState extends State<FormCreateItems> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  final DatabaseService db = DatabaseService();

  Future<void> createItem() async {
    final l10n = AppLocalizations.of(context);
    if (nameController.text.isEmpty || qtnController.text.isEmpty) {
      db.showAlert(
        context,
        title: l10n?.warning ?? "Warning",
        message: l10n?.pleaseFillAllFields ?? "Please fill in all fields",
        type: AlertType.warning,
      );
      return;
    }

    try {
      await db.create(
        table: 'store',
        data: {
          'item': nameController.text,
          'qtn': 0,
          'box': int.parse(qtnController.text),
        },
        context: context,
        successMessage: l10n?.itemCreatedSuccess ?? "Item created successfully",
        errorMessage: l10n?.itemCreateError ?? "Error creating item",
      );

      nameController.clear();
      qtnController.clear();
      widget.onItemCreated();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Text(
                  l10n?.addNewItem ?? "Add new item",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Input(
                  controller: nameController,
                  labelText: l10n?.itemName ?? 'Item Names',
                  prefixIcon: Icons.inventory_2,
                ),
                const SizedBox(height: 20),
                Input(
                  controller: qtnController,
                  labelText: l10n?.boxQuantity ?? 'Quantity in the box',
                  prefixIcon: Icons.shopping_cart,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: createItem,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                l10n?.addItems ?? 'Add item',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
