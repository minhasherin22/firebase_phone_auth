import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth/loginpage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: ()async{
         await FirebaseAuth.instance.signOut();
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
          },
           child: Text("Logout")),
      ),
    );
  }
}