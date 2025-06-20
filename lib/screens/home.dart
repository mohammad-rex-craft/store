import 'package:flutter/material.dart';
import '../widget/common/btn.dart';
import '../utility/hooks.dart';
import '../widget/common/app_bar.dart';

var primeColor = hexToColor('#03A9F4');

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 20,
              children: [
                Btn(
                  title: 'Add Items',
                  color: hexToColor('#303F9F'),
                  height: 50,
                  width: double.infinity
                  ,onTap: ()=>router(context,'/add_items')
                ),
                Btn(
                  title: 'Remove Items',
                  color: hexToColor('#303F9F'),
                  height: 50,
                  width: double.infinity,
                  onTap: ()=>router(context,'/remove_items')
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
