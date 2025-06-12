import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Create a new record
  Future<Map<String, dynamic>> create({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _supabase
          .from(table)
          .insert(data)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Error creating record: $e');
    }
  }

  // Read a single record by ID
  Future<Map<String, dynamic>> read({
    required String table,
    required String id,
  }) async {
    try {
      final response = await _supabase
          .from(table)
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      throw Exception('Error reading record: $e');
    }
  }

  // Read all records with optional filters
  Future<List<Map<String, dynamic>>> readAll({
    required String table,
    Map<String, dynamic>? filters,
  }) async {
    try {
      var query = _supabase.from(table).select();
      
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error reading records: $e');
    }
  }

  // Update a record
  Future<Map<String, dynamic>> update({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _supabase
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Error updating record: $e');
    }
  }

  // Delete a record
  Future<void> delete({
    required String table,
    required String id,
  }) async {
    try {
      await _supabase
          .from(table)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Error deleting record: $e');
    }
  }

  // Search records
  Future<List<Map<String, dynamic>>> search({
    required String table,
    required String column,
    required String query,
  }) async {
    try {
      final response = await _supabase
          .from(table)
          .select()
          .ilike(column, '%$query%');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error searching records: $e');
    }
  }

  // Get records with pagination
  Future<List<Map<String, dynamic>>> getPaginated({
    required String table,
    required int page,
    required int pageSize,
    String? orderBy,
    bool ascending = true,
  }) async {
    try {
      var query = _supabase
          .from(table)
          .select()
          .range(page * pageSize, (page + 1) * pageSize - 1);

      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error getting paginated records: $e');
    }
  }
}
