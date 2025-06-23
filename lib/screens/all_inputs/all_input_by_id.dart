import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../../widget/common/bar.dart';
import '../../widget/common/search_sort_bar.dart';
import '../../widget/screens/all_input/card_inputs.dart';
import '../../widget/common/pagination_btn.dart';
import '../../widget/screens/settlement/card_settlement.dart';

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
  List<Map<String, dynamic>> store = [];

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
      routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      _fetchAllInputs();
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

  void _updateDisplayedList() {
    List<Map<String, dynamic>> temp = List.from(allInputs);
    final query = searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      temp = temp.where((item) {
        final date = (item['date'] ?? '').toLowerCase();
        final noa = (item['noa']?.toString() ?? '').toLowerCase();
        return date.contains(query) || noa.contains(query);
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
      filteredInputs = temp.sublist(startIndex, endIndex);
      hasMoreData = endIndex < temp.length;
    });
  }

  Future<void> _fetchAllInputs() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
       List<Map<String, dynamic>> tempInputs = [];
      int page = 0;
      bool hasMore = true;
      while (hasMore) {
        final response = await db.getAllByItemPaginated(
          table: 'inputs',
          id: routeArgs['id'],
          page: page,
          pageSize: 50, 
          orderBy: 'date',
          ascending: isSortedAscending,
          context: context,
          errorMessage: "Network error occurred while fetching transactions",
        );
        tempInputs.addAll(response);
        hasMore = response.length == 50;
        page++;
      }
      
      setState(() {
        allInputs = tempInputs;
        isLoading = false;
        _updateDisplayedList();
      });
    } catch (e, s) {
      print('Error in getInputs: $e\n$s');
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
      appBar: Bar(title: 'Input ${routeArgs['item']}',color: Colors.teal),
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
                : filteredInputs.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredInputs.length,
                    itemBuilder: (context, index) {
                      final item = filteredInputs[index];
                      return CardInputs(item: item, store: store, onRefresh: _fetchAllInputs);
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
