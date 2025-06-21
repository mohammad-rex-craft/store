import 'package:flutter/material.dart';
import '../../widget/common/bar.dart';
import '../../database/database.dart';
import '../../widget/screens/all_input/card_inputs.dart';
import '../../widget/common/pagination_btn.dart';
import '../../widget/common/search_sort_bar.dart';
import '../../utility/theme.dart';

class AllInput extends StatefulWidget {
  const AllInput({super.key});

  @override
  AllInputState createState() => AllInputState();
}

class AllInputState extends State<AllInput> {
  List<Map<String, dynamic>> allInputs = [];
  List<Map<String, dynamic>> store = [];
  List<Map<String, dynamic>> filteredInputs = [];
  final DatabaseService db = DatabaseService();
  final TextEditingController searchController = TextEditingController();
  bool isSortedAscending = true;

  int currentPage = 0;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    getStore();
    getInputs();
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
      final combinedResults = [...results, ...noaResults];
      final uniqueResults = combinedResults.toSet().toList();

      setState(() {
        filteredInputs = uniqueResults;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: Bar(title: 'All Input', color: AppTheme.colorMain),
      body: Column(
        children: [
          // Header Section - Compact
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.colorMain.withOpacity(0.1),
                  AppTheme.colorMain.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.colorMain,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.input,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Inputs',
                        style: AppTheme.titleStyle.copyWith(
                          color: AppTheme.colorMain,
                        ),
                      ),
                      Text(
                        '${filteredInputs.length} records • Page ${currentPage + 1}',
                        style: AppTheme.captionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Search and Sort Section - Compact
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.cardDecoration,
            child: SearchSortBar(
              searchController: searchController,
              filterData: filterData,
              sortDataByDate: sortDataByDate,
            ),
          ),
          
          // Content Section - Maximized
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? _buildLoadingState()
                  : filteredInputs.isEmpty
                      ? _buildEmptyState()
                      : _buildContentList(),
            ),
          ),
          
          // Pagination Section - Compact
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: AppTheme.cardDecoration,
            child: PaginationBtn(
              currentPage: currentPage,
              hasMoreData: hasMoreData,
              previousPage: previousPage,
              nextPage: nextPage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorMain),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading inputs...',
            style: AppTheme.bodyStyle.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.colorMain.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppTheme.colorMain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No inputs found',
            style: AppTheme.titleStyle.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: AppTheme.captionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredInputs.length,
      itemBuilder: (context, index) {
        final item = filteredInputs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: CardInputs(
            item: item,
            store: store,
            onRefresh: getInputs,
          ),
        );
      },
    );
  }
}
