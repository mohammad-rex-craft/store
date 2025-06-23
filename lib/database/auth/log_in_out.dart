import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utility/hooks.dart';
import '../../database/database.dart';

class LogInOut { 
  final DatabaseService _db = DatabaseService();

  Future<void> signOut(BuildContext context) async {
    await _db.signOut();
    replaceRouter(context, '/login');
  }

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      final supabase = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if(supabase.user != null){
        if (context.mounted) {
          replaceRouter(context, '/');
        }
      }else{
        if (context.mounted) {
          showDialog(context: context, builder: (context)=>AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid email or password'),
          ));
        }
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: const Text('Error'),
          content: Text('Login failed: $e'),
        ));
      }
    }
  }
}
