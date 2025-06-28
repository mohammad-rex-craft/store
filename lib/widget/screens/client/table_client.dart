import 'package:flutter/material.dart';
import 'package:storeflow/utility/theme.dart';
import 'package:storeflow/database/database.dart';
import 'package:storeflow/utility/hooks.dart';

class TableClient extends StatelessWidget {
  final List<Map<String, dynamic>> clients;
  final bool sortAscending;
  final int? sortColumnIndex;
  final Function(int, bool) onSort;
  final Future<void> Function() onRefresh;
  final DatabaseService db = DatabaseService();

  TableClient({
    super.key,
    required this.clients,
    required this.sortAscending,
    required this.sortColumnIndex,
    required this.onSort,
    required this.onRefresh,
  });

  Future<void> deleteClient(int id, BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning, color: AppTheme.colorWarning, size: 24),
              const SizedBox(width: 8),
              Text(
                'Delete Client',
                style: AppTheme.titleStyle.copyWith(color: AppTheme.colorError),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this client?',
            style: AppTheme.bodyStyle,
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: AppTheme.bodyStyle.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorError,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await db.delete(table: 'client', id: id, context: context);
        onRefresh();
      } catch (e) {
        // Error is handled in db service
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.colorInfo.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, color: AppTheme.colorInfo, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Client Records',
                  style: AppTheme.titleStyle.copyWith(
                    color: AppTheme.colorInfo,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.colorInfo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${clients.length} records',
                    style: AppTheme.captionStyle.copyWith(
                      color: AppTheme.colorInfo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    sortAscending: sortAscending,
                    sortColumnIndex: sortColumnIndex,
                    columns: [
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Name',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorInfo,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onSort: (columnIndex, ascending) =>
                            onSort(columnIndex, ascending),
                      ),

                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Phone',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorInfo,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onSort: (columnIndex, ascending) =>
                            onSort(columnIndex, ascending),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Actions',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorInfo,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    rows: clients.map((client) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: InkWell(
                                  onTap: () => dynamicRouter(
                                    context,
                                    '/show_all_by_id',
                                    {
                                      'id': client['id'],
                                      'name': client['name'],
                                      'type': 'inputs',
                                    },
                                  ),
                                  child: Text(
                                    client['name']?.toString() ?? '0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: InkWell(
                                  onTap: () => dynamicRouter(
                                    context,
                                    '/show_all_by_id',
                                    {
                                      'id': client['id'],
                                      'name': client['name'],
                                      'type': 'orders',
                                    },
                                  ),
                                  child: Text(
                                    client['phone']?.toString() ?? '0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.teal.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.bar_chart,
                                      color: AppTheme.textSecondary,
                                    ),
                                    onPressed: () {
                                      dynamicRouter(
                                        context,
                                        '/chart_client',
                                        client,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: AppTheme.colorMain,
                                    ),
                                    onPressed: () {
                                      dynamicRouter(
                                        context,
                                        '/edit_client',
                                        client,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: AppTheme.colorError,
                                    ),
                                    onPressed: () =>
                                        deleteClient(client['id'], context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
