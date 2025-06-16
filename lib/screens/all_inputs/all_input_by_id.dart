import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../../widget/common/bar.dart';
import '../../widget/common/search_sort_bar.dart';
import '../../widget/screens/all_input/card_inputs.dart';
import '../../widget/common/pagination_btn.dart';

class AllInputById extends StatefulWidget {
  const AllInputById({super.key});

  @override
  AllInputByIdState createState() => AllInputByIdState();
}

class AllInputByIdState extends State<AllInputById> {
  late Map<String, dynamic> routeArgs;
  List<Map<String, dynamic>> allInputs = [];
  List<Map<String, dynamic>> filteredInputs = [];
  final DatabaseService db = DatabaseService();
  final TextEditingController searchController = TextEditingController();
  bool isSortedAscending = true;
  bool _isInitialized = false;

  // Pagination variables
  int currentPage = 0;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      getInputs();
      _isInitialized = true;
    }
  }

  Future<void> getInputs() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await db.getAllByItemPaginated(
        table: 'inputs',
        page: currentPage,
        pageSize: pageSize,
        id: routeArgs['id'],
        orderBy: 'date',
        ascending: isSortedAscending,
        context: context,
        errorMessage: "Network error occurred while fetching inputs",
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
      // Error is already handled by DatabaseService
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
        context: context,
        errorMessage: "Error searching by date",
      );

      final noaResults = await db.search(
        table: 'inputs',
        column: 'noa',
        query: query,
        context: context,
        errorMessage: "Error searching by invoice number",
      );

      // Combine and remove duplicates
      final combinedResults = [...results, ...noaResults];
      final uniqueResults = combinedResults.toSet().toList();

      setState(() {
        filteredInputs = uniqueResults;
      });
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'Input ${routeArgs['item']}'),
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
