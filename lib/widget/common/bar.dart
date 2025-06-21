import 'package:flutter/material.dart';

const primeColor = Color(0xFF03A9F4);

class Bar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;  
  
  const Bar({
    required this.title,
    this.color = primeColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: color,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
} 
