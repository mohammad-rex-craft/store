import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final user = Supabase.instance.client.auth.currentUser;

  // Show alert dialog
  void showAlert(
    BuildContext context, {
    required String title,
    required String message,
    AlertType type = AlertType.error,
  }) {
    Alert(
      context: context,
      type: type,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  // Get the current user
  Future<User?> getCurrentUser() async {
    return await _supabase.auth.currentUser;
  }

  void checkAuth() {
    if (user == null) throw Exception('no auth');
  }

  // Create a new record
  Future<Map<String, dynamic>> create({
    required String table,
    required Map<String, dynamic> data,
    required BuildContext context,
    String? successMessage,
    String? errorMessage,
  }) async {
    print(user!.id);
    try {
      final response = await _supabase
          .from(table)
          .insert({...data, 'warehouse_id': user!.id})
          .select()
          .single();

      if (successMessage != null) {
        showAlert(
          context,
          title: "Success",
          message: successMessage,
          type: AlertType.success,
        );
      }

      return response;
    } catch (e) {
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error creating record: $e');
    }
  }

  // Read a single record by ID
  Future<Map<String, dynamic>> read({
    required String table,
    required String id,
    required BuildContext context,
    String? errorMessage,
  }) async {
    try {
      final response = await _supabase
          .from(table)
          .select('*')
          .eq('id', id)
          .eq('warehouse_id', user!.id)
          .single();
      return response;
    } catch (e) {
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error reading record: $e');
    }
  }

  Future<Map<String, dynamic>> readAllOnItem({
    required String table,
    required String id,
    required BuildContext context,
    String? errorMessage,
  }) async {
    try {
      final response = await _supabase
          .from(table)
          .select()
          .contains('items_ids', [id])
          .eq('warehouse_id', user!.id)
          .single();
      return response;
    } catch (e) {
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error reading record: $e');
    }
  }

  // Read all records with optional filters
  Future<List<Map<String, dynamic>>> readAll({
    required String table,
    Map<String, dynamic>? filters,
    required BuildContext context,
    String? errorMessage,
  }) async {
    try {
      var query = _supabase.from(table).select().eq('warehouse_id', user!.id);

      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error reading records: $e');
    }
  }

  // Update a record
  Future<Map<String, dynamic>> update({
    required String table,
    required int id,
    required Map<String, dynamic> data,
    required BuildContext context,
    String? successMessage,
    String? errorMessage,
  }) async {
    try {
      final response = await _supabase
          .from(table)
          .update(data)
          .eq('id', id)
          .eq('warehouse_id', user!.id)
          .select()
          .single();

      if (successMessage != null) {
        showAlert(
          context,
          title: "Success",
          message: successMessage,
          type: AlertType.success,
        );
      }

      return response;
    } catch (e) {
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error updating record: $e');
    }
  }

  // Delete a record
  Future<void> delete({
    required String table,
    required int id,
    required BuildContext context,
    String? successMessage,
    String? errorMessage,
  }) async {
    try {
      await _supabase
          .from(table)
          .delete()
          .eq('id', id)
          .eq('warehouse_id', user!.id);

      if (successMessage != null) {
        showAlert(
          context,
          title: "Success",
          message: successMessage,
          type: AlertType.success,
        );
      }
    } catch (e) {
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error deleting record: $e');
    }
  }

  // Search records
  Future<List<Map<String, dynamic>>> search({
    required String table,
    required String column,
    required String query,
    required BuildContext context,
    String? errorMessage,
  }) async {
    try {
      final response = await _supabase
          .from(table)
          .select('*')
          .ilike(column, '%$query%')
          .eq('warehouse_id', user!.id)
          .order(column, ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error searching records: $e');
    }
  }

Future<Map<String, dynamic>> rpc(
    String functionName, {
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    try {
      // أضف معرف المستودع تلقائيًا إلى المعلمات
      // للمحافظة على التناسق مع باقي الدوال في هذه الخدمة
      final fullParams = {
        ...params,
        'p_warehouse_id': user!.id,
      };

      // تحويل المعلمات بشكل صحيح
      final convertedParams = fullParams.map((key, value) {
        if (value is List || value is Map) {
          return MapEntry(key, jsonEncode(value));
        }
        return MapEntry(key, value);
      });

      print('Calling RPC $functionName with params: $convertedParams');

      // استدعاء الدالة بدون .eq، حيث أن الفلترة تتم داخل الدالة نفسها
      final response = await _supabase.rpc(
        functionName,
        params: convertedParams,
      );

      // تحويل الاستجابة إلى Map
      final responseData = response is Map
          ? Map<String, dynamic>.from(response)
          : <String, dynamic>{};

      print('RPC Response: $responseData');
      return responseData;
    } catch (e) {
      print('RPC Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return {'error': e.toString()};
    }
  }

  // Get records with pagination
  Future<List<Map<String, dynamic>>> getPaginated({
    required String table,
    required int page,
    required int pageSize,
    String? orderBy,
    bool ascending = true,
    required BuildContext context,
    String? errorMessage,
  }) async {
    try {
      var query = _supabase
          .from(table)
          .select()
          .eq('warehouse_id', user!.id)
          .range(page * pageSize, (page + 1) * pageSize - 1);

      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error getting paginated records: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllByItemPaginated({
    required String table,
    required int page,
    required int pageSize,
    required int id,
    String? orderBy,
    bool ascending = true,
    required BuildContext context,
    String? errorMessage,
  }) async {
    try {
      var query = _supabase
          .from(table)
          .select()
          .contains('items_ids', id)
          .eq('warehouse_id', user!.id)
          .range(page * pageSize, (page + 1) * pageSize - 1);

      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (errorMessage != null) {
        print(e.toString());
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error getting paginated records: $e');
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  // Test method to check database data
  Future<void> testDatabaseData(BuildContext context) async {
    try {
      print('=== Testing Database Data ===');
      print('Current user ID: ${user!.id}');
      
      // Check orders
      final ordersResponse = await readAll(
        table: 'orders',
        context: context,
        errorMessage: "Error loading orders",
      );
      print('Orders count: ${ordersResponse?.length ?? 0}');
      
      if (ordersResponse != null && ordersResponse.isNotEmpty) {
        print('First order: ${ordersResponse.first}');
        
        // Test direct SQL query
        print('=== Testing Direct SQL ===');
        final testQuery = await _supabase
            .from('orders')
            .select('items')
            .eq('warehouse_id', user!.id)
            .limit(1);
        print('Direct query result: $testQuery');
        
        if (testQuery.isNotEmpty) {
          final items = testQuery.first['items'];
          print('Items from first order: $items');
          if (items is List && items.isNotEmpty) {
            print('First item: ${items.first}');
            print('Item name: ${items.first['item']}');
          }
        }
      }
      
      // Check store items
      final storeResponse = await readAll(
        table: 'store',
        context: context,
        errorMessage: "Error loading store",
      );
      print('Store items count: ${storeResponse?.length ?? 0}');
      
      if (storeResponse != null && storeResponse.isNotEmpty) {
        print('First store item: ${storeResponse.first}');
      }
      
      print('=== End Test ===');
    } catch (e) {
      print('Test error: $e');
    }
  }

  // Get top ordered items with optimized SQL
  Future<List<Map<String, dynamic>>> getTopOrderedItems({
    required BuildContext context,
    int limit = 6,
    String? errorMessage,
  }) async {
    try {
      print('Calling get_top_ordered_items with warehouse_id: ${user!.id}, limit: $limit');
      
      // Call RPC function directly to avoid parameter conflicts
      final response = await _supabase.rpc(
        'get_top_ordered_items',
        params: {
          'p_warehouse_id': user!.id,
          'p_limit': limit,
        },
      );

      print('RPC Response: $response');

      if (response == null) {
        throw Exception('No response from RPC function');
      }

      // Parse the response
      List<Map<String, dynamic>> items = [];
      if (response is Map<String, dynamic>) {
        if (response.containsKey('error')) {
          throw Exception(response['error']);
        }
        
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List) {
            items = data.map((item) => Map<String, dynamic>.from(item)).toList();
          }
        }
      }

      print('Parsed items: $items');
      return items;
    } catch (e) {
      print('RPC failed, falling back to frontend processing: $e');
      
      // Fallback to frontend processing if RPC fails
      try {
        return await _getTopOrderedItemsFallback(context, limit);
      } catch (fallbackError) {
        print('Fallback also failed: $fallbackError');
        if (errorMessage != null) {
          showAlert(context, title: "Error", message: errorMessage);
        }
        throw Exception('Error getting top ordered items: $fallbackError');
      }
    }
  }

  // Fallback method using frontend processing
  Future<List<Map<String, dynamic>>> _getTopOrderedItemsFallback(
    BuildContext context,
    int limit,
  ) async {
    print('Starting fallback method with warehouse_id: ${user!.id}');
    
    // Get all orders
    final ordersResponse = await readAll(
      table: 'orders',
      context: context,
      errorMessage: "Error loading orders",
    );

    print('Orders response: $ordersResponse');

    if (ordersResponse == null || ordersResponse.isEmpty) {
      print('No orders found in database');
      return [];
    }

    final orders = List<Map<String, dynamic>>.from(ordersResponse);
    print('Found ${orders.length} orders');
    
    // Get store items for current quantities
    final storeResponse = await readAll(
      table: 'store',
      context: context,
      errorMessage: "Error loading store",
    );

    Map<String, int> currentQuantities = {};
    if (storeResponse != null) {
      for (var item in storeResponse) {
        currentQuantities[item['item']] = item['qtn'] ?? 0;
      }
    }
    
    // Count item frequencies
    Map<String, int> itemFrequency = {};
    
    for (var order in orders) {
      print('Processing order: ${order['id']}');
      print('Order items: ${order['items']}');
      
      List<dynamic> items = order['items'] ?? [];
      print('Items array length: ${items.length}');
      
      for (var item in items) {
        print('Processing item: $item');
        String itemName = item['item'] ?? '';
        print('Item name: $itemName');
        
        if (itemName.isNotEmpty) {
          itemFrequency[itemName] = (itemFrequency[itemName] ?? 0) + 1;
        }
      }
    }

    print('Item frequency map: $itemFrequency');

    // Sort by frequency and get top items
    List<MapEntry<String, int>> sortedItems = itemFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    print('Sorted items: $sortedItems');

    // Create top items list
    List<Map<String, dynamic>> topItemsList = [];
    for (int i = 0; i < limit && i < sortedItems.length; i++) {
      String itemName = sortedItems[i].key;
      int frequency = sortedItems[i].value;
      int currentQty = currentQuantities[itemName] ?? 0;
      
      topItemsList.add({
        'name': itemName,
        'frequency': frequency,
        'totalOrdered': frequency,
        'currentQty': currentQty,
      });
    }

    print('Final top items list: $topItemsList');
    return topItemsList;
  }
}
