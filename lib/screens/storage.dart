import 'package:flutter/material.dart';
import '../utility/hooks.dart';
import '../widget/common/table_storage.dart';
import '../widget/screens/storage/form_create_items.dart';
import '../widget/screens/storage/form_update_items.dart';
import '../widget/common/bar.dart';
import '../database/database.dart';
  
var primeColor = hexToColor('#03A9F4');

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> indata = [];
  final DatabaseService db = DatabaseService();

  bool sortAscending = true;
  int? sortColumnIndex;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  Future<void> getItems() async {
    getItems2();
    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      if (response != null) {
        setState(() {
          data = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  Future<void> getItems2() async {
    try {
      final response = await db.readAll(
        table: 'inputs',
        context: context,
        errorMessage: "Network error occurred while fetching inputs",
      );
      if (response != null) {
        setState(() {
          indata = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
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

  void sendToInventory(context) async {
    await db.create(
      table: 'inventory',
      data: {
        'data': data,
        'date': DateTime.now().toString(),
      },
      context: context,
      successMessage: "Inventory created successfully",
      errorMessage: "Error creating inventory",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'Store'),
      backgroundColor: Color(0xFFF5F5F5),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primeColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.manage_accounts,
                          color: Colors.grey.shade700,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Edit Items',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Create Form
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: FormCreateItems(
                      onItemCreated: () {
                        getItems();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Update Form
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: FormUpdateItems(
                      items: data,
                      onItemUpdated: () {
                        getItems();
                      },
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 30),
              
              // Table Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.table_chart,
                            color: primeColor,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Store',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primeColor,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${data.length} item',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TableStorage(
                      data: data,
                      sortAscending: sortAscending,
                      sortColumnIndex: sortColumnIndex,
                      onSort: onSort,
                      onRefresh: getItems,
                      type: 'store'
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              // Inventory Button Section
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => sendToInventory(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'Create Inventory',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
