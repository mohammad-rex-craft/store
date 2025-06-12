import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../hooks.dart';

var primeColor = hexToColor('#03A9F4');

class LogIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  singUp(BuildContext context)async{
    final supabase = await Supabase.instance.client.auth.signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if(supabase.user != null){
      replaceRouter(context, '/home');
    }else{
      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text('Error'),
        content: Text('Invalid email or password'),
      ));
    }
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


