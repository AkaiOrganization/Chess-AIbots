import 'piece.dart';

class ChessBoard {
  List<List<ChessPiece?>> board =
  List.generate(8, (_) => List.generate(8, (_) => null));

  void initializeBoard() {
    board[0][0] = ChessPiece(
      type: PieceType.rook,
      color: PieceColor.black,
      imagePath: "assets/images/black_rook.png",
    );

    // Добавь остальные фигуры аналогично
  }
}