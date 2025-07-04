import 'package:flutter/material.dart';
import '../../../database/database.dart';
import '../../../utility/theme.dart';
import '../../../l10n/app_localizations.dart';

class CardSettlement extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRefresh;

  const CardSettlement({
    super.key,
    required this.item,
    required this.onRefresh,
  });

  @override
  State<CardSettlement> createState() => _CardSettlementState();
}

class _CardSettlementState extends State<CardSettlement> {
  final DatabaseService db = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteSettlement() async {
    final l10n = AppLocalizations.of(context);
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 10),
              Text(l10n?.confirmDeletion ?? 'Confirm Deletion'),
            ],
          ),
          content: Text(
            l10n?.thisWillPermanentlyDeleteTheSettlementAndRevertTheItemQuantitiesInYourInventoryAreYouSure ??
                'This will permanently delete the settlement and revert the item quantities in your inventory. Are you sure?',
          ),
          actions: [
            TextButton(
              child: Text(
                l10n?.cancel ?? 'Cancel',
                style: const TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                child: Text(
                  l10n?.delete ?? 'Delete',
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      try {
        await db.deleteSettlement(
          settlementId: widget.item['id'],
          context: context,
        );
        widget.onRefresh();
      } catch (e) {
        // Error is already shown by the db service, but you can log it here if needed.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final List<dynamic> adjustedItems = widget.item['items'] ?? [];
    final String reason = widget.item['reason'] ?? 'No reason provided';

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
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.colorInfo.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: AppTheme.colorInfo.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.compare_arrows_rounded,
                  color: AppTheme.colorInfo,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n?.settlement ?? 'Settlement',
                  style: AppTheme.captionStyle.copyWith(
                    color: AppTheme.colorInfo,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '${l10n?.noa ?? 'Noa'}: ${widget.item['noa']}',
                  style: AppTheme.captionStyle.copyWith(
                    color: const Color.fromARGB(255, 131, 40, 40),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.item['date'] ?? '',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppTheme.colorError,
                      size: 20,
                    ),
                    onPressed: _deleteSettlement,
                  ),
                ),
              ],
            ),
          ),
          // Body with Items List
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reason.isNotEmpty && reason != 'No reason provided') ...[
                  _buildReasonBanner(reason),
                  const SizedBox(height: 12),
                ],
                // Items Header
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      color: AppTheme.textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${l10n?.adjustedItems ?? 'Adjusted Items'} (${adjustedItems.length})',
                      style: AppTheme.captionStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Items List
                ListView.builder(
                  itemCount: adjustedItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final adjustedItem = adjustedItems[index];
                    final int qtn = adjustedItem['qtn'];
                    final bool isPositive = qtn > 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.inputBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.borderColor.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              adjustedItem['item'] ?? 'Unknown Item',
                              style: AppTheme.bodyStyle.copyWith(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (isPositive
                                          ? AppTheme.colorSuccess
                                          : AppTheme.colorError)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${isPositive ? "+" : ""}$qtn',
                              style: AppTheme.captionStyle.copyWith(
                                fontSize: 14,
                                color: isPositive
                                    ? AppTheme.colorSuccess
                                    : AppTheme.colorError,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonBanner(String reason) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.reasonNotes ?? 'Reason / Notes:',
            style: AppTheme.captionStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(reason, style: AppTheme.bodyStyle),
        ],
      ),
    );
  }
}
