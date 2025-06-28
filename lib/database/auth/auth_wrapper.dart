import 'package:flutter/material.dart';
import '../database.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  final DatabaseService _db = DatabaseService();

  AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    try {
      _db.checkAuth();
      return child;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
} 
