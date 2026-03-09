import '../../features/chess/models/board.dart';
import '../../features/chess/models/piece.dart';

class Notation {
  static String _square(int r, int c) {
    final file = String.fromCharCode('a'.codeUnitAt(0) + c);
    final rank = (8 - r).toString();
    return '$file$rank';
  }

  static String _pieceLetter(PieceType t) {
    switch (t) {
      case PieceType.king:
        return 'K';
      case PieceType.queen:
        return 'Q';
      case PieceType.rook:
        return 'R';
      case PieceType.bishop:
        return 'B';
      case PieceType.knight:
        return 'N';
      case PieceType.pawn:
        return '';
    }
  }

  static String toAlgebraic(MoveRecord rec) {
    final dest = _square(rec.er, rec.ec);
    final isCapture = rec.captured != null;
    final moved = rec.movedBefore;

    if (moved.type == PieceType.pawn) {
      if (isCapture) {
        final fromFile = String.fromCharCode('a'.codeUnitAt(0) + rec.sc);
        return '${fromFile}x$dest';
      }
      return dest;
    }

    final letter = _pieceLetter(moved.type);
    return isCapture ? '${letter}x$dest' : '$letter$dest';
  }
}