import 'package:flutter/material.dart';
import '../../widget/common/bar.dart';
import '../../database/database.dart';
import '../../widget/screens/inventory/table_inv.dart';

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
    getInv();
    super.initState();
  }

  bool sortAscending = true;
  int? sortColumnIndex;

  Future<void> getInv() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final response = await db.readAll(
        table: 'inventory',
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      if (response != null) {
        setState(() {
          data = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Error is already handled by DatabaseService
    }
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;

      data.sort((a, b) {
        var aValue = a.values.elementAt(columnIndex);
        var bValue = b.values.elementAt(columnIndex);

        // Handle numeric values
        if (aValue is num && bValue is num) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        }

        // Handle string values
        if (aValue is String && bValue is String) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        }

        // Handle null values
        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return ascending ? -1 : 1;
        if (bValue == null) return ascending ? 1 : -1;

        // Default comparison
        return ascending ? aValue.toString().compareTo(bValue.toString()) 
                        : bValue.toString().compareTo(aValue.toString());
      });
    });
  }
 
  
 
 
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: Bar(title: 'Inventory'),
          body: Center(
            child: isLoading 
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              : TableInv(
                  data: data,
                  sortAscending: sortAscending,
                  sortColumnIndex: sortColumnIndex,
                  onSort: onSort,
                  onRefresh: getInv,
                ),
          ),
        ),
      ],
    );
  }
}
