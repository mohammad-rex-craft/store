import 'package:flutter/material.dart';
import '../../widget/common/bar.dart';
import '../../database/database.dart';
import '../../widget/screens/inventory/table_inv.dart';
import '../../utility/theme.dart';
import '../../l10n/app_localizations.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final DatabaseService db = DatabaseService();
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
  }

  Future<void> loadInitialData() async {
    setState(() => isLoading = true);
    await Future.wait([getInv()]);
    setState(() => isLoading = false);
  }
  bool sortAscending = true;
  int? sortColumnIndex;

  Future<void> getInv() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      isLoading = true;
    });

    try {
      final response = await db.readAll(
        table: 'inventory',
        context: context,
        errorMessage: l10n?.errorLoadingData??  "Network error occurred while fetching items",
      );
      setState(() {
        data = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;

      data.sort((a, b) {
        var aValue = a.values.elementAt(columnIndex);
        var bValue = b.values.elementAt(columnIndex);

        if (aValue is num && bValue is num) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        if (aValue is String && bValue is String) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return ascending ? -1 : 1;
        if (bValue == null) return ascending ? 1 : -1;

        return ascending
            ? aValue.toString().compareTo(bValue.toString())
            : bValue.toString().compareTo(aValue.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: Bar(title: l10n?.inventory ?? 'Inventory', color: AppTheme.colorMain),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            color: AppTheme.colorMain,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n?.loading ?? 'Loading Inventory...',
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : TableInv(
                data: data,
                sortAscending: sortAscending,
                sortColumnIndex: sortColumnIndex,
                onSort: onSort,
                onRefresh: getInv,
              ),
      ),
    );
  }
}
