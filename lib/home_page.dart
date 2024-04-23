import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/NavBar.dart';
import 'package:flutter_application_1/messages.dart';
// import 'package:flutter_application_1/signup.dart';
// import 'package:flutter_application_1/NavBar.dart';
// import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:flutter_application_1/visualize.dart';

class homepage extends StatefulWidget {
  homepageState createState() => homepageState();
}

class homepageState extends State<homepage> {
  final SnackBar _snackBar = SnackBar(content: Text('Successfully Logged Out'));

  signout() {
    FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  int _selectedIndex = 0;

  final _user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Welcome to FinSmart!'),
        backgroundColor: Colors.lightGreen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: Center(
        child: Home_Page(),
      ),
    );
  }

  void _onTapped(int index) {}
}
