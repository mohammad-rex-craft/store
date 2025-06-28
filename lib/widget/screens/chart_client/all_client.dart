import 'package:flutter/material.dart';
import 'package:storeflow/database/database.dart';
import 'package:storeflow/widget/common/bar.dart';
import 'package:storeflow/widget/screens/client/table_client.dart'; // We will create this next
import 'package:storeflow/utility/theme.dart';

class AllClients extends StatefulWidget {
  const AllClients({super.key});

  @override
  State<AllClients> createState() => _AllClientsState();
}

class _AllClientsState extends State<AllClients> {
  final DatabaseService db = DatabaseService();
  List<Map<String, dynamic>> clients = [];
  bool isLoading = true;
  bool sortAscending = true;
  int? sortColumnIndex;

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await db.readAll(
        table: 'client',
        context: context,
        errorMessage: "Failed to fetch clients",
      );
      if (mounted) {
        setState(() {
          clients = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;

      clients.sort((a, b) {
        dynamic aValue;
        dynamic bValue;

        switch (columnIndex) {
          case 0:
            aValue = a['name'];
            bValue = b['name'];
            break;
          case 1:
            aValue = a['phone'];
            bValue = b['phone'];
            break;
          default:
            return 0;
        }

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return ascending ? -1 : 1;
        if (bValue == null) return ascending ? 1 : -1;

        final comparison = aValue.toString().compareTo(bValue.toString());
        return ascending ? comparison : -comparison;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const Bar(
        title: 'All Clients',
        color: AppTheme.colorInfo,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: isLoading
            ? Center(
                child: Container(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppTheme.colorInfo),
                      const SizedBox(height: 16),
                      Text('Loading Clients...',
                          style: AppTheme.bodyStyle
                              .copyWith(color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              )
            : TableClient(
                clients: clients,
                onRefresh: _fetchClients,
                sortAscending: sortAscending,
                sortColumnIndex: sortColumnIndex,
                onSort: onSort,
              ),
      ),
    );
  }
}
