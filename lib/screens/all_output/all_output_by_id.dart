import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../../widget/common/bar.dart';
import '../../widget/common/search_sort_bar.dart';
import '../../widget/screens/all_output/card_output.dart';
import '../../widget/common/pagination_btn.dart';

class AllOutputById extends StatefulWidget {
  const AllOutputById({super.key});

  @override
  AllOutputByIdState createState() => AllOutputByIdState();
}

class AllOutputByIdState extends State<AllOutputById> {
  late Map<String, dynamic> routeArgs;
  List<Map<String, dynamic>> allOutputs = [];
  List<Map<String, dynamic>> filteredOutputs = [];
  final DatabaseService db = DatabaseService();
  final TextEditingController searchController = TextEditingController();
  bool isSortedAscending = true;
  bool _isInitialized = false;
  List<Map<String, dynamic>> store = [];
  
  int currentPage = 0;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      getOutputs();
      getStore();
      _isInitialized = true;
    }
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
      
    }
  }

  Future<void> getOutputs() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await db.getAllByItemPaginated(
        table: 'orders',
        page: currentPage,
        pageSize: pageSize,
        id: routeArgs['id'],
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
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'Output ${routeArgs['item']}',color: Colors.orange),
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
                          return CardOutput(item: item,store: store,onRefresh:getOutputs);
                        },
                      ),
          ),
          
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
