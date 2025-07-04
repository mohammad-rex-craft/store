import '../../common/input.dart';
import 'package:flutter/material.dart';
import "../../../database/database.dart";
import "../../../widget/common/dialog.dart";
import "../../../widget/common/date_picker.dart";
import "../../../widget/common/selector.dart";
import "../../../utility/theme.dart";
import 'dart:convert';
import '../../../l10n/app_localizations.dart';

class EditCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final String table;

  const EditCard({super.key, required this.item, required this.table});

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noaController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  final TextEditingController newItemQtnController = TextEditingController();
  final DatabaseService db = DatabaseService();
  List<Map<String, dynamic>> data = [];
  final TextEditingController senderController = TextEditingController();
  List<Map<String, dynamic>> allClients = [];
  String? selectedNewItemId;
  String? selectedNewItemName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
  }

  Future<void> loadInitialData() async {
    setState(() => isLoading = true);
    await Future.wait([getItems()]);
    setState(() => isLoading = false);
  }

  Future<void> getItems({bool includeClients = true}) async {
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

      if (includeClients) {
        final responseClients = await db.readAll(
          table: 'client',
          context: context,
          errorMessage:
              l10n?.networkError ??
              "Network error occurred while fetching items",
        );
        setState(() {
          data = sortedData;
          allClients = responseClients ?? [];
        });
      } else {
        setState(() {
          data = sortedData;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> refreshStoreData() async {
    await getItems(includeClients: false);
  }

  Future<void> updateDateNoaClientSender(
    BuildContext context,
    String type,
    table,
  ) async {
    if ((type == 'date' && dateController.text.isEmpty) ||
        (type == 'noa' && noaController.text.isEmpty) ||
        (type == 'sender' && senderController.text.isEmpty)) {
      return;
    }

    await db.update(
      table: table,
      id: widget.item['id'],
      data: {
        type: type == 'date'
            ? dateController.text
            : type == 'sender'
            ? senderController.text
            : noaController.text,
      },
      context: context,
    );

    setState(() {
      widget.item[type] = type == 'date'
          ? dateController.text
          : type == 'sender'
          ? senderController.text
          : noaController.text;
    });

    dateController.clear();
    noaController.clear();
    senderController.clear();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('$type updated successfully'),
          ],
        ),
        backgroundColor: AppTheme.colorSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> updateClient(
    BuildContext context,
    String? newClientIdStr,
  ) async {
    if (newClientIdStr == null || newClientIdStr.isEmpty) return;

    final newClientId = int.parse(newClientIdStr);
    final newClientName = allClients.firstWhere(
      (c) => c['id'] == newClientId,
    )['name'];

    await db.update(
      table: widget.table,
      id: widget.item['id'],
      data: {'client_id': newClientId, 'client': newClientName},
      context: context,
    );

    setState(() {
      widget.item['client_id'] = newClientId;
      widget.item['client'] = newClientName;
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Client updated successfully'),
          ],
        ),
        backgroundColor: AppTheme.colorSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> updateItem(
    BuildContext context,
    int id,
    int qtn,
    String oldValue,
    String select,
  ) async {
    if (select.isEmpty) return;

    try {
      final newItem = data.firstWhere(
        (item) => item['item'] == select,
        orElse: () => {},
      );

      if (newItem.isEmpty) {
        throw 'Selected item not found in store';
      }

      final updatedItems = List<Map<String, dynamic>>.from(
        widget.item['items'],
      );
      final index = updatedItems.indexWhere((item) => item['id'] == id);

      if (index != -1) {
        updatedItems[index] = {
          'id': newItem['id'],
          'item': newItem['item'],
          'qtn': qtn,
        };
      }

      final functionName = widget.table == 'inputs'
          ? 'update_input_v1'
          : 'update_order_v1';

      final result = await db.rpc(
        functionName,
        params: {
          'p_id': widget.item['id'],
          'p_new_items': jsonEncode(updatedItems),
        },
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Unknown error occurred';
      }

      setState(() {
        widget.item['items'] = updatedItems;
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Item updated successfully'),
            ],
          ),
          backgroundColor: AppTheme.colorSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Failed to update item: ${e.toString()}'),
            ],
          ),
          backgroundColor: AppTheme.colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> updateQtn(BuildContext context, int id, String itemName) async {
    if (qtnController.text.isEmpty) return;

    try {
      final qtn = int.tryParse(qtnController.text) ?? 0;
      if (qtn <= 0) {
        throw 'Quantity must be greater than 0';
      }

      final updatedItems = List<Map<String, dynamic>>.from(
        widget.item['items'],
      );
      final index = updatedItems.indexWhere((item) => item['id'] == id);

      if (index != -1) {
        updatedItems[index] = {
          'id': updatedItems[index]['id'],
          'item': updatedItems[index]['item'],
          'qtn': qtn,
        };
      }

      final functionName = widget.table == 'inputs'
          ? 'update_input_v1'
          : 'update_order_v1';

      final result = await db.rpc(
        functionName,
        params: {
          'p_id': widget.item['id'],
          'p_new_items': jsonEncode(updatedItems),
        },
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Unknown error occurred';
      }

      setState(() {
        widget.item['items'] = updatedItems;
      });

      qtnController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Quantity updated successfully'),
            ],
          ),
          backgroundColor: AppTheme.colorSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Failed to update quantity: ${e.toString()}'),
            ],
          ),
          backgroundColor: AppTheme.colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  List<Map<String, dynamic>> filterItem(
    List<Map<String, dynamic>> data,
    String oldValue,
  ) {
    final filteredData = List<Map<String, dynamic>>.from(data);
    final currentItemNames = widget.item['items']
        .map((e) => e['item'] as String)
        .toSet();
    currentItemNames.remove(oldValue);
    filteredData.removeWhere((item) => currentItemNames.contains(item['item']));
    return filteredData;
  }

  Future<void> deleteItem(BuildContext context, int itemId) async {
    try {
      final updatedItems = List<Map<String, dynamic>>.from(
        widget.item['items'],
      );
      updatedItems.removeWhere((item) => item['id'] == itemId);

      final functionName = widget.table == 'inputs'
          ? 'update_input_v1'
          : 'update_order_v1';

      final result = await db.rpc(
        functionName,
        params: {
          'p_id': widget.item['id'],
          'p_new_items': jsonEncode(updatedItems),
        },
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Unknown error occurred';
      }

      setState(() {
        widget.item['items'] = updatedItems;
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Item deleted successfully'),
            ],
          ),
          backgroundColor: AppTheme.colorSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Failed to delete item: ${e.toString()}'),
            ],
          ),
          backgroundColor: AppTheme.colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> addNewItem(BuildContext context) async {
    if (selectedNewItemId == null ||
        selectedNewItemName == null ||
        newItemQtnController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Please select an item and enter quantity'),
            ],
          ),
          backgroundColor: AppTheme.colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    try {
      final qtn = int.tryParse(newItemQtnController.text) ?? 0;
      if (qtn <= 0) {
        throw 'Quantity must be greater than 0';
      }

      final newItem = {
        'id': int.parse(selectedNewItemId!),
        'item': selectedNewItemName!,
        'qtn': qtn,
      };

      final updatedItems = List<Map<String, dynamic>>.from(
        widget.item['items'],
      );
      updatedItems.add(newItem);

      final functionName = widget.table == 'inputs'
          ? 'update_input_v1'
          : 'update_order_v1';

      final result = await db.rpc(
        functionName,
        params: {
          'p_id': widget.item['id'],
          'p_new_items': jsonEncode(updatedItems),
        },
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Unknown error occurred';
      }

      setState(() {
        widget.item['items'] = updatedItems;
      });

      // Reset form
      selectedNewItemId = null;
      selectedNewItemName = null;
      newItemQtnController.clear();

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Item added successfully'),
            ],
          ),
          backgroundColor: AppTheme.colorSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Failed to add item: ${e.toString()}'),
            ],
          ),
          backgroundColor: AppTheme.colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  List<Map<String, dynamic>> getAvailableItemsForAdd() {
    final currentItemNames = widget.item['items']
        .map((e) => e['item'] as String)
        .toSet();

    return data
        .where((item) => !currentItemNames.contains(item['item']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Container(
        decoration: AppTheme.cardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.colorMain.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.colorMain.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.table == 'orders'
                          ? Icons.shopping_cart
                          : Icons.inventory,
                      color: AppTheme.colorMain,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l10n?.edit ?? "Edit"} ${widget.table == 'orders' ? (l10n?.order ?? 'Order') : (l10n?.production ??'Production')} ${l10n?.details ?? "details"}',
                        style: AppTheme.titleStyle.copyWith(
                          color: AppTheme.colorMain,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildEditableField(
                      label: 'Date',
                      value: widget.item['date'] ?? 'Not set',
                      icon: Icons.calendar_today,
                      onTap: () {
                        showCustomDialog(
                          context,
                          'Update Date',
                          DatePicker(controller: dateController),
                          (value) => updateDateNoaClientSender(
                            context,
                            'date',
                            widget.table,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.item['noa'] != null)
                    Expanded(
                      child: _buildEditableField(
                        label: 'NOA',
                        value: widget.item['noa'] ?? 'Not set',
                        icon: Icons.numbers,
                        onTap: () {
                          showCustomDialog(
                            context,
                            'Update NOA',
                            Input(controller: noaController, labelText: 'NOA'),
                            (value) => updateDateNoaClientSender(
                              context,
                              'noa',
                              widget.table,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),

              if (widget.table == 'orders' ||
                  widget.table == 'inputs' &&
                      widget.item['type'] == 'Return') ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (widget.item['sender'] != null)
                      Expanded(
                        child: _buildEditableField(
                          label: 'Sender',
                          value: widget.item['sender'] ?? 'Not set',
                          icon: Icons.person,
                          onTap: () {
                            showCustomDialog(
                              context,
                              'Update Sender',
                              Input(
                                controller: senderController,
                                labelText: 'Sender',
                              ),
                              (value) => updateDateNoaClientSender(
                                context,
                                'sender',
                                widget.table,
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (widget.item['client'] != null)
                      Expanded(
                        child: _buildEditableField(
                          label: 'Client',
                          value: widget.item['client'] ?? 'Not set',
                          icon: Icons.business,
                          onTap: () {
                            String? selectedClientId;
                            showCustomDialog(
                              context,
                              'Update Client',
                              Selector(
                                controller: TextEditingController(),
                                allItems: allClients,
                                labelText: 'Client',
                                onItemChanged: (newValue) =>
                                    selectedClientId = newValue,
                                valueKey: 'id',
                                displayKey: 'name',
                                defaultValue: widget.item['client_id']
                                    ?.toString(),
                              ),
                              (value) =>
                                  updateClient(context, selectedClientId),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              Text(
                l10n?.items??'Items',
                style: AppTheme.headingStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.colorMain.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n?.name ?? 'Item Name',
                              style: AppTheme.bodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.colorMain,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                               l10n?.qty ??'Quantity',
                              style: AppTheme.bodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.colorMain,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                               l10n?.delete ??'Delete',
                              style: AppTheme.bodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.colorMain,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ...List.generate(widget.item['items'].length, (index) {
                      final subItem = widget.item['items'][index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.borderColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildEditableField(
                                  label: '',
                                  value: subItem['item']?.toString() ?? '',
                                  icon: Icons.edit,
                                  onTap: () async {
                                    await refreshStoreData();
                                    String select = '';
                                    showCustomDialog(
                                      context,
                                      'Update Item',
                                      Selector(
                                        controller: TextEditingController(
                                          text: subItem['item'],
                                        ),
                                        allItems: filterItem(
                                          data,
                                          subItem['item'],
                                        ),
                                        labelText: 'Item',
                                        onItemChanged: (newValue) =>
                                            select = newValue,
                                      ),
                                      (value) => updateItem(
                                        context,
                                        subItem['id'],
                                        subItem['qtn'],
                                        subItem['item'],
                                        select,
                                      ),
                                    );
                                  },
                                  compact: true,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildEditableField(
                                  label: '',
                                  value: subItem['qtn']?.toString() ?? '',
                                  icon: Icons.edit,
                                  onTap: () async {
                                    await refreshStoreData();
                                    qtnController.text =
                                        subItem['qtn']?.toString() ?? '';
                                    showCustomDialog(
                                      context,
                                      'Update Quantity',
                                      Input(
                                        controller: qtnController,
                                        labelText: 'New Quantity',
                                        keyboardType: TextInputType.number,
                                      ),
                                      (value) => updateQtn(
                                        context,
                                        subItem['id'],
                                        subItem['item'],
                                      ),
                                    );
                                  },
                                  compact: true,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 40,
                                child: IconButton(
                                  onPressed: () async {
                                    await refreshStoreData();
                                    showCustomDialog(
                                      context,
                                      'Delete Item',
                                      Text(
                                        'Are you sure you want to delete "${subItem['item']}"?',
                                      ),
                                      (value) =>
                                          deleteItem(context, subItem['id']),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  tooltip: 'Delete item',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await refreshStoreData();
                          selectedNewItemId = null;
                          selectedNewItemName = null;
                          newItemQtnController.clear();
                          showCustomDialog(
                            context,
                            l10n?.addItems ?? 'Add New Item',
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Selector(
                                  controller: TextEditingController(),
                                  allItems: getAvailableItemsForAdd(),
                                  labelText: 'Select Item',
                                  onItemChanged: (newValue) {
                                    if (newValue.isNotEmpty) {
                                      final selectedItem =
                                          getAvailableItemsForAdd().firstWhere(
                                            (item) =>
                                                item['id'].toString() ==
                                                newValue,
                                          );
                                      selectedNewItemId = newValue;
                                      selectedNewItemName =
                                          selectedItem['item'];
                                    }
                                  },
                                  valueKey: 'id',
                                  displayKey: 'item',
                                ),
                                const SizedBox(height: 12),
                                Input(
                                  controller: newItemQtnController,
                                  labelText: 'Quantity',
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                            (value) => addNewItem(context),
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: Text(
                          l10n?.addItems ??'Add New Item',
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.colorMain,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    bool compact = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.inputBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: compact
                ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                : const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!compact && label.isNotEmpty) ...[
                        Text(
                          label,
                          style: AppTheme.captionStyle.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 1),
                      ],
                      Text(
                        value,
                        style: compact
                            ? AppTheme.bodyStyle.copyWith(fontSize: 12)
                            : AppTheme.bodyStyle.copyWith(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
