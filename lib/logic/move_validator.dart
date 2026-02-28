import '../models/board.dart';
import '../models/piece.dart';

class MoveValidator {
  static bool isValidMove(
      ChessBoard board,
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    ChessPiece? piece = board.board[startRow][startCol];

    if (piece == null) return false;

    // Нельзя ходить на свою фигуру
    ChessPiece? target = board.board[endRow][endCol];
    if (target != null && target.color == piece.color) {
      return false;
    }

    switch (piece.type) {
      case PieceType.pawn:
        return _validatePawn(board, piece, startRow, startCol, endRow, endCol);

      case PieceType.rook:
        return _validateRook(board, startRow, startCol, endRow, endCol);

      case PieceType.knight:
        return _validateKnight(startRow, startCol, endRow, endCol);

      case PieceType.bishop:
        return _validateBishop(board, startRow, startCol, endRow, endCol);

      case PieceType.queen:
        return _validateQueen(board, startRow, startCol, endRow, endCol);

      case PieceType.king:
        return _validateKing(startRow, startCol, endRow, endCol);
    }
  }

  // ------------------ Пешка ------------------

  static bool _validatePawn(
      ChessBoard board,
      ChessPiece piece,
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    int direction = piece.color == PieceColor.white ? -1 : 1;

    // обычный ход вперёд
    if (startCol == endCol &&
        endRow == startRow + direction &&
        board.board[endRow][endCol] == null) {
      return true;
    }

    // взятие по диагонали
    if ((endCol == startCol + 1 || endCol == startCol - 1) &&
        endRow == startRow + direction &&
        board.board[endRow][endCol] != null) {
      return true;
    }

    return false;
  }

  // ------------------ Ладья ------------------

  static bool _validateRook(
      ChessBoard board,
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    if (startRow != endRow && startCol != endCol) return false;
    return _isPathClear(board, startRow, startCol, endRow, endCol);
  }

  // ------------------ Конь ------------------

  static bool _validateKnight(
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    int rowDiff = (startRow - endRow).abs();
    int colDiff = (startCol - endCol).abs();

    return (rowDiff == 2 && colDiff == 1) ||
        (rowDiff == 1 && colDiff == 2);
  }

  // ------------------ Слон ------------------

  static bool _validateBishop(
      ChessBoard board,
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    if ((startRow - endRow).abs() != (startCol - endCol).abs()) {
      return false;
    }
    return _isPathClear(board, startRow, startCol, endRow, endCol);
  }

  // ------------------ Ферзь ------------------

  static bool _validateQueen(
      ChessBoard board,
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    return _validateRook(board, startRow, startCol, endRow, endCol) ||
        _validateBishop(board, startRow, startCol, endRow, endCol);
  }

  // ------------------ Король ------------------

  static bool _validateKing(
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    int rowDiff = (startRow - endRow).abs();
    int colDiff = (startCol - endCol).abs();

    return rowDiff <= 1 && colDiff <= 1;
  }

  // ------------------ Проверка пути ------------------

  static bool _isPathClear(
      ChessBoard board,
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    int rowStep = (endRow - startRow).sign;
    int colStep = (endCol - startCol).sign;

    int currentRow = startRow + rowStep;
    int currentCol = startCol + colStep;

    while (currentRow != endRow || currentCol != endCol) {
      if (board.board[currentRow][currentCol] != null) {
        return false;
      }

      currentRow += rowStep;
      currentCol += colStep;
    }

    return true;
  }
}