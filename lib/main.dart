import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chess AI',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: GameScreen(),
    );
  }
}