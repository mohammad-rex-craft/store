import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:storeflow/database/database.dart';
import 'package:intl/intl.dart';
import '../../../screens/client/widgets/date_range_selector.dart';
import '../../../screens/client/widgets/loading_widget.dart';
import '../../../screens/client/widgets/no_data_widget.dart';
import '../../../screens/client/widgets/chart_widget.dart';

class ChartClient extends StatefulWidget {
  const ChartClient({Key? key}) : super(key: key);

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
  
  // Date range selection
  DateTime startDate = DateTime(DateTime.now().year, 1, 1); // First day of current year
  DateTime endDate = DateTime.now();
  
  // For date formatting
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat displayFormat = DateFormat('MMM d, y');
  final DateFormat monthFormat = DateFormat('MMM y'); // For X-axis labels

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      _loadData();
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
          return orderDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
                 orderDate.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();

        // Calculate monthly order counts
        Map<String, int> monthlyOrderCounts = {};
        
        for (var order in allOrders) {
          final orderDate = DateTime.parse(order['date'] ?? '');
          final monthKey = '${orderDate.year}-${orderDate.month.toString().padLeft(2, '0')}';
          monthlyOrderCounts[monthKey] = (monthlyOrderCounts[monthKey] ?? 0) + 1;
        }

        // Sort months and create spots
        spots = [];
        monthLabels = {};
        var sortedMonths = monthlyOrderCounts.keys.toList()..sort();
        
        for (int i = 0; i < sortedMonths.length; i++) {
          final monthKey = sortedMonths[i];
          final parts = monthKey.split('-');
          final date = DateTime(int.parse(parts[0]), int.parse(parts[1]));
          
          spots.add(FlSpot(i.toDouble(), monthlyOrderCounts[monthKey]!.toDouble()));
          monthLabels[i.toDouble()] = monthFormat.format(date);
        }

        // Set max Y for the chart
        maxY = spots.isEmpty ? 0 : spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تدرج سحب الزبون'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
      ),
      body: Column(
        children: [
          DateRangeSelector(
            startDate: startDate,
            endDate: endDate,
            onSelectDate: _selectDate,
            displayFormat: displayFormat,
          ),
          Container(
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
        ],
      ),
    );
  }
}