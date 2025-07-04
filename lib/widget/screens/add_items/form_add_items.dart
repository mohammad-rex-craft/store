import '../../common/date_picker.dart';
import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../common/input.dart';
import '../../common/selector.dart';
import '../../../l10n/app_localizations.dart';

class FormAddItems extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController qtnController;
  final TextEditingController invoiceController;
  final String? selectedType;
  final List<String>? selectedItems;
  final List<Map<String, dynamic>> allItems;
  final Function(String?) onTypeChanged;
  final Function(List<String>?) onItemChanged;
  final VoidCallback onAdd;
  final List<Map<String, dynamic>> allClients;
  final Function(dynamic) onClientChanged;
  final int? selectedClientId;

  const FormAddItems({
    super.key,
    required this.dateController,
    required this.qtnController,
    required this.invoiceController,
    required this.selectedType,
    required this.selectedItems,
    required this.allItems,
    required this.onTypeChanged,
    required this.onItemChanged,
    required this.onAdd,
    required this.allClients,
    required this.onClientChanged,
    required this.selectedClientId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.additem ?? "Add Items",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Selector(
              controller: TextEditingController(text: selectedType ?? ''),
              allItems: [
                'Production',
                'Return',
              ].map((type) => {'type': type}).toList(),
              labelText: l10n?.type ?? 'Type *',
              valueKey: 'type',
              displayKey: 'type',
              onItemChanged: (newValue) => onTypeChanged(newValue),
            ),
            if (selectedType == 'Return') ...[
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
            ],
            const SizedBox(height: 16),
            DatePicker(controller: dateController),
            const SizedBox(height: 16),
            Selector(
              key: Key(selectedItems?.join(',') ?? ''),
              isMultiple: true,
              controller: TextEditingController(),
              allItems: allItems,
              labelText: l10n?.item ?? 'Item *',
              onItemChanged: (newValue) =>
                  onItemChanged(newValue.cast<String>()),
              initialValue: selectedItems,
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
              btnType: BtnType.success,
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
