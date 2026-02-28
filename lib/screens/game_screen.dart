import 'package:flutter/material.dart';
import '../widgets/chess_board.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chess AI")),
      body: ChessBoardWidget(),
    );
  }
}