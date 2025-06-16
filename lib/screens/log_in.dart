import 'package:flutter/material.dart';
import '../hooks.dart';
import '../database/auth/log_in_out.dart';

var primeColor = hexToColor('#03A9F4');

class LogIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LogInOut _logInOut = LogInOut();
  singUp(BuildContext context)async{
    _logInOut.signUp(context, emailController.text, passwordController.text);
  }

  LogIn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#303F9F"),
        title: Text('Digital Cragt', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          ElevatedButton(onPressed: () => singUp(context), child: Text('Log In')),
        ],
      ),
    );
  }
}


