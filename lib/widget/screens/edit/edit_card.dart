import '../../common/input.dart';
import 'package:flutter/material.dart';
import "../../../database/database.dart";
import "../../../widget/common/dialog.dart";
import "../../../widget/common/date_picker.dart";
import "../../../widget/common/selector.dart";
import "../../../utility/theme.dart";
import 'dart:convert';

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
  final DatabaseService db = DatabaseService();
  List<Map<String, dynamic>> data = [];
  final TextEditingController senderController = TextEditingController();
  List<Map<String, dynamic>> allClients = [];

  @override
  void initState() {
    super.initState();
    getItems();
  }


  Future<void> getItems() async {
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
        data = sortedData;
        allClients = responseClients ?? [];
      });
        } catch (e) {
      print(e);
    }
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

  Future<void> updateClient(BuildContext context, String? newClientIdStr) async {
    if (newClientIdStr == null || newClientIdStr.isEmpty) return;

    final newClientId = int.parse(newClientIdStr);
    final newClientName =
        allClients.firstWhere((c) => c['id'] == newClientId)['name'];

    await db.update(
      table: widget.table,
      id: widget.item['id'],
      data: {
        'client_id': newClientId,
        'client': newClientName,
      },
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

      final functionName =
          widget.table == 'inputs' ? 'update_input_v1' : 'update_order_v1';

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

      final functionName =
          widget.table == 'inputs' ? 'update_input_v1' : 'update_order_v1';

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
    // Get a set of all item names currently in the list
    final currentItemNames =
        widget.item['items'].map((e) => e['item'] as String).toSet();
    // Remove the item we are currently editing from the set, so it won't be filtered out
    currentItemNames.remove(oldValue);

    // Filter the data, removing items that are in the list (but keeping the one we're editing)
    filteredData.removeWhere((item) => currentItemNames.contains(item['item']));
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.colorMain.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.colorMain.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.table == 'orders' ? Icons.shopping_cart : Icons.inventory,
                    color: AppTheme.colorMain,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Edit ${widget.table == 'orders' ? 'Order' : 'Production'} Details',
                      style: AppTheme.titleStyle.copyWith(
                        color: AppTheme.colorMain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            
            Text(
              'Basic Information',
              style: AppTheme.headingStyle.copyWith(fontSize: 18),
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
                        (value) => updateDateNoaClientSender(context, 'date', widget.table),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
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
                          (value) => updateDateNoaClientSender(context, 'noa', widget.table),
                        );
                      },
                    ),
                  ),
              ],
            ),
            
            
            if (widget.table == 'orders' || widget.table == 'inputs' && widget.item['type'] == 'Return') ...[
              const SizedBox(height: 16),
              Text(
                'Order Information',
                style: AppTheme.headingStyle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
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
                              labelText: 'Sender'),
                          (value) => updateDateNoaClientSender(
                              context, 'sender', widget.table),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
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
                              defaultValue: widget.item['client_id']?.toString(),
                            ),
                            (value) => updateClient(context, selectedClientId),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ],
            
            const SizedBox(height: 20),
            
            
            Text(
              'Items',
              style: AppTheme.headingStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            
            
            Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                children: [
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.colorMain.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Item Name',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorMain,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Quantity',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorMain,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildEditableField(
                                label: '',
                                value: subItem['item']?.toString() ?? '',
                                icon: Icons.edit,
                                onTap: () {
                                  String select = '';
                                  showCustomDialog(
                                    context,
                                    'Update Item',
                                    Selector(
                                      controller: TextEditingController(text: subItem['item']),
                                      allItems: filterItem(data, subItem['item']),
                                      labelText: 'Item',
                                      onItemChanged: (newValue) => select = newValue,
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildEditableField(
                                label: '',
                                value: subItem['qtn']?.toString() ?? '',
                                icon: Icons.edit,
                                onTap: () {
                                  qtnController.text = subItem['qtn']?.toString() ?? '';
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
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: compact 
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
              : const EdgeInsets.all(12),
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
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        value,
                        style: compact 
                          ? AppTheme.bodyStyle.copyWith(fontSize: 14)
                          : AppTheme.bodyStyle,
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
