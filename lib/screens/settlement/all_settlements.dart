import 'package:flutter/material.dart';
import 'package:storeflow/widget/common/search_sort_bar.dart';
import '../../../widget/common/bar.dart';
import '../../../database/database.dart';
import '../../../widget/common/pagination_btn.dart';
import '../../../utility/theme.dart';
import '../../../widget/screens/settlement/card_settlement.dart';

const Color settlementColor = Colors.brown;

class AllSettlements extends StatefulWidget {
  const AllSettlements({super.key});

  @override
  AllSettlementsState createState() => AllSettlementsState();
}

class AllSettlementsState extends State<AllSettlements> {
  List<Map<String, dynamic>> allSettlements = [];
  List<Map<String, dynamic>> filteredSettlements = [];
  final DatabaseService db = DatabaseService();
  final TextEditingController searchController = TextEditingController();
  bool isSortedAscending = false;

  int currentPage = 0;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    getSettlements();
  }

  Future<void> getSettlements() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await db.getPaginated(
        table: 'inventory_settlements',
        page: currentPage,
        pageSize: pageSize,
        orderBy: 'date',
        ascending: isSortedAscending,
        context: context,
        errorMessage: "Network error occurred while fetching settlements",
      );

      setState(() {
        allSettlements = List<Map<String, dynamic>>.from(response);
        filteredSettlements = List.from(allSettlements);
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
      getSettlements();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      getSettlements();
    }
  }

  void sortDataByDate() {
    setState(() {
      isSortedAscending = !isSortedAscending;
      currentPage = 0;
      getSettlements();
    });
  }

  void filterData(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredSettlements = List.from(allSettlements);
      });
      return;
    }

    try {
      final results = await db.search(
        table: 'inventory_settlements',
        column: 'date',
        query: query,
        context: context,
        errorMessage: "Error searching by date",
      );
      final noaResults = await db.search(
        table: 'inventory_settlements',
        column: 'noa',
        query: query,
        context: context,
        errorMessage: "Error searching by invoice number",
      );
      
      final combinedResults = [
        ...results,
        ...noaResults,
      ];
      final uniqueResults = combinedResults.toSet().toList();
      setState(() {
        filteredSettlements = uniqueResults;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const Bar(title: 'All Settlements', color: settlementColor),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  settlementColor.withOpacity(0.1),
                  settlementColor.withOpacity(0.05),
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
                    color: settlementColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
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
                        'All Settlements',
                        style: AppTheme.titleStyle.copyWith(
                          color: settlementColor,
                        ),
                      ),
                      Text(
                        '${filteredSettlements.length} records • Page ${currentPage + 1}',
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
                  : filteredSettlements.isEmpty
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(settlementColor),
          ),
          SizedBox(height: 16),
          Text('Loading settlements...', style: AppTheme.bodyStyle),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_empty, color: AppTheme.textHint, size: 64),
          const SizedBox(height: 16),
          Text(
            'No settlements found.',
            style: AppTheme.headingStyle.copyWith(color: AppTheme.textHint),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new settlement to see it here.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyStyle.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          currentPage = 0;
        });
        await getSettlements();
      },
      child: ListView.builder(
        itemCount: filteredSettlements.length,
        itemBuilder: (context, index) {
          final item = filteredSettlements[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: CardSettlement(
              item: item,
              onRefresh: () {
                getSettlements();
              },
            ),
          );
        },
      ),
    );
  }
}
