import 'package:darttest/widget/common/input.dart';
import 'package:flutter/material.dart';
import "../../../database/database.dart";
import "../../../widget/common/btn.dart";
import "../../../widget/common/dialog.dart";
import "../../../widget/common/date_picker.dart";

class EditCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final String table;

  EditCard({required this.item, required this.table});

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
  final TextEditingController clientController = TextEditingController();
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
      if (response != null) {
        setState(() {
          data = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  Future<void> updateDateNoaClientSender(BuildContext context, String type, table) async {
    if ((type == 'date' && dateController.text.isEmpty) ||
        (type == 'noa' && noaController.text.isEmpty) ||
        (type == 'sender' && senderController.text.isEmpty) ||
        (type == 'client' && clientController.text.isEmpty)) {
      return;
    }



    await db.update(
      table: table,
      id: widget.item['id'],
      data: {type: type == 'date' ? dateController.text : type == 'sender' ? senderController.text : type == 'client' ? clientController.text : noaController.text},
      context: context,
    );

    // تحديث الواجهة بعد التعديل
    setState(() {
      widget.item[type] = type == 'date'
          ? dateController.text
          : type == 'sender' ? senderController.text : type == 'client' ? clientController.text : noaController.text;
    });

    dateController.clear();
    noaController.clear();
    senderController.clear();
    clientController.clear();
    // إغلاق الـ Dialog بعد اكتمال التحديث
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$type updated successfully')));
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

      final result = await db.rpc(
        'update_input_with_inventory_v2',
        params: {'input_id': widget.item['id'], 'new_items': updatedItems},
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Unknown error occurred';
      }

      setState(() {
        widget.item['items'] = updatedItems;
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Item updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update item: ${e.toString()}')),
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

      final result = await db.rpc(
        'update_input_with_inventory_v2',
        params: {'input_id': widget.item['id'], 'new_items': updatedItems},
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Quantity updated successfully')));
    } catch (e) {
      print('Update Quantity Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: ${e.toString()}')),
      );
    }
  }

  List<Map<String, dynamic>> filterItem(
    List<Map<String, dynamic>> data,
    String oldValue,
  ) {
    final filteredData = List<Map<String, dynamic>>.from(data);
    widget.item['items'].forEach((e) {
      filteredData.removeWhere((item) => item['item'] == e['item']);
    });
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Btn(
                  width: 160,
                  title:"Sender: ${widget.item['sender'] ?? ''}",
                  onTap: () {
                    showCustomDialog(
                      context,
                      'Update ${widget.item['sender'] ?? ''}',
                      Input(controller: senderController, labelText: 'sender'),
                      (value) => updateDateNoaClientSender(context, 'sender', widget.table),
                    );
                  },
                ),
                if (widget.item['client'] != null)
                  Btn(
                    width: 160,
                    title: "Client: ${widget.item['client'] ?? ''}",
                    onTap: () {
                      showCustomDialog(
                        context,
                        'Update ${widget.item['client'] ?? ''}',
                        Input(controller: clientController, labelText: 'client'),
                        (value) => updateDateNoaClientSender(context, 'client', widget.table),
                      );
                    },
                  ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Btn(
                  title: widget.item['date'] ?? '',
                  onTap: () {
                    showCustomDialog(
                      context,
                      'Update ${widget.item['date'] ?? ''}',
                      DatePicker(controller: dateController),
                      (value) => updateDateNoaClientSender(context, 'date', widget.table),
                    );
                  },
                ),
                if (widget.item['noa'] != null)
                  Btn(
                    title: widget.item['noa'] ?? '',
                    onTap: () {
                      showCustomDialog(
                        context,
                        'Update ${widget.item['noa'] ?? ''}',
                        Input(controller: noaController, labelText: 'noa'),
                        (value) => updateDateNoaClientSender(context, 'noa', widget.table),
                      );
                    },
                  ),
              ],
            ),
            Divider(),
            Table(
              columnWidths: {0: FlexColumnWidth(3), 1: FlexColumnWidth(1)},
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Item Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Qty',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...List.generate(widget.item['items'].length, (index) {
                  final subItem = widget.item['items'][index];
                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Btn(
                          title: subItem['item']?.toString() ?? '',
                          onTap: () {
                            String select = '';
                            showCustomDialog(
                              context,
                              'Update ${subItem['item'] ?? ''}',
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Item *',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                items: filterItem(data, subItem['item']).map((
                                  item,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: item['item'] as String,
                                    child: Text(item['item'] as String),
                                  );
                                }).toList(),
                                onChanged: (newValue) =>
                                    select = newValue ?? '',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select an item';
                                  }
                                  return null;
                                },
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
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Btn(
                          title: subItem['qtn']?.toString() ?? '',
                          onTap: () {
                            qtnController.text =
                                subItem['qtn']?.toString() ?? '';
                            showCustomDialog(
                              context,
                              'Update ${subItem['qtn'] ?? ''}',
                              Input(
                                controller: qtnController,
                                labelText: 'qtn',
                                keyboardType: TextInputType.number,
                              ),
                              (value) => updateQtn(
                                context,
                                subItem['id'],
                                subItem['item'],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
