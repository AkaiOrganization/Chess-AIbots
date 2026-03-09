import 'package:flutter/material.dart';
import '../../models/board.dart';
import '../../logic/move_validator.dart';

class ChessBoardWidget extends StatefulWidget {
  final ChessBoard board;
  final void Function(MoveRecord rec) onMoveMade;

  const ChessBoardWidget({
    super.key,
    required this.board,
    required this.onMoveMade,
  });

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  int? selectedRow;
  int? selectedCol;

  bool get hasSelection => selectedRow != null && selectedCol != null;

  bool _isMoveHint(int r, int c) {
    if (!hasSelection) return false;
    return MoveValidator.isValidMove(
      widget.board,
      selectedRow!,
      selectedCol!,
      r,
      c,
    );
  }

  void _onTapCell(int r, int c) {
    final tapped = widget.board.pieceAt(r, c);

    if (!hasSelection) {
      if (tapped != null && tapped.color == widget.board.turn) {
        setState(() {
          selectedRow = r;
          selectedCol = c;
        });
      }
      return;
    }

    if (tapped != null && tapped.color == widget.board.turn) {
      setState(() {
        selectedRow = r;
        selectedCol = c;
      });
      return;
    }

    final sr = selectedRow!;
    final sc = selectedCol!;

    if (MoveValidator.isValidMove(widget.board, sr, sc, r, c)) {
      final rec = widget.board.makeMoveRecord(sr, sc, r, c);
      setState(() {
        selectedRow = null;
        selectedCol = null;
      });

      if (rec != null) {
        widget.onMoveMade(rec);
      }
    } else {
      setState(() {
        selectedRow = null;
        selectedCol = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide;
        final cellSize = boardSize / 8;

        return Center(
          child: SizedBox(
            width: boardSize,
            height: boardSize,
            child: Stack(
              children: [
                // Фон доски
                for (int r = 0; r < 8; r++)
                  for (int c = 0; c < 8; c++)
                    Positioned(
                      left: c * cellSize,
                      top: r * cellSize,
                      width: cellSize,
                      height: cellSize,
                      child: GestureDetector(
                        onTap: () => _onTapCell(r, c),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _cellColor(r, c),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: _buildHintOverlay(r, c),
                        ),
                      ),
                    ),

                // Фигуры поверх доски
                for (int r = 0; r < 8; r++)
                  for (int c = 0; c < 8; c++)
                    if (widget.board.pieceAt(r, c) != null)
                      _buildAnimatedPiece(
                        widget.board.pieceAt(r, c)!,
                        r,
                        c,
                        cellSize,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _cellColor(int r, int c) {
    final isLight = (r + c) % 2 == 0;
    final isSelected = hasSelection && r == selectedRow && c == selectedCol;
    final isHint = _isMoveHint(r, c);

    const lightSquare = Color(0xFFE0D6CE);
    const darkSquare = Color(0xFF5B3E34);

    if (isSelected) {
      return const Color(0xFFE3C16F);
    }

    if (isHint) {
      return const Color(0xFF8FAE7A);
    }

    return isLight ? lightSquare : darkSquare;
  }

  Widget? _buildHintOverlay(int r, int c) {
    if (!_isMoveHint(r, c)) return null;

    final piece = widget.board.pieceAt(r, c);

    // Если клетка пустая — маленькая точка
    if (piece == null) {
      return Center(
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    // Если там фигура врага — кольцо
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red.withOpacity(0.45),
          width: 4,
        ),
        shape: BoxShape.rectangle,
      ),
    );
  }

  Widget _buildAnimatedPiece(piece, int r, int c, double cellSize) {
    return AnimatedPositioned(
      key: ValueKey(piece.id),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      left: c * cellSize,
      top: r * cellSize,
      width: cellSize,
      height: cellSize,
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset(
            piece.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}