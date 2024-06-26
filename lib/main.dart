import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/main_page.dart';

 
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MyApp()
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
);
  }
}

