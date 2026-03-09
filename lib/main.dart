import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/chess/presentation/screens/game_screen.dart';

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
      theme: AppTheme.darkTheme,
      home: const GameScreen(),
    );
  }
}