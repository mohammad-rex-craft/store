import 'package:flutter/material.dart';
import '../utility/hooks.dart';
import '../widget/common/table_storage.dart';
import '../widget/screens/storage/form_create_items.dart';
import '../widget/screens/storage/form_update_items.dart';
import '../widget/common/bar.dart';
import '../database/database.dart';
import '../l10n/app_localizations.dart';

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
  bool isLoading = true;
  bool sortAscending = true;
  int? sortColumnIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
  }

  Future<void> loadInitialData() async {
    setState(() => isLoading = true);
    await Future.wait([getItems(), getItems2()]);
    setState(() => isLoading = false);
  }

  Future<void> getItems() async {
    final l10n = AppLocalizations.of(context);
    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: l10n?.networkError ?? "Network error occurred while fetching items",
      );
      // Sort data by ID in ascending order
      List<Map<String, dynamic>> sortedData = List<Map<String, dynamic>>.from(
        response,
      );
      sortedData.sort((a, b) {
        int idA = a['id'] ?? 0;
        int idB = b['id'] ?? 0;
        return idA.compareTo(idB);
      });

      setState(() {
        data = sortedData;
      });
        } catch (e) {}
  }

  Future<void> getItems2() async {
    final l10n = AppLocalizations.of(context);
    try {
      final response = await db.readAll(
        table: 'inputs',
        context: context,
        errorMessage: l10n?.networkError ?? "Network error occurred while fetching inputs",
      );
      // Sort data by ID in ascending order
      List<Map<String, dynamic>> sortedData = List<Map<String, dynamic>>.from(
        response,
      );
      sortedData.sort((a, b) {
        int idA = a['id'] ?? 0;
        int idB = b['id'] ?? 0;
        return idA.compareTo(idB);
      });

      setState(() {
        indata = sortedData;
      });
        } catch (e) {}
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

  void sendToInventory(context) async {
    final l10n = AppLocalizations.of(context);
    await db.create(
      table: 'inventory',
      data: {'data': data, 'date': DateTime.now().toString()},
      context: context,
      successMessage: l10n?.inventoryCreatedSuccessfully ?? "Inventory created successfully",
      errorMessage: l10n?.errorCreatingInventory ?? "Error creating inventory",
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: Bar(title: l10n?.store ?? 'Store', color: Colors.purple),
      backgroundColor: const Color(0xFFF5F5F5),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primeColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primeColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.table_chart, color: primeColor, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            l10n?.store ?? 'Store',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primeColor,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: primeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${data.length} ${l10n?.item ?? 'item'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: TableStorage(
                      data: data,
                      sortAscending: sortAscending,
                      sortColumnIndex: sortColumnIndex,
                      onSort: onSort,
                      onRefresh: getItems,
                      type: 'store',
                    ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.manage_accounts,
                          color: Colors.grey.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n?.editItems ?? 'Edit Items',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: FormCreateItems(
                      onItemCreated: () {
                        getItems();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
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

              const SizedBox(height: 30),

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
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => sendToInventory(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.inventory,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                l10n?.createInventory ?? 'Create Inventory',
                                style: const TextStyle(
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
