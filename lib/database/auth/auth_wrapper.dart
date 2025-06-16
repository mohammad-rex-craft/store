import 'package:flutter/material.dart';
import '../database.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  final DatabaseService _db = DatabaseService();

  AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      _db.checkAuth();
      print('auth ok');
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