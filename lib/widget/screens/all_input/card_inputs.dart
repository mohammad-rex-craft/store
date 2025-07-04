import 'package:flutter/material.dart';
import "../../../database/database.dart";
import '../../../utility/hooks.dart';
import '../../../utility/theme.dart';
import '../../common/btn.dart';
import '../../../l10n/app_localizations.dart';

class CardInputs extends StatelessWidget {
  final Map<String, dynamic> item;
  final DatabaseService db = DatabaseService();
  final List<Map<String, dynamic>> store;
  final Function onRefresh;

  CardInputs({super.key, 
    required this.item,
    required this.store,
    required this.onRefresh,
  });

  Future<void> onDelete(int id, BuildContext context) async {
    final l10n = AppLocalizations.of(context);
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
                const Icon(Icons.delete_forever, color: AppTheme.colorError, size: 24),
                const SizedBox(width: 8),
                Text(
                  l10n?.deleteInput ?? 'Delete Input',
                  style: AppTheme.titleStyle.copyWith(color: AppTheme.colorError),
                ),
              ],
            ),
            content: Text(
              l10n?.areYouSureYouWantToDeleteThisInputRecord ?? 'Are you sure you want to delete this input record? This action cannot be undone.',
              style: AppTheme.bodyStyle,
            ),
            actions: [
              Btn(
                title: l10n?.cancel ?? 'Cancel',
                btnType: BtnType.secondary,
                onTap: () => navigator.pop(false),
              ),
              Btn(
                title: l10n?.delete ?? 'Delete',
                btnType: BtnType.error,
                onTap: () => navigator.pop(true),
              ),
            ],
          );
        },
      );

      if (confirm != true) return;

      final result = await db.rpc(
        'delete_input',
        params: {'p_id': id},
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Failed to delete input';
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(l10n?.inputDeletedSuccessfully ?? 'Input deleted successfully'),
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
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(l10n?.error ?? 'Error: ${e.toString()}'),
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
    final l10n = AppLocalizations.of(context);
    final bool isReturn = item['noa'] != null;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: isReturn ? AppTheme.colorError.withOpacity(0.1) : AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isReturn ? AppTheme.colorError.withOpacity(0.3) : AppTheme.borderColor,
          width: 1,
        ),
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
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isReturn ? AppTheme.colorError.withOpacity(0.05) : AppTheme.colorMain.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isReturn ? Icons.assignment_return : Icons.add_circle,
                            color: isReturn ? AppTheme.colorError : AppTheme.colorMain,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isReturn ? l10n?.returnitem ?? 'Return' : l10n?.production ?? 'Production',
                            style: AppTheme.captionStyle.copyWith(
                              color: isReturn ? AppTheme.colorError : AppTheme.colorMain,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
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
                
                
                if (isReturn) ...[
                  Column(
                    children: [
                      Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.colorError.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.colorError.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${l10n?.noa ?? 'NOA'}: ${item['noa'] ?? ''}',
                      style: AppTheme.captionStyle.copyWith(
                        color: AppTheme.colorError,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.colorMain.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.colorMain.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${l10n?.client ?? 'Client'}: ${item['client'] ?? ''}',
                      style: AppTheme.captionStyle.copyWith(
                        color: AppTheme.colorText,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                    ],
                  )
                ],
                
                
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppTheme.colorInfo, size: 18),
                      onPressed: () => dynamicRouter(
                        context, 
                        '/edit', 
                        {'items': item, 'type': 'inputs'}
                      ),
                      tooltip: l10n?.edit ?? 'Edit',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppTheme.colorError, size: 18),
                      onPressed: () => onDelete(item['id'], context),
                      tooltip: l10n?.delete ?? 'Delete',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  children: [
                    const Icon(
                      Icons.inventory,
                      color: AppTheme.textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${l10n?.items ?? 'Items'} (${(item['items'] as List).length})',
                      style: AppTheme.captionStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                
                ...(item['items'] as List).map((subItem) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.borderColor.withOpacity(0.3)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.colorMain.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${l10n?.quantity ?? 'Qty'}: ${subItem['qtn']?.toString() ?? '0'}',
                            style: AppTheme.captionStyle.copyWith(
                              color: AppTheme.colorMain,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                
                // عرض مجموع القطع
                if ((item['items'] as List).isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.colorMain.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.colorMain.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calculate,
                              color: AppTheme.colorMain,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n?.totalItems ?? 'المجموع',
                              style: AppTheme.captionStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.colorMain,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          (item['items'] as List).fold<int>(0, (sum, subItem) => 
                            sum + (subItem['qtn'] as int? ?? 0)
                          ).toString(),
                          style: AppTheme.captionStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colorMain,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
