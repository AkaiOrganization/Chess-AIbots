import 'package:flutter/material.dart';
import '../models/board.dart';

class ChessBoardWidget extends StatefulWidget {
  @override
  _ChessBoardWidgetState createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  ChessBoard board = ChessBoard();

  @override
  void initState() {
    super.initState();
    board.initializeBoard();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 64,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ 8;
        int col = index % 8;

        bool isWhiteSquare = (row + col) % 2 == 0;

        return Container(
          color: isWhiteSquare ? Colors.brown[200] : Colors.brown[700],
          child: board.board[row][col] != null
              ? Image.asset(board.board[row][col]!.imagePath)
              : null,
        );
      },
    );
  }
}