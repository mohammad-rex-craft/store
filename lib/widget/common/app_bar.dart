import 'package:darttest/widget/common/btn.dart';
import 'package:flutter/material.dart';
import '../../utility/hooks.dart';
import '../../database/auth/log_in_out.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final LogInOut _logInOut = LogInOut();

  CustomAppBar({
    required this.title,
    this.actions,
    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: hexToColor("#303F9F"),
      title: Text(title, style: TextStyle(color: Colors.white)),
      centerTitle: true,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            spacing: 10,
            children: [
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Btn(title: 'All Input',onTap: ()=>router(context,'/all_input')),
                  Btn(title: 'All Output',onTap: ()=>router(context,'/all_output')),
                  Btn(title: 'Log Out',onTap: ()=>_logInOut.signOut(context)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Btn(title: 'Storage',onTap: ()=>router(context,'/storage')),
                  Btn(title: 'Inventory',onTap: ()=>router(context,'/inventory')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150);
} 