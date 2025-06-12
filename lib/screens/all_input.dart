import 'package:flutter/material.dart';
import '../widget/common/bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../database/database.dart';
import '../widget/screens/all_input/card_inputs.dart';
import '../widget/screens/all_input/pagination_btn.dart';
import '../widget/screens/all_input/search_sort_bar.dart';

class AllInput extends StatefulWidget {
  const AllInput({super.key});

  @override
  AllInputState createState() => AllInputState();
}

class AllInputState extends State<AllInput> {
  List<Map<String, dynamic>> allInputs = [];
  List<Map<String, dynamic>> filteredInputs = [];
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
    getInputs();
  }

  Future<void> getInputs() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await db.getPaginated(
        table: 'inputs',
        page: currentPage,
        pageSize: pageSize,
        orderBy: 'date',
        ascending: isSortedAscending,
      );

      if (response != null) {
        setState(() {
          allInputs = List<Map<String, dynamic>>.from(response);
          filteredInputs = List.from(allInputs);
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
      getInputs();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      getInputs();
    }
  }

  void sortDataByDate() {
    setState(() {
      isSortedAscending = !isSortedAscending;
      currentPage = 0;
      getInputs();
    });
  }

  void filterData(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredInputs = List.from(allInputs);
      });
      return;
    }

    try {
      final results = await db.search(
        table: 'inputs',
        column: 'date',
        query: query,
      );

      final noaResults = await db.search(
        table: 'inputs',
        column: 'noa',
        query: query,
      );

      // Combine and remove duplicates
      final combinedResults = [...results, ...noaResults];
      final uniqueResults = combinedResults.toSet().toList();

      setState(() {
        filteredInputs = uniqueResults;
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
      appBar: Bar(title: 'All Input'),
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
                    itemCount: filteredInputs.length,
                    itemBuilder: (context, index) {
                      final item = filteredInputs[index];
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
