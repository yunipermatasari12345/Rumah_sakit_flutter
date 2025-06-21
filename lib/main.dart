import 'package:flutter/material.dart';
import 'package:rumah_sakit_app/splas_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Rumah Sakit',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}