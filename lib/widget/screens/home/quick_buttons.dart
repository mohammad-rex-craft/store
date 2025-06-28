import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';
import '../../../database/auth/log_in_out.dart';

class QuickButtons extends StatelessWidget {
  const QuickButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickButton(
                context: context,
                title: 'All Inputs',
                icon: Icons.input,
                color: Colors.teal,
                onTap: () => router(context, '/all_input'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickButton(
                context: context,
                title: 'All Outputs',
                icon: Icons.output,
                color: Colors.orange,
                onTap: () => router(context, '/all_output'),
              ),
            ),
          ],
        ),
                    const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildQuickButton(
                context: context,
                title: 'inventory',
                icon: Icons.inventory,
                color: Colors.blueGrey,
                onTap: () => router(context, '/inventory'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickButton(
                context: context,
                title: 'All Settlements',
                icon: Icons.receipt_long,
                color: Colors.brown,
                onTap: () => router(context, '/all_settlements'),
              ),
            ),
          ],
        ),
           const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildQuickButton(
                context: context,
                title: 'Client',
                icon: Icons.person,
                color: Colors.blue,
                onTap: () => router(context, '/all_client'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickButton(
                context: context,
                title: 'Storage',
                icon: Icons.storage,
                color: Colors.purple,
                onTap: () => router(context, '/storage'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
