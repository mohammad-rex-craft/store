import 'package:flutter/material.dart';
import '../../hooks.dart';

var primeColor = hexToColor('#03A9F4');

class Bar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  
  const Bar({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: primeColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
} 