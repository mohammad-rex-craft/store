import 'package:flutter/material.dart';
import '../../../database/database.dart';
import '../../../utility/hooks.dart';
import '../../../utility/theme.dart';
import '../../common/btn.dart';

class CardOutput extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<Map<String, dynamic>> store;
  final onRefresh;
  final DatabaseService db = DatabaseService();

  CardOutput({
    super.key,
    required this.item,
    required this.store,
    required this.onRefresh,
  });

  Future<void> onDelete(int id, BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
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
                  Icons.delete_forever,
                  color: AppTheme.colorError,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Delete Order',
                  style: AppTheme.titleStyle.copyWith(
                    color: AppTheme.colorError,
                  ),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to delete this order record? This action cannot be undone.',
              style: AppTheme.bodyStyle,
            ),
            actions: [
              Btn(
                title: 'Cancel',
                btnType: BtnType.secondary,
                onTap: () => navigator.pop(false),
              ),
              Btn(
                title: 'Delete',
                btnType: BtnType.error,
                onTap: () => navigator.pop(true),
              ),
            ],
          );
        },
      );

      if (confirm != true) return;

      final result = await db.rpc(
        'delete_order',
        params: {'p_id': id},
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Failed to delete order';
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text('Order deleted successfully'),
            ],
          ),
          backgroundColor: AppTheme.colorSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      onRefresh();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Error: ${e.toString()}'),
            ],
          ),
          backgroundColor: AppTheme.colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section - Compact
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.colorWarning.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Date and Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.output,
                            color: AppTheme.colorWarning,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Order',
                            style: AppTheme.captionStyle.copyWith(
                              color: AppTheme.colorWarning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['date'] ?? '',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Invoice Number (if exists)
                if (item['noa'] != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.colorWarning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.colorWarning.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'NOA: ${item['noa'] ?? ''}',
                      style: AppTheme.captionStyle.copyWith(
                        color: AppTheme.colorWarning,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppTheme.colorInfo,
                        size: 18,
                      ),
                      onPressed: () => dinamecRouter(context, '/edit', {
                        'items': item,
                        'type': 'orders',
                      }),
                      tooltip: 'Edit',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: AppTheme.colorError,
                        size: 18,
                      ),
                      onPressed: () => onDelete(item['id'], context),
                      tooltip: 'Delete',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sender and Client - Compact
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: _buildCompactInfo(
                    icon: Icons.person_outline,
                    label: 'Sender',
                    value: item['sender'] ?? '',
                    color: AppTheme.colorInfo,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCompactInfo(
                    icon: Icons.person,
                    label: 'Client',
                    value: item['client'] ?? '',
                    color: AppTheme.colorSuccess,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Items Section - Compact
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  children: [
                    Icon(
                      Icons.inventory,
                      color: AppTheme.textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Items (${(item['items'] as List).length})',
                      style: AppTheme.captionStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Items List - Compact
                ...(item['items'] as List).map((subItem) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.borderColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            subItem['item']?.toString() ?? '',
                            style: AppTheme.captionStyle.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.colorWarning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Qty: ${subItem['qtn']?.toString() ?? '0'}',
                            style: AppTheme.captionStyle.copyWith(
                              color: AppTheme.colorWarning,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 12),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTheme.captionStyle.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                value,
                style: AppTheme.captionStyle.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
