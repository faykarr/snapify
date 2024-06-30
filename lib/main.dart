import 'package:flutter/material.dart';
import 'package:snapify/pages/splash_screen.dart';
import 'package:snapify/utils/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snapify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: backgroundColor1),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}