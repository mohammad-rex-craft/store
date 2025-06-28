import 'package:flutter/material.dart';
import '../../../database/database.dart';
import '../../../widget/common/bar.dart';
import '../../../widget/common/search_sort_bar.dart';
import '../../../widget/common/pagination_btn.dart';
import '../../../widget/screens/settlement/card_settlement.dart';

class AllSettlementById extends StatefulWidget {
  const AllSettlementById({super.key});

  @override
  AllSettlementByIdState createState() => AllSettlementByIdState();
}

class AllSettlementByIdState extends State<AllSettlementById> {
  late Map<String, dynamic> routeArgs;
  List<Map<String, dynamic>> allSettlements = [];
  List<Map<String, dynamic>> filteredSettlements = [];
  final DatabaseService db = DatabaseService();
  final TextEditingController searchController = TextEditingController();
  bool isSortedAscending = true;
  bool _isInitialized = false;
  
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
      _fetchAllSettlements();
      _isInitialized = true;
    }
  }

  void _updateDisplayedList() {
    List<Map<String, dynamic>> temp = List.from(allSettlements);
    final query = searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      temp = temp.where((item) {
        final date = (item['date'] ?? '').toLowerCase();
        final reason = (item['reason'] ?? '').toLowerCase();
        final noa = (item['noa']?.toString() ?? '').toLowerCase();
        return date.contains(query) ||
            reason.contains(query) ||
            noa.contains(query);
      }).toList();
    }

    temp.sort((a, b) {
      final dateA = a['date'] ?? '';
      final dateB = b['date'] ?? '';
      return isSortedAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    final startIndex = currentPage * pageSize;
    final endIndex = (startIndex + pageSize > temp.length) ? temp.length : startIndex + pageSize;

    setState(() {
      filteredSettlements = temp.sublist(startIndex, endIndex);
      hasMoreData = endIndex < temp.length;
    });
  }

  Future<void> _fetchAllSettlements() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> tempSettlements = [];
      int page = 0;
      bool hasMore = true;
      while (hasMore) {
        final response = await db.getAllByItemPaginated(
          table: 'inventory_settlements',
          id: routeArgs['id'],
          page: page,
          pageSize: 50,
          orderBy: 'date',
          ascending: isSortedAscending,
          context: context,
          errorMessage: "Network error occurred while fetching settlements",
        );
        tempSettlements.addAll(response);
        hasMore = response.length == 50;
        page++;
      }
      
      setState(() {
        allSettlements = tempSettlements;
        isLoading = false;
        _updateDisplayedList();
      });

    } catch (e, s) {
      print('Error in getSettlements: $e\n$s');
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
      _updateDisplayedList();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _updateDisplayedList();
    }
  }

  void sortDataByDate() {
    setState(() {
      isSortedAscending = !isSortedAscending;
      currentPage = 0; 
    });
    _updateDisplayedList();
  }

  void filterData(String query) {
    setState(() {
      currentPage = 0;
    });
    _updateDisplayedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'Settlements: ${routeArgs['item']}', color: Colors.purple),
      body: Column(
        children: [
          SearchSortBar(
            searchController: searchController,
            filterData: filterData,
            sortDataByDate: sortDataByDate,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredSettlements.isEmpty
                    ? const Center(
                        child: Text(
                          'No settlements found for this item.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredSettlements.length,
                        itemBuilder: (context, index) {
                          final item = filteredSettlements[index];
                          return CardSettlement(
                            item: item,
                            onRefresh: _fetchAllSettlements,
                          );
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