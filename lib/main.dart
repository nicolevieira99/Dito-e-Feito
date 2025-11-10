import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(DitoEFeitoApp());
}

class DitoEFeitoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dito e Feito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: HomeScreen(),
    );
  }
}