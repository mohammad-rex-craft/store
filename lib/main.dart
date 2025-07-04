import './screens/edit.dart';
import './screens/inventory/inventory.dart';
import './screens/inventory/inventory_by_id.dart';
import 'screens/settlement/inventory_settlement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
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
import 'screens/settlement/all_settlement_by_id.dart';
import 'screens/settlement/all_settlements.dart';
import 'screens/client/create_client.dart';
import 'screens/client/all_client.dart';
import 'screens/client/edit_client.dart';
import 'screens/client/show_all_by_id.dart';
import 'screens/client/chart_client.dart';
import 'l10n/language_provider.dart';
import 'l10n/l10n.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ylaqczgirzddwrtvfcur.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlsYXFjemdpcnpkZHdydHZmY3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk1NzYxMTAsImV4cCI6MjA2NTE1MjExMH0.4JOfZle_j76TxX18JIvMeACDeqCZtsdwLWnb8eXKLGQ',
  );

  runApp(const MyApp());
}

const Color colorText = Color.fromARGB(255, 1, 54, 103);
const Color colorMain = Color.fromARGB(255, 31, 185, 185);
const Color colorLowOpacity = Color.fromARGB(103, 1, 54, 103);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'StoreFlow',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: languageProvider.isRTL() ? 'Cairo' : null,
            ),
            locale: languageProvider.currentLocale,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (BuildContext ctx) => AuthWrapper(child: const HomeScreen()),
              '/login': (BuildContext ctx) =>const LogIn(),
              '/add_items': (BuildContext ctx) => AuthWrapper(child: const AddItems()),
              '/remove_items': (BuildContext ctx) =>
                  AuthWrapper(child: const RemoveItems()),
              '/all_input': (BuildContext ctx) => AuthWrapper(child: const AllInput()),
              '/all_output': (BuildContext ctx) => AuthWrapper(child: const AllOutput()),
              '/storage': (BuildContext ctx) => AuthWrapper(child: const Storage()),
              '/all_input_by_id': (BuildContext ctx) =>
                  AuthWrapper(child: const AllInputById()),
              '/all_output_by_id': (BuildContext ctx) =>
                  AuthWrapper(child: const AllOutputById()),
              '/edit': (BuildContext ctx) => AuthWrapper(child: const Edit()),
              '/inventory': (BuildContext ctx) => AuthWrapper(child: const Inventory()),
              '/inventory_by_id': (BuildContext ctx) =>
                  AuthWrapper(child: const InventoryById()),
              '/inventory_settlement': (BuildContext ctx) =>
                  AuthWrapper(child: const InventorySettlement()),
              '/all_settlement_by_id': (BuildContext ctx) =>
                  AuthWrapper(child: const AllSettlementById()),
              '/all_settlements': (BuildContext ctx) =>
                  AuthWrapper(child: const AllSettlements()),
              '/create_client': (BuildContext ctx) => AuthWrapper(child: const CreateClient()),
              '/all_client': (BuildContext ctx) => AuthWrapper(child: const AllClients()),
              '/edit_client': (BuildContext ctx) => AuthWrapper(child: const EditClient()),
              '/show_all_by_id': (BuildContext ctx) => AuthWrapper(child: const ShowAllById()),
              '/chart_client' :(BuildContext ctx) => AuthWrapper(child: const ChartClient()),
            },
          );
        },
      ),
    );
  }
}
