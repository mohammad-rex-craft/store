import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utility/hooks.dart';
import '../../database/database.dart';

class LogInOut { 
  final DatabaseService _db = DatabaseService();

  Future<void> signOut(BuildContext context) async {
    try {
      // تسجيل الخروج من Supabase
      await _db.signOut();
      
      // التأكد من أن السياق لا يزال صالحاً
      if (context.mounted) {
        // توجيه المستخدم إلى صفحة تسجيل الدخول
        replaceRouter(context, '/login');
      }
    } catch (e) {
      // في حالة حدوث خطأ، توجيه المستخدم إلى صفحة تسجيل الدخول على أي حال
      if (context.mounted) {
        replaceRouter(context, '/login');
      }
    }
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
          content: Text('Login failed: ${e.toString()}'),
        ));
      }
    }
  }
}