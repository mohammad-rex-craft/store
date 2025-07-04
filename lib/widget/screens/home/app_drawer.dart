import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';
import '../../../database/auth/log_in_out.dart';
import '../../../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              hexToColor('#303F9F'),
              hexToColor('#1976D2'),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: [
                  Container(
                    decoration:const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'images/playstore.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'StoreFlow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.inventoryManagementSystem ?? 'Inventory Management System',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu Items
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    _buildMenuItem(
                      context: context,
                      title: l10n?.storage ?? 'Storage',
                      subtitle: l10n?.showStorage ?? 'show storage',
                      icon: Icons.inventory_2,
                      color: Colors.orange,
                      route: '/storage',
                    ),
                    _buildMenuItem(
                      context: context,
                      title: l10n?.allOrders ?? 'All Orders',
                      subtitle: l10n?.showAllOrders ?? 'show all orders',
                      icon: Icons.receipt_long,
                      color: Colors.purple,
                      route: '/all_output',
                    ),
                    _buildMenuItem(
                      context: context,
                      title: l10n?.allInputs ?? 'All Inputs',
                      subtitle: l10n?.showAllInputs ?? 'show all inputs',
                      icon: Icons.input,
                      color: Colors.teal,
                      route: '/all_input',
                    ),
                    _buildMenuItem(
                      context: context,
                      title: l10n?.clients ?? 'Clients',
                      subtitle: l10n?.showAllClients ?? 'show all clients',
                      icon: Icons.people,
                      color: Colors.pink,
                      route: '/all_client',
                    ),
                    _buildMenuItem(
                      context: context,
                      title: l10n?.allSettlements ?? 'All Settlements',
                      subtitle: l10n?.showAllSettlements ?? 'show all settlements',
                      icon: Icons.balance,
                      color: Colors.indigo,
                      route: '/all_settlements',
                    ),
                    _buildMenuItem(
                      context: context,
                      title: l10n?.inventory ?? 'Inventory',
                      subtitle: l10n?.showInventory ?? 'show inventory',
                      icon: Icons.person_add,
                      color: Colors.cyan,
                      route: '/inventory',
                    ),
                    const Divider(height: 32),
                    _buildMenuItem(
                      context: context,
                      title: l10n?.logout ?? 'Log Out',
                      subtitle: l10n?.logoutFromStoreflow ?? 'logout from storeflow',
                      icon: Icons.logout,
                      color: Colors.red,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    String? route,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 16,
        ),
        onTap: onTap ?? () {
          Navigator.pop(context); // إغلاق القائمة الجانبية
          if (route != null) {
            router(context, route);
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title:  Row(
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 28),
              const SizedBox(width: 10),
              Text(
                l10n?.logoutFromStoreflow ?? 'تسجيل الخروج',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            l10n?.areYouSureLogout ?? 'هل أنت متأكد من تسجيل الخروج؟',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:  Text(
                l10n?.cancel ?? 'إلغاء',
                style:const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:  Row(
                      children: [
                        const Icon(Icons.info, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(l10n?.loggingOut ?? 'جاري تسجيل الخروج...'),
                      ],
                    ),
                    backgroundColor: Colors.blue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                LogInOut().signOut(context);
              },
                child:  Text(
                l10n?.confirm ?? 'تأكيد',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
} 