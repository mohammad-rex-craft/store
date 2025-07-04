import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';
import '../../../l10n/app_localizations.dart';

class ActionCards extends StatelessWidget {
  const ActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildActionCard(
          context: context,
          title: l10n?.additem ?? 'Add Items',
          subtitle: l10n?.addnewitems ?? 'Add new items to the inventory',
          icon: Icons.add_circle_outline,
          color: Colors.green,
          onTap: () => router(context, '/add_items'),
        ),
        _buildActionCard(
          context: context,
          title: l10n?.removeitem ?? 'Remove Items',
          subtitle: l10n?.removeitems ?? 'Remove items from the inventory',
          icon: Icons.remove_circle_outline,
          color: Colors.red,
          onTap: () => router(context, '/remove_items'),
        ),
        _buildActionCard(
          context: context,
          title: l10n?.settlement ?? 'Settlement',
          subtitle: l10n?.settlementitems ?? 'Settlement of items',
          icon: Icons.receipt_long,
          color: Colors.blue,
          onTap: () => router(context, '/inventory_settlement'),
        ),
        _buildActionCard(
          context: context,
          title: l10n?.createclient ?? 'Create Client',
          subtitle: l10n?.manageclients ?? 'Manage the client',
          icon: Icons.person_add,
          color: Colors.pinkAccent,
          onTap: () => router(context, '/create_client'),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 7),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
