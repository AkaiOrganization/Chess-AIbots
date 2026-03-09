import 'piece.dart';

class ChessMove {
  final int sr, sc, er, ec;
  ChessMove(this.sr, this.sc, this.er, this.ec);
}

class MoveRecord {
  final int sr, sc, er, ec;
  final ChessPiece movedBefore;
  final ChessPiece movedAfter;
  final ChessPiece? captured;
  final PieceColor turnBefore;

  MoveRecord({
    required this.sr,
    required this.sc,
    required this.er,
    required this.ec,
    required this.movedBefore,
    required this.movedAfter,
    required this.captured,
    required this.turnBefore,
  });
}

class ChessBoard {
  List<List<ChessPiece?>> board =
  List.generate(8, (_) => List.generate(8, (_) => null));

  PieceColor turn = PieceColor.white;

  PieceColor playerColor = PieceColor.white;
  bool isBoardFlipped = false;

  ChessPiece? pieceAt(int r, int c) => board[r][c];

  void configureGame({
    required PieceColor playerColor,
    required bool flipped,
  }) {
    this.playerColor = playerColor;
    isBoardFlipped = flipped;
  }

  void initializeBoard() {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        board[r][c] = null;
      }
    }

    for (int c = 0; c < 8; c++) {
      board[1][c] = ChessPiece(
        id: 'bp$c',
        type: PieceType.pawn,
        color: PieceColor.black,
        imagePath: 'assets/images/bp.png',
      );

      board[6][c] = ChessPiece(
        id: 'wp$c',
        type: PieceType.pawn,
        color: PieceColor.white,
        imagePath: 'assets/images/wp.png',
      );
    }

    _setBackRank(0, PieceColor.black);
    _setBackRank(7, PieceColor.white);

    turn = PieceColor.white;
  }

  void _setBackRank(int row, PieceColor color) {
    final prefix = color == PieceColor.white ? 'w' : 'b';
    final short = color == PieceColor.white ? 'w' : 'b';

    String p(String name) => 'assets/images/${prefix}$name.png';

    board[row][0] = ChessPiece(
      id: '${short}r1',
      type: PieceType.rook,
      color: color,
      imagePath: p('r'),
    );
    board[row][1] = ChessPiece(
      id: '${short}n1',
      type: PieceType.knight,
      color: color,
      imagePath: p('n'),
    );
    board[row][2] = ChessPiece(
      id: '${short}b1',
      type: PieceType.bishop,
      color: color,
      imagePath: p('b'),
    );
    board[row][3] = ChessPiece(
      id: '${short}q',
      type: PieceType.queen,
      color: color,
      imagePath: p('q'),
    );
    board[row][4] = ChessPiece(
      id: '${short}k',
      type: PieceType.king,
      color: color,
      imagePath: p('k'),
    );
    board[row][5] = ChessPiece(
      id: '${short}b2',
      type: PieceType.bishop,
      color: color,
      imagePath: p('b'),
    );
    board[row][6] = ChessPiece(
      id: '${short}n2',
      type: PieceType.knight,
      color: color,
      imagePath: p('n'),
    );
    board[row][7] = ChessPiece(
      id: '${short}r2',
      type: PieceType.rook,
      color: color,
      imagePath: p('r'),
    );
  }

  void makeMove(int sr, int sc, int er, int ec) {
    final piece = board[sr][sc];
    if (piece == null) return;

    board[er][ec] = piece;
    board[sr][sc] = null;

    if (piece.type == PieceType.pawn) {
      if (piece.color == PieceColor.white && er == 0) {
        board[er][ec] = ChessPiece(
          id: piece.id,
          type: PieceType.queen,
          color: PieceColor.white,
          imagePath: 'assets/images/wq.png',
        );
      } else if (piece.color == PieceColor.black && er == 7) {
        board[er][ec] = ChessPiece(
          id: piece.id,
          type: PieceType.queen,
          color: PieceColor.black,
          imagePath: 'assets/images/bq.png',
        );
      }
    }

    turn = (turn == PieceColor.white) ? PieceColor.black : PieceColor.white;
  }

  MoveRecord? makeMoveRecord(int sr, int sc, int er, int ec) {
    final piece = board[sr][sc];
    if (piece == null) return null;

    final captured = board[er][ec];
    final turnBefore = turn;

    makeMove(sr, sc, er, ec);

    final movedAfter = board[er][ec]!;
    return MoveRecord(
      sr: sr,
      sc: sc,
      er: er,
      ec: ec,
      movedBefore: piece,
      movedAfter: movedAfter,
      captured: captured,
      turnBefore: turnBefore,
    );
  }

  void undo(MoveRecord rec) {
    turn = rec.turnBefore;
    board[rec.sr][rec.sc] = rec.movedBefore;
    board[rec.er][rec.ec] = rec.captured;
  }
}