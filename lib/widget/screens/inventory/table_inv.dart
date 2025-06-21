import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';
import '../../../utility/theme.dart';
import '../../common/btn.dart';
import '../../../database/database.dart';

class TableInv extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool sortAscending;
  final int? sortColumnIndex;
  final Function(int, bool) onSort;
  final DatabaseService db = DatabaseService();
  final onRefresh;

  TableInv({
    super.key,
    required this.data,
    required this.sortAscending,
    required this.sortColumnIndex,
    required this.onSort,
    required this.onRefresh,
  });

  Future<void> deleteItem(int id, BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: AppTheme.colorWarning,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Delete Inventory',
                style: AppTheme.titleStyle.copyWith(
                  color: AppTheme.colorError,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this inventory record?',
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
        await db.delete(
          table: 'inventory',
          id: id,
          context: context,

        );
        onRefresh();
      } catch (e) {
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.colorMain.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.inventory,
                  color: AppTheme.colorMain,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Inventory Records',
                  style: AppTheme.titleStyle.copyWith(
                    color: AppTheme.colorMain,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.colorMain.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${data.length} records',
                    style: AppTheme.captionStyle.copyWith(
                      color: AppTheme.colorMain,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: DataTable(
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    columns: [
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'ID',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorMain,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Date',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorMain,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Actions',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorMain,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    rows: data.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.colorMain.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['id'].toString(),
                                  style: AppTheme.bodyStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.colorMain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                item['date'].toString().split(' ')[0],
                                style: AppTheme.bodyStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorInfo.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.visibility,
                                      color: AppTheme.colorInfo,
                                      size: 20,
                                    ),
                                    onPressed: () => dinamecRouter(
                                      context,
                                      '/inventory_by_id',
                                      {'id': item['id']},
                                    ),
                                    tooltip: 'View Details',
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 36,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorError.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppTheme.colorError,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        deleteItem(item['id'], context),
                                    tooltip: 'Delete Record',
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 36,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: sortAscending,
                    headingRowColor: MaterialStateProperty.all(
                      AppTheme.backgroundColor,
                    ),
                    dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return AppTheme.colorMain.withOpacity(0.1);
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
