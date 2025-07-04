import 'package:flutter/material.dart';
import '../utility/hooks.dart';
import '../widget/common/bar.dart';
import '../widget/screens/home/app_drawer.dart';
import '../widget/screens/home/index.dart';

var primeColor = hexToColor('#03A9F4');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Bar(
        title: 'StoreFlow',
        color: hexToColor("#303F9F"),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          tooltip: 'menu',
        ),
        showLanguageSelector: true,
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: const Column(
          children: [
            Expanded(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        WelcomeCard(),
                        SizedBox(height: 20),
                        DashboardStats(),
                        SizedBox(height: 20),
                        ActionCards(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
