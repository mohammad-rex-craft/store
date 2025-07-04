import '../../common/date_picker.dart';
import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../common/input.dart';
import '../../common/selector.dart';
import '../../../l10n/app_localizations.dart';

class FormRemoveItem extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController qtnController;
  final TextEditingController invoiceController;
  final int? selectedClientId;
  final Function(dynamic) onClientChanged;
  final List<Map<String, dynamic>> allClients;
  final TextEditingController senderController;
  final List<String> selectedItems;
  final List<Map<String, dynamic>> allItems;
  final Function(dynamic) onItemChanged;
  final VoidCallback onAdd;

  const FormRemoveItem({
    super.key,
    required this.dateController,
    required this.qtnController,
    required this.invoiceController,
    required this.selectedClientId,
    required this.onClientChanged,
    required this.allClients,
    required this.senderController,
    required this.selectedItems,
    required this.allItems,
    required this.onItemChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n?.removeitem ?? "Remove Items",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Input(
              controller: invoiceController,
              labelText: l10n?.noa ?? 'Noa *',
            ),
            const SizedBox(height: 16),
            Selector(
              controller: TextEditingController(),
              labelText: l10n?.client ?? 'Client *',
              allItems: allClients,
              onItemChanged: onClientChanged,
              valueKey: 'id',
              displayKey: 'name',
              defaultValue: selectedClientId?.toString(),
            ),
            const SizedBox(height: 16),
            Input(
              controller: senderController,
              labelText: l10n?.sender ?? 'Sender *',
            ),
            const SizedBox(height: 16),
            DatePicker(controller: dateController),
            const SizedBox(height: 16),
            Selector(
              isMultiple: true,
              controller: TextEditingController(),
              initialValue: selectedItems,
              allItems: allItems,
              labelText: l10n?.item ?? 'Item *',
              onItemChanged: onItemChanged,
            ),
            const SizedBox(height: 16),
            Input(
              controller: qtnController,
              labelText: l10n?.quantity ?? 'Qtn *',
            ),
            const SizedBox(height: 16),
            Btn(
              title: l10n?.add ?? 'Add',
              width: double.infinity,
              onTap: onAdd,
              btnType: BtnType.warning,
              icon: Icons.remove,
            ),
          ],
        ),
      ),
    );
  }
}
