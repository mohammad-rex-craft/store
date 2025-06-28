import 'package:flutter/material.dart';
import '../../widget/common/bar.dart';
import '../../database/database.dart';
import '../../widget/screens/all_output/card_output.dart';
import '../../widget/common/pagination_btn.dart';
import '../../widget/common/search_sort_bar.dart';
import '../../utility/theme.dart';

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
      setState(() {
        store = List<Map<String, dynamic>>.from(response);
      });
        } catch (e) {
      
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

      setState(() {
        allOutputs = List<Map<String, dynamic>>.from(response);
        filteredOutputs = List.from(allOutputs);
        hasMoreData = response.length == pageSize;
        isLoading = false;
      });
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: const Bar(title: 'All Output', color: AppTheme.colorWarning),
      body: Column(
        children: [
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.colorWarning.withOpacity(0.1),
                  AppTheme.colorWarning.withOpacity(0.05),
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
                    color: AppTheme.colorWarning,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.output,
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
                        'All Outputs',
                        style: AppTheme.titleStyle.copyWith(
                          color: AppTheme.colorWarning,
                        ),
                      ),
                      Text(
                        '${filteredOutputs.length} records • Page ${currentPage + 1}',
                        style: AppTheme.captionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          
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
          
          
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? _buildLoadingState()
                  : filteredOutputs.isEmpty
                      ? _buildEmptyState()
                      : _buildContentList(),
            ),
          ),
          
          
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
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorWarning),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading outputs...',
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
              color: AppTheme.colorWarning.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppTheme.colorWarning,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No outputs found',
            style: AppTheme.titleStyle.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
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
      itemCount: filteredOutputs.length,
      itemBuilder: (context, index) {
        final item = filteredOutputs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: CardOutput(
            item: item,
            store: store,
            onRefresh: getOutputs,
          ),
        );
      },
    );
  }
}
