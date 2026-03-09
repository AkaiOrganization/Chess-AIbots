import '../models/board.dart';
import '../models/piece.dart';

class MoveValidator {
  static bool isValidMove(ChessBoard board, int sr, int sc, int er, int ec) {
    if (!_inBounds(sr, sc) || !_inBounds(er, ec)) return false;
    if (sr == er && sc == ec) return false;

    final piece = board.board[sr][sc];
    if (piece == null) return false;

    if (piece.color != board.turn) return false;

    final target = board.board[er][ec];
    if (target != null && target.color == piece.color) return false;

    final dr = er - sr;
    final dc = ec - sc;

    switch (piece.type) {
      case PieceType.pawn:
        return _pawn(board, piece, sr, sc, er, ec, dr, dc, target);
      case PieceType.rook:
        if (dr != 0 && dc != 0) return false;
        return _clearPath(board, sr, sc, er, ec);
      case PieceType.knight:
        final a = dr.abs();
        final b = dc.abs();
        return (a == 2 && b == 1) || (a == 1 && b == 2);
      case PieceType.bishop:
        if (dr.abs() != dc.abs()) return false;
        return _clearPath(board, sr, sc, er, ec);
      case PieceType.queen:
        final straight = (dr == 0 || dc == 0);
        final diag = (dr.abs() == dc.abs());
        if (!straight && !diag) return false;
        return _clearPath(board, sr, sc, er, ec);
      case PieceType.king:
        return dr.abs() <= 1 && dc.abs() <= 1;
    }
  }

  static bool _pawn(
      ChessBoard board,
      ChessPiece piece,
      int sr,
      int sc,
      int er,
      int ec,
      int dr,
      int dc,
      ChessPiece? target,
      ) {
    final dir = (piece.color == PieceColor.white) ? -1 : 1;
    final startRow = (piece.color == PieceColor.white) ? 6 : 1;

    if (dc == 0 && dr == dir && target == null) return true;

    if (dc == 0 && sr == startRow && dr == 2 * dir) {
      final midR = sr + dir;
      if (board.board[midR][sc] == null && target == null) return true;
    }

    if (dr == dir && (dc == 1 || dc == -1) && target != null) return true;

    return false;
  }

  static bool _clearPath(ChessBoard board, int sr, int sc, int er, int ec) {
    final stepR = (er - sr).sign;
    final stepC = (ec - sc).sign;

    int r = sr + stepR;
    int c = sc + stepC;

    while (r != er || c != ec) {
      if (board.board[r][c] != null) return false;
      r += stepR;
      c += stepC;
    }

    return true;
  }

  static bool _inBounds(int r, int c) => r >= 0 && r < 8 && c >= 0 && c < 8;
}