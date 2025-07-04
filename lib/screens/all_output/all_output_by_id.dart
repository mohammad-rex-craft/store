import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../../widget/common/bar.dart';
import '../../widget/common/search_sort_bar.dart';
import '../../widget/screens/all_output/card_output.dart';
import '../../widget/common/pagination_btn.dart';
import '../../l10n/app_localizations.dart';

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
  bool isLoading = true;
  bool hasMoreData = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadInitialData();
      });
      _isInitialized = true;
    }
  }

  Future<void> loadInitialData() async {
    setState(() => isLoading = true);
    await Future.wait([_fetchAllOutputs(), getStore()]);
    setState(() => isLoading = false);
  }

  Future<void> getStore() async {
    final l10n = AppLocalizations.of(context);

    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage:
            l10n?.networkError ?? "Network error occurred while fetching items",
      );
      setState(() {
        store = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {}
  }

  void _updateDisplayedList() {
    List<Map<String, dynamic>> temp = List.from(allOutputs);
    final query = searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      temp = temp.where((item) {
        final date = (item['date'] ?? '').toLowerCase();
        final noa = (item['noa']?.toString() ?? '').toLowerCase();
        final client = (item['client'] ?? '').toLowerCase();
        final sender = (item['sender'] ?? '').toLowerCase();
        return date.contains(query) ||
            noa.contains(query) ||
            client.contains(query) ||
            sender.contains(query);
      }).toList();
    }

    temp.sort((a, b) {
      final dateA = a['date'] ?? '';
      final dateB = b['date'] ?? '';
      return isSortedAscending
          ? dateA.compareTo(dateB)
          : dateB.compareTo(dateA);
    });

    final startIndex = currentPage * pageSize;
    final endIndex = (startIndex + pageSize > temp.length)
        ? temp.length
        : startIndex + pageSize;

    setState(() {
      filteredOutputs = temp.sublist(startIndex, endIndex);
      hasMoreData = endIndex < temp.length;
    });
  }

  Future<void> _fetchAllOutputs() async {
    final l10n = AppLocalizations.of(context);
    try {
      // Fetch all data using looped pagination
      List<Map<String, dynamic>> tempOutputs = [];
      int page = 0;
      bool hasMore = true;
      while (hasMore) {
        final response = await db.getAllByItemPaginated(
          table: 'orders',
          id: routeArgs['id'],
          page: page,
          pageSize: 50, // A larger page size to fetch all faster
          orderBy: 'date',
          ascending: isSortedAscending,
          context: context,
          errorMessage:
              l10n?.networkError ??
              "Network error occurred while fetching transactions",
        );
        tempOutputs.addAll(response);
        hasMore = response.length == 50;
        page++;
      }

      setState(() {
        allOutputs = tempOutputs;
        _updateDisplayedList(); // Initial display
      });
    } catch (e, s) {
      //
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: Bar(title: '${l10n?.outputs ?? "Output"} {${routeArgs['item']}}', color: Colors.orange),
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
                : filteredOutputs.isEmpty
                ?  Center(
                    child: Text(
                      l10n?.noOutputsFound ?? 'No data available',
                      style:const TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOutputs.length,
                    itemBuilder: (context, index) {
                      final item = filteredOutputs[index];
                      return CardOutput(
                        item: item,
                        store: store,
                        onRefresh: _fetchAllOutputs,
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
