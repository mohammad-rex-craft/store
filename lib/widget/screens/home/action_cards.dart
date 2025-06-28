import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';

class ActionCards extends StatelessWidget {
  const ActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildActionCard(
          context: context,
          title: 'Add Items',
          subtitle: 'Add new items to the inventory',
          icon: Icons.add_circle_outline,
          color: Colors.green,
          onTap: () => router(context, '/add_items'),
        ),
        _buildActionCard(
          context: context,
          title: 'Remove Items',
          subtitle: 'Remove items from the inventory',
          icon: Icons.remove_circle_outline,
          color: Colors.red,
          onTap: () => router(context, '/remove_items'),
        ),
        _buildActionCard(
          context: context,
          title: 'Settlement',
          subtitle: 'Settlement of items',
          icon: Icons.receipt_long,
          color: Colors.blue,
          onTap: () => router(context, '/inventory_settlement'),
        ),
        _buildActionCard(
          context: context,
          title: 'Create Client',
          subtitle: 'Manage the client',
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
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
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
