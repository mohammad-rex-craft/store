import 'package:flutter/material.dart';
import '../widget/common/bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../database/database.dart';
import '../widget/screens/all_output/card_output.dart';
import '../widget/common/pagination_btn.dart';
import '../widget/common/search_sort_bar.dart';

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

  // Pagination variables
  int currentPage = 0;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    getOutputs();
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
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Network error: ${e.toString()}",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ).show();
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
      );

      final noaResults = await db.search(
        table: 'orders',
        column: 'noa',
        query: query,
      );
      final clientResults = await db.search(
        table: 'orders',
        column: 'client',
        query: query,
      );
      final senderResults = await db.search(
        table: 'orders',
        column: 'sender',
        query: query,
      );

      final combinedResults = [...results, ...noaResults, ...clientResults, ...senderResults];
      final uniqueResults = combinedResults.toSet().toList();

      setState(() {
        filteredOutputs = uniqueResults;
      });
    } catch (e) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Search error: ${e.toString()}",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'All Output'),
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
                : ListView.builder(
                    itemCount: filteredOutputs.length,
                    itemBuilder: (context, index) {
                      final item = filteredOutputs[index];
                      return CardInputs(item: item);
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
