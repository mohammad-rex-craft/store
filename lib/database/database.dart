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
}
