import 'package:flutter/material.dart';
import 'language_selector.dart';

const primeColor = Color(0xFF03A9F4);

class Bar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;  
  final IconData? icon;
  final String? logoPath;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLanguageSelector;
  
  const Bar({
    required this.title,
    this.color = primeColor,
    this.icon,
    this.logoPath,
    this.actions,
    this.leading,
    this.showLanguageSelector = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget = leading;
    
    if (leadingWidget == null) {
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
    }

    List<Widget> appBarActions = [];
    
    if (showLanguageSelector) {
      appBarActions.add(const LanguageSelector());
    }
    
    if (actions != null) {
      appBarActions.addAll(actions!);
    }
    
    return AppBar(
        leading: leadingWidget,
        title: Text(title,style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),),
        actions: appBarActions.isNotEmpty ? appBarActions : null,
        backgroundColor: color,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
} 
