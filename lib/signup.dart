//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/login_page.dart';

class signup extends StatefulWidget {
  @override
  signupState createState() => signupState();
}

class signupState extends State<signup> {
  SnackBar _snackBar = new SnackBar(content: Text('Account Created!'));
  SnackBar _snackBar2 =
      new SnackBar(content: Text('Oops, Something went wrong!'));

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool checkPassword() {
      return passwordController.text == confirmPasswordController.text;
    }

    Future signUp() async {
      if (checkPassword()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(_snackBar2);
      }
    }

    @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset('assets/images/Logo.jpeg'),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFEFEBE9),
                      prefixIcon: Icon(Icons.person),
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Montserrat',
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Email',
                      contentPadding: EdgeInsets.all(18)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFEFEBE9),
                        prefixIcon: Icon(Icons.lock),
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Montserrat',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Password',
                        contentPadding: EdgeInsets.all(18)),
                  )),
              Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFEFEBE9),
                        prefixIcon: Icon(Icons.lock),
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Montserrat',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Confirm Password',
                        contentPadding: EdgeInsets.all(18)),
                  )),
              Container(
                height: 50,
                width: 400,
                child: ButtonTheme(
                    child: ElevatedButton(
                        onPressed: signUp,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                          shape: StadiumBorder(),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
