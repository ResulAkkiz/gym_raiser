import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_raiser/pages/home_page.dart';
import 'package:gym_raiser/service/bodypart_db_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late BodyPartService sqlService;
  @override
  void initState() {
    sqlService = BodyPartService.bodyPartService;
    sqlService.database;
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
