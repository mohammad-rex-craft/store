import './screens/edit.dart';
import './screens/inventory/inventory.dart';
import './screens/inventory/inventory_by_id.dart';
import './screens/inventory_settlement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/add_Items.dart';
import './screens/remove_items.dart';
import './screens/all_inputs/all_input.dart';
import './screens/all_inputs/all_input_by_id.dart';
import './screens/all_output/all_output.dart';
import './screens/all_output/all_output_by_id.dart';
import './screens/storage.dart';
import './screens/log_in.dart';
import './database/auth/auth_wrapper.dart';
import './screens/all_settlement_by_id.dart';
import './screens/all_settlements.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ylaqczgirzddwrtvfcur.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlsYXFjemdpcnpkZHdydHZmY3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk1NzYxMTAsImV4cCI6MjA2NTE1MjExMH0.4JOfZle_j76TxX18JIvMeACDeqCZtsdwLWnb8eXKLGQ',
  );

  runApp(MyApp());
}

const Color colorText = Color.fromARGB(255, 1, 54, 103);
const Color colorMain = Color.fromARGB(255, 31, 185, 185);
const Color colorLowOpacity = Color.fromARGB(103, 1, 54, 103);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoreFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext ctx) => AuthWrapper(child: HomeScreen()),
        '/login': (BuildContext ctx) => LogIn(),
        '/add_items': (BuildContext ctx) => AuthWrapper(child: AddItems()),
        '/remove_items': (BuildContext ctx) =>
            AuthWrapper(child: RemoveItems()),
        '/all_input': (BuildContext ctx) => AuthWrapper(child: AllInput()),
        '/all_output': (BuildContext ctx) => AuthWrapper(child: AllOutput()),
        '/storage': (BuildContext ctx) => AuthWrapper(child: Storage()),
        '/all_input_by_id': (BuildContext ctx) =>
            AuthWrapper(child: AllInputById()),
        '/all_output_by_id': (BuildContext ctx) =>
            AuthWrapper(child: AllOutputById()),
        '/edit': (BuildContext ctx) => AuthWrapper(child: Edit()),
        '/inventory': (BuildContext ctx) => AuthWrapper(child: Inventory()),
        '/inventory_by_id': (BuildContext ctx) =>
            AuthWrapper(child: InventoryById()),
        '/inventory_settlement': (BuildContext ctx) =>
            AuthWrapper(child: InventorySettlement()),
        '/all_settlement_by_id': (BuildContext ctx) =>
            AuthWrapper(child: AllSettlementById()),
        '/all_settlements': (BuildContext ctx) =>
            AuthWrapper(child: AllSettlements()),
      },
    );
  }
}
