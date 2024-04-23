// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/home_page.dart';



class NavDrawer extends StatefulWidget {
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final _user = FirebaseAuth.instance.currentUser!;



  SnackBar _snackBar = new SnackBar(content: Text('Successfully Logged Out'));

  signout() {
    FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(

            child: Text(
              'User ${_user.email}',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),

            decoration: BoxDecoration(
                color: Colors.lightGreen,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg')
                )
            ),
          ),

          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () {
              Navigator.pop(context, MaterialPageRoute(builder: (context) => NavDrawer()));
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: signout,
          ),
        ],
      ),
    );
  }
}