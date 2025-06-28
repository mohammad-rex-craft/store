import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../utility/theme.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final user = Supabase.instance.client.auth.currentUser;

  
  void showAlert(
    BuildContext context, {
    required String title,
    required String message,
    AlertType type = AlertType.error,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(type == AlertType.success ? Icons.check_circle : Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: type == AlertType.success ? AppTheme.colorSuccess : AppTheme.colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  
  Future<User?> getCurrentUser() async {
    return _supabase.auth.currentUser;
  }

  void checkAuth() {
    if (user == null) throw Exception('no auth');
  }

  
  Future<Map<String, dynamic>> create({
    required String table,
    required Map<String, dynamic> data,
    required BuildContext context,
    String? successMessage,
    String? errorMessage,
  }) async {
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

  
  Future<Map<String, dynamic>> read({
    required String table,
    required String id,
    required BuildContext context,
    String? lableSearch,
    String? errorMessage,
  }) async {
    try {
      final response = lableSearch == null? await _supabase
          .from(table)
          .select('*')
          .eq('id', id)
          .eq('warehouse_id', user!.id)
          .single():
          await _supabase
          .from(table)
          .select('*')
          .eq(lableSearch, id)
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

  Future<void> deleteSettlement({
    required int settlementId,
    required BuildContext context,
    String? successMessage,
    String? errorMessage,
  }) async {
    try {
      await _supabase.rpc(
        'delete_settlement_and_revert_stock',
        params: {'p_settlement_id': settlementId},
      );

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
      throw Exception('Error deleting settlement: $e');
    }
  }

  
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
      final fullParams = {
        ...params,
        'p_warehouse_id': user!.id,
      };

      final convertedParams = fullParams.map((key, value) {
        if (value is List || value is Map) {
          return MapEntry(key, jsonEncode(value));
        }
        return MapEntry(key, value);
      });

      final response = await _supabase.rpc(
        functionName,
        params: convertedParams,
      );

      final responseData = response is Map
          ? Map<String, dynamic>.from(response)
          : <String, dynamic>{};

      return responseData;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Error: ${e.toString()}'),
            ],
          ),
          backgroundColor: AppTheme.colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return {'error': e.toString()};
    }
  }

  
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
    String? lableSearch,
    String? orderBy,
    bool ascending = true,
    required BuildContext context,
    String? errorMessage,
  }) async {
    try {
      var query =lableSearch == null? _supabase
          .from(table)
          .select()
          .contains('items_ids', id)
          .eq('warehouse_id', user!.id)
          .range(page * pageSize, (page + 1) * pageSize - 1):
          _supabase
          .from(table)
          .select()
          .eq(lableSearch??"client_id", id)
          .eq('warehouse_id', user!.id)
          .range(page * pageSize, (page + 1) * pageSize - 1);

      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      print('Supabase Error in getAllByItemPaginated: ${e.toString()}');
      print('Error details: table=$table, id=$id, lableSearch=$lableSearch');
      print('Stack trace: $stackTrace');
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error getting paginated records: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getItemTransactions({
    required int itemId,
    required BuildContext context,
    String? errorMessage,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_item_transactions',
        params: {
          'p_item_id': itemId,
          'p_warehouse_id': user!.id,
        },
      );
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('Supabase Error in getItemTransactions: ${e.toString()}');
      if (errorMessage != null) {
        showAlert(context, title: "Error", message: errorMessage);
      }
      throw Exception('Error getting item transactions: $e');
    }
  }

  
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  
  Future<void> testDatabaseData(BuildContext context) async {
    try {
      print('=== Testing Database Data ===');
      print('Current user ID: ${user!.id}');
      
      
      final ordersResponse = await readAll(
        table: 'orders',
        context: context,
        errorMessage: "Error loading orders",
      );
      print('Orders count: ${ordersResponse.length ?? 0}');
      
      if (ordersResponse.isNotEmpty) {
        print('First order: ${ordersResponse.first}');
        
        
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
      
      
      final storeResponse = await readAll(
        table: 'store',
        context: context,
        errorMessage: "Error loading store",
      );
      print('Store items count: ${storeResponse.length ?? 0}');
      
      if (storeResponse.isNotEmpty) {
        print('First store item: ${storeResponse.first}');
      }
      
      print('=== End Test ===');
    } catch (e) {
      print('Test error: $e');
    }
  }

  
  Future<List<Map<String, dynamic>>> getTopOrderedItems({
    required BuildContext context,
    int limit = 6,
    String? errorMessage,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_top_ordered_items',
        params: {
          'p_warehouse_id': user!.id,
          'p_limit': limit,
        },
      );

      if (response == null) {
        throw Exception('No response from RPC function');
      }

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

      return items;
    } catch (e) {
      try {
        return await _getTopOrderedItemsFallback(context, limit);
      } catch (fallbackError) {
        if (errorMessage != null) {
          showAlert(context, title: "Error", message: errorMessage);
        }
        throw Exception('Error getting top ordered items: $fallbackError');
      }
    }
  }

  
  Future<List<Map<String, dynamic>>> _getTopOrderedItemsFallback(
    BuildContext context,
    int limit,
  ) async {
    final ordersResponse = await readAll(
      table: 'orders',
      context: context,
      errorMessage: "Error loading orders",
    );

    if (ordersResponse.isEmpty) {
      return [];
    }

    final orders = List<Map<String, dynamic>>.from(ordersResponse);
    
    final storeResponse = await readAll(
      table: 'store',
      context: context,
      errorMessage: "Error loading store",
    );

    Map<String, int> currentQuantities = {};
    for (var item in storeResponse) {
      currentQuantities[item['item']] = item['qtn'] ?? 0;
    }
      
    Map<String, int> itemFrequency = {};
    
    for (var order in orders) {
      List<dynamic> items = order['items'] ?? [];
      
      for (var item in items) {
        String itemName = item['item'] ?? '';
        
        if (itemName.isNotEmpty) {
          itemFrequency[itemName] = (itemFrequency[itemName] ?? 0) + 1;
        }
      }
    }

    List<MapEntry<String, int>> sortedItems = itemFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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

    return topItemsList;
  }
}
