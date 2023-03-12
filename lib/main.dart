import 'package:flutter/material.dart';
import 'package:gym_raiser/core/app_contants.dart';
import 'package:gym_raiser/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ThemeColor.mintBlue,
      ),
      home: const HomePage(),
    );
  }
}
