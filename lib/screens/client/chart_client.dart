import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:storeflow/database/database.dart';
import 'package:intl/intl.dart';
import '../../widget/screens/chart_client/widgets/date_range_selector.dart';
import '../../widget/screens/chart_client/widgets/loading_widget.dart';
import '../../widget/screens/chart_client/widgets/no_data_widget.dart';
import '../../widget/screens/chart_client/widgets/chart_widget.dart';
import '../../widget/screens/chart_client/widgets/table_item_get.dart';

class ChartClient extends StatefulWidget {
  const ChartClient({super.key});

  @override
  State<ChartClient> createState() => _ChartClientState();
}

class _ChartClientState extends State<ChartClient> {
  late Map<String, dynamic> routeArgs;
  List<FlSpot> spots = [];
  Map<double, String> monthLabels = {};
  double maxY = 0;
  bool isLoading = true;
  final DatabaseService db = DatabaseService();
  List<Map<String, dynamic>> allOrdersByClientId = [];

  // Date range selection
  DateTime startDate = DateTime(
    DateTime.now().year,
    1,
    1,
  ); // First day of current year
  DateTime endDate = DateTime.now();

  // For date formatting
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat displayFormat = DateFormat('MMM d, y');
  final DateFormat monthFormat = DateFormat('MMM y'); // For X-axis labels

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      _loadData();
      getAllOrdersByClientId();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          if (startDate.isAfter(endDate)) {
            endDate = startDate.add(const Duration(days: 1));
          }
        } else {
          endDate = picked;
          if (endDate.isBefore(startDate)) {
            startDate = endDate.subtract(const Duration(days: 1));
          }
        }
        _loadData();
      });
    }
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> allOrders = [];
      int page = 0;
      bool hasMore = true;

      while (hasMore) {
        final orders = await db.getAllByItemPaginated(
          table: "orders",
          id: routeArgs['id'],
          page: page,
          pageSize: 50,
          lableSearch: 'client_id',
          orderBy: 'date',
          ascending: true,
          context: context,
          errorMessage: "Error loading chart data",
        );

        if (orders.isEmpty) {
          hasMore = false;
        } else {
          allOrders.addAll(orders);
          page++;
        }
      }

      if (allOrders.isNotEmpty) {
        // Filter orders by date range
        allOrders = allOrders.where((order) {
          final orderDate = DateTime.tryParse(order['date'] ?? '');
          if (orderDate == null) return false;
          return orderDate.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              orderDate.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();

        // Calculate monthly order counts
        Map<String, int> monthlyOrderCounts = {};

        for (var order in allOrders) {
          final orderDate = DateTime.parse(order['date'] ?? '');
          final monthKey =
              '${orderDate.year}-${orderDate.month.toString().padLeft(2, '0')}';
          monthlyOrderCounts[monthKey] =
              (monthlyOrderCounts[monthKey] ?? 0) + 1;
        }

        // Sort months and create spots
        spots = [];
        monthLabels = {};
        var sortedMonths = monthlyOrderCounts.keys.toList()..sort();

        for (int i = 0; i < sortedMonths.length; i++) {
          final monthKey = sortedMonths[i];
          final parts = monthKey.split('-');
          final date = DateTime(int.parse(parts[0]), int.parse(parts[1]));

          spots.add(
            FlSpot(i.toDouble(), monthlyOrderCounts[monthKey]!.toDouble()),
          );
          monthLabels[i.toDouble()] = monthFormat.format(date);
        }

        // Set max Y for the chart
        maxY = spots.isEmpty
            ? 0
            : spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
      }
    } catch (e) {
      debugPrint('Error loading chart data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> getAllOrdersByClientId() async {
    try {
      final orders = await db.readAll(
        table: 'orders',
        filters: {'client_id': routeArgs['id']},
        context: context,
      );
      setState(() {
        isLoading = false;
        allOrdersByClientId = List<Map<String, dynamic>>.from(orders);
      });
      analyzeItemsData(allOrdersByClientId);
    } catch (e) {
      debugPrint('Error loading table data: $e');
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  List<Map<String, dynamic>> analyzeItemsData(
    List<Map<String, dynamic>> orders,
  ) {
    Map<String, Map<String, dynamic>> itemsSummary = {};

    for (var order in orders) {
      List<dynamic> items = order['items'] ?? [];

      for (var item in items) {
        String itemName = item['item'] ?? '';
        int itemId = item['id'] ?? 0;
        int quantity = item['qtn'] ?? 0;

        if (itemName.isNotEmpty) {
          if (itemsSummary.containsKey(itemName)) {
            itemsSummary[itemName]!['qtn'] =
                (itemsSummary[itemName]!['qtn'] ?? 0) + quantity;
            itemsSummary[itemName]!['order_count'] =
                (itemsSummary[itemName]!['order_count'] ?? 0) + 1;
            // إضافة box إذا لم يكن موجود
            if (!itemsSummary[itemName]!.containsKey('box')) {
              itemsSummary[itemName]!['box'] = 1;
            }
          } else {
            itemsSummary[itemName] = {
              'item_id': itemId,
              'item': itemName,
              'qtn': quantity,
              'order_count': 1,
            };
          }
        }
      }
    }
    List<Map<String, dynamic>> result = itemsSummary.values.toList();
    result.sort((a, b) => (b['qtn'] ?? 0).compareTo(a['qtn'] ?? 0));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Client'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DateRangeSelector(
              startDate: startDate,
              endDate: endDate,
              onSelectDate: _selectDate,
              displayFormat: displayFormat,
            ),
            SizedBox(
              height: 350,
              child: isLoading
                  ? const LoadingWidget()
                  : spots.isEmpty
                  ? const NoDataWidget()
                  : ChartWidget(
                      spots: spots,
                      monthLabels: monthLabels,
                      maxY: maxY,
                    ),
            ),
            Container(
              child: isLoading
                  ? const LoadingWidget()
                  : allOrdersByClientId.isEmpty
                  ? const NoDataWidget()
                  : TableItemGet(orders: allOrdersByClientId),
            ),
          ],
        ),
      ),
    );
  }
}
