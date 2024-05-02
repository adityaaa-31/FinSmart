// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _MyAppState();
}

class _MyAppState extends State<loginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SnackBar _snackBar =
      const SnackBar(content: Text('Successfully Logged in'));
  final SnackBar _snackBar2 =
      const SnackBar(content: Text('Oops, Something went wrong!'));

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future signIn() async {
      if (_formKey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          return true;
        } catch (error) {
          print('Firebase Authentication Error: $error');
          String errorMessage = 'Oops, Something went wrong!';
          if (error is FirebaseAuthException) {
            switch (error.code) {
              case 'invalid-email':
                errorMessage = 'Invalid email address';
                break;
              case 'user-not-found':
                errorMessage = 'User not found';
                break;
              case 'wrong-password':
                errorMessage = 'Wrong password';
                break;
              default:
                errorMessage = 'Authentication failed';
                break;
            }
          }
          Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          return false;
        }
      }
    }

    Future<void> showSB() async {
      if (await signIn()) {
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(_snackBar2);
      }
    }

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
                //Icon(Icons.favorite),
                const SizedBox(
                  height: 10,
                ),
                Image.asset('assets/images/Logo.jpeg'),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
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
                    controller: emailController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Montserrat',
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEFEBE9),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFEFEBE9)),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Email',
                        contentPadding: const EdgeInsets.all(18)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    controller: passwordController,
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
                        hintText: 'Password',
                        contentPadding: const EdgeInsets.all(18)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),

                Container(
                  height: 50,
                  width: 400,
                  child: ButtonTheme(
                    child: ElevatedButton(
                        onPressed: signIn,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                          shape: const StadiumBorder(),
                        ),
                        //onTap: signIn,
                        child: const Text(
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Montserrat'),
                            'Sign In')),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        'Don\'t have an account?'),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => signup()));
                      },
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
