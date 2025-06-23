import 'package:flutter/material.dart';

const primeColor = Color(0xFF03A9F4);

class Bar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;  
  final IconData? icon;
  final String? logoPath;
  final List<Widget>? actions;
  
  const Bar({
    required this.title,
    this.color = primeColor,
    this.icon,
    this.logoPath,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    
    if (logoPath != null) {
      leadingWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          logoPath!,
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
      );
    } else if (icon != null) {
      leadingWidget = Icon(icon, color: Colors.white);
    }
    
    return AppBar(
        leading: leadingWidget,
        title: Text(title,style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),),
        actions: actions,
        backgroundColor: color,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
} 
