import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // פונקציית main - נקודת הכניסה לאפליקציה
  runApp(SelichotApp());
}

class SelichotApp extends StatelessWidget {
  // בונה את ה־MaterialApp הראשי
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'סליחות',
      theme: ThemeData(
        fontFamily: 'Arial',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 20, fontFamily: 'Arial'),
          bodyMedium: TextStyle(fontSize: 18, fontFamily: 'Arial'),
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
