import 'package:flutter/material.dart';
import '../../widget/common/bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../database/database.dart';
import '../../widget/screens/all_output/card_output.dart';
import '../../widget/common/pagination_btn.dart';
import '../../widget/common/search_sort_bar.dart';

class AllOutput extends StatefulWidget {
  const AllOutput({super.key});

  @override
  AllOutputState createState() => AllOutputState();
}

class AllOutputState extends State<AllOutput> {
  List<Map<String, dynamic>> allOutputs = [];
  List<Map<String, dynamic>> filteredOutputs = [];
  final DatabaseService db = DatabaseService();
  final TextEditingController searchController = TextEditingController();
  bool isSortedAscending = true;
  List<Map<String, dynamic>> store = [];
  // Pagination variables
  int currentPage = 0;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    getOutputs();
    getStore();
  }

  Future<void> getStore() async {
    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      if (response != null) {
        setState(() {
          store = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  Future<void> getOutputs() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await db.getPaginated(
        table: 'orders',
        page: currentPage,
        pageSize: pageSize,
        orderBy: 'date',
        ascending: isSortedAscending,
        context: context,
        errorMessage: "Network error occurred while fetching outputs",
      );

      if (response != null) {
        setState(() {
          allOutputs = List<Map<String, dynamic>>.from(response);
          filteredOutputs = List.from(allOutputs);
          hasMoreData = response.length == pageSize;
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

  void nextPage() {
    if (hasMoreData) {
      setState(() {
        currentPage++;
      });
      getOutputs();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      getOutputs();
    }
  }

  void sortDataByDate() {
    setState(() {
      isSortedAscending = !isSortedAscending;
      currentPage = 0;
      getOutputs();
    });
  }

  void filterData(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredOutputs = List.from(allOutputs);
      });
      return;
    }

    try {
      final results = await db.search(
        table: 'orders',
        column: 'date',
        query: query,
        context: context,
        errorMessage: "Error searching by date",
      );

      final noaResults = await db.search(
        table: 'orders',
        column: 'noa',
        query: query,
        context: context,
        errorMessage: "Error searching by invoice number",
      );

      final clientResults = await db.search(
        table: 'orders',
        column: 'client',
        query: query,
        context: context,
        errorMessage: "Error searching by client",
      );

      final senderResults = await db.search(
        table: 'orders',
        column: 'sender',
        query: query,
        context: context,
        errorMessage: "Error searching by sender",
      );

      final combinedResults = [
        ...results,
        ...noaResults,
        ...clientResults,
        ...senderResults,
      ];
      final uniqueResults = combinedResults.toSet().toList();

      setState(() {
        filteredOutputs = uniqueResults;
      });
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'All Output',color: Colors.red),
      body: Column(
        children: [
          SearchSortBar(
            searchController: searchController,
            filterData: filterData,
            sortDataByDate: sortDataByDate,
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredOutputs.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOutputs.length,
                    itemBuilder: (context, index) {
                      final item = filteredOutputs[index];
                      return CardOutput(
                        item: item,
                        store: store,
                        onRefresh: getOutputs,
                      );
                    },
                  ),
          ),
          // Pagination buttons
          PaginationBtn(
            currentPage: currentPage,
            hasMoreData: hasMoreData,
            previousPage: previousPage,
            nextPage: nextPage,
          ),
        ],
      ),
    );
  }
}
