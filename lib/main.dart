import 'package:flutter/material.dart';
import 'home.dart';
import 'login_page.dart';
import 'login_check.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duck Classification',
      home: LoginCheck(),
      debugShowCheckedModeBanner: false,
    );
  }
}