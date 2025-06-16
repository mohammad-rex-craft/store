import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../hooks.dart';
import '../../database/database.dart';

class LogInOut { 
  final DatabaseService _db = DatabaseService();

  Future<void> signOut(BuildContext context) async {
    await _db.signOut();
    replaceRouter(context, '/login');
  }

  Future<void> signUp(BuildContext context, String email, String password) async {
    final supabase = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if(supabase.user != null){
      replaceRouter(context, '/');
    }else{
      showDialog(context: context, builder: (context)=>AlertDialog(
        title: const Text('Error'),
        content: const Text('Invalid email or password'),
      ));
    }
  }
}