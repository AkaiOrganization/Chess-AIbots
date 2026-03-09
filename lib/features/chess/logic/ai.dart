import 'dart:math';
import '../models/board.dart';
import '../models/piece.dart';
import 'move_validator.dart';

class ChessAI {
  static final _rng = Random();

  static MoveRecord? makeMoveAndReturn(ChessBoard board) {
    if (board.turn != _aiColor(board)) return null;

    final moves = _allLegalMoves(board, _aiColor(board));
    if (moves.isEmpty) return null;

    ChessMove? bestCapture;
    int bestValue = -1;

    for (final m in moves) {
      final target = board.board[m.er][m.ec];
      if (target != null) {
        final value = _pieceValue(target.type);
        if (value > bestValue) {
          bestValue = value;
          bestCapture = m;
        }
      }
    }

    final chosen = bestCapture ?? moves[_rng.nextInt(moves.length)];
    return board.makeMoveRecord(chosen.sr, chosen.sc, chosen.er, chosen.ec);
  }

  static PieceColor _aiColor(ChessBoard board) {
    return board.playerColor == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;
  }

  static List<ChessMove> _allLegalMoves(ChessBoard board, PieceColor color) {
    final result = <ChessMove>[];

    for (int sr = 0; sr < 8; sr++) {
      for (int sc = 0; sc < 8; sc++) {
        final piece = board.board[sr][sc];
        if (piece == null || piece.color != color) continue;

        for (int er = 0; er < 8; er++) {
          for (int ec = 0; ec < 8; ec++) {
            if (MoveValidator.isValidMove(board, sr, sc, er, ec)) {
              result.add(ChessMove(sr, sc, er, ec));
            }
          }
        }
      }
    }

    return result;
  }

  static int _pieceValue(PieceType type) {
    switch (type) {
      case PieceType.pawn:
        return 1;
      case PieceType.knight:
      case PieceType.bishop:
        return 3;
      case PieceType.rook:
        return 5;
      case PieceType.queen:
        return 9;
      case PieceType.king:
        return 100;
    }
  }
}