import 'package:flutter/material.dart';
import '../utility/hooks.dart';
import '../widget/common/bar.dart';
import '../widget/screens/home/index.dart';

var primeColor = hexToColor('#03A9F4');

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'StoreFlow', color: hexToColor("#303F9F")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                WelcomeCard(),         
                SizedBox(height: 30),  
                Expanded(
                  child: ActionCards(),
                ), 
                SizedBox(height: 20), 
                QuickButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 