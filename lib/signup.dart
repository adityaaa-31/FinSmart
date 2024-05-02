//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signup extends StatefulWidget {
  @override
  signupState createState() => signupState();
}

class signupState extends State<signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Future signUp() async {
      try {
        if (_formKey.currentState!.validate()) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          // FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(
            msg: 'Account Created',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0,
          );
        }
      } on FirebaseAuthException catch (error) {
        String errorMessage = 'Oops, Something went wrong!';
        switch (error.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          // Handle other Firebase Auth errors as needed
        }
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      } catch (error) {
        print('Error: $error');
        Fluttertoast.showToast(
          msg: 'Oops, Something went wrong!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset('assets/images/Logo.jpeg'),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(
                              r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEFEBE9),
                        prefixIcon: const Icon(Icons.person),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Montserrat',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Email',
                        contentPadding: const EdgeInsets.all(18)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEFEBE9),
                          prefixIcon: const Icon(Icons.lock),
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Montserrat',
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.all(18)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password should be atleast 6 characters long';
                        }
                        return null;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEFEBE9),
                          prefixIcon: const Icon(Icons.lock),
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Montserrat',
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Confirm Password',
                          contentPadding: const EdgeInsets.all(18)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password should be atleast 6 characters long';
                        } else if (value != passwordController.text) {
                          return 'Passwords dont match';
                        }
                        return null;
                      },
                    )),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: ButtonTheme(
                      child: ElevatedButton(
                          onPressed: signUp,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                            ),
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
