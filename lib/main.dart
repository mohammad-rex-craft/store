import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/add_Items.dart';
import './screens/remove_items.dart';
import './screens/all_input.dart';
import './screens/all_output.dart';
import './screens/storage.dart';
import './screens/log_in.dart';

void main()async {
    WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ylaqczgirzddwrtvfcur.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlsYXFjemdpcnpkZHdydHZmY3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk1NzYxMTAsImV4cCI6MjA2NTE1MjExMH0.4JOfZle_j76TxX18JIvMeACDeqCZtsdwLWnb8eXKLGQ',
  );
  runApp(TestApp());
}

var colorText = Color.fromARGB(255, 1, 54, 103);
var colorMain = Color.fromARGB(255, 31, 185, 185);
var colorLowOpicety = Color.fromARGB(103, 1, 54, 103);

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        "/": (ctx) => LogIn(),
        '/home': (ctx) => HomeScreen(),
        '/add_items': (ctx) => AddItems(),
        '/remove_items': (ctx) => RemoveItems(),
        '/all_input': (ctx) => AllInput(),
        '/all_output': (ctx) => AllOutput(),
        '/storage': (ctx) => Storage(),
      },
    );
  }
}
