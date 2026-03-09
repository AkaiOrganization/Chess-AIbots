import 'package:flutter/material.dart';
import '../../../../core/utils/notation.dart';
import '../../logic/ai.dart';
import '../../models/board.dart';
import '../../models/piece.dart';
import '../widgets/chess_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final ChessBoard board = ChessBoard();

  final List<MoveRecord> history = [];
  final List<String> movesText = [];

  PieceColor playerColor = PieceColor.white;

  @override
  void initState() {
    super.initState();
    _startNewGameWithColor(PieceColor.white);
  }

  void _pushRecord(MoveRecord rec) {
    history.add(rec);
    movesText.add(Notation.toAlgebraic(rec));
  }

  void _startNewGameWithColor(PieceColor color) {
    setState(() {
      playerColor = color;
      board.initializeBoard();
      board.configureGame(
        playerColor: playerColor,
        flipped: playerColor == PieceColor.black,
      );
      history.clear();
      movesText.clear();
    });

    if (playerColor == PieceColor.black) {
      Future.delayed(const Duration(milliseconds: 250), () {
        final aiRec = ChessAI.makeMoveAndReturn(board);
        if (aiRec != null) {
          setState(() {
            _pushRecord(aiRec);
          });
        }
      });
    }
  }

  void _startRandomGame() {
    final color = DateTime.now().millisecond.isEven
        ? PieceColor.white
        : PieceColor.black;

    _startNewGameWithColor(color);
  }

  void _toggleBoardFlip() {
    setState(() {
      board.isBoardFlipped = !board.isBoardFlipped;
    });
  }

  void _undoTwoPlies() {
    setState(() {
      if (history.isNotEmpty) {
        final last = history.removeLast();
        board.undo(last);
        movesText.removeLast();
      }
      if (history.isNotEmpty) {
        final last2 = history.removeLast();
        board.undo(last2);
        movesText.removeLast();
      }
    });
  }

  String get _turnText {
    return board.turn == PieceColor.white ? 'Ход белых' : 'Ход чёрных';
  }

  List<_MovePair> get _groupedMoves {
    final result = <_MovePair>[];

    for (int i = 0; i < movesText.length; i += 2) {
      final white = movesText[i];
      final black = (i + 1 < movesText.length) ? movesText[i + 1] : '';
      result.add(_MovePair(
        moveNumber: (i ~/ 2) + 1,
        white: white,
        black: black,
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 280,
              child: _LeftPanel(
                onWhite: () => _startNewGameWithColor(PieceColor.white),
                onBlack: () => _startNewGameWithColor(PieceColor.black),
                onRandom: _startRandomGame,
                onUndo: _undoTwoPlies,
                onFlip: _toggleBoardFlip,
                turnText: _turnText,
                playerColor: playerColor,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 760,
                    maxHeight: 760,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _BoardCard(
                      child: ChessBoardWidget(
                        board: board,
                        onMoveMade: (rec) {
                          setState(() {
                            _pushRecord(rec);
                          });

                          Future.delayed(const Duration(milliseconds: 220), () {
                            final aiRec = ChessAI.makeMoveAndReturn(board);
                            if (aiRec != null) {
                              setState(() {
                                _pushRecord(aiRec);
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            SizedBox(
              width: 320,
              child: _MovesPanel(groupedMoves: _groupedMoves),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  final VoidCallback onWhite;
  final VoidCallback onBlack;
  final VoidCallback onRandom;
  final VoidCallback onUndo;
  final VoidCallback onFlip;
  final String turnText;
  final PieceColor playerColor;

  const _LeftPanel({
    required this.onWhite,
    required this.onBlack,
    required this.onRandom,
    required this.onUndo,
    required this.onFlip,
    required this.turnText,
    required this.playerColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorText =
    playerColor == PieceColor.white ? 'Белые' : 'Чёрные';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF26231F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3B352F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Игровая панель',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          _InfoTile(
            title: 'Ты играешь',
            subtitle: colorText,
            icon: Icons.person,
          ),
          const SizedBox(height: 10),
          _InfoTile(
            title: 'Статус',
            subtitle: turnText,
            icon: Icons.flag,
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onWhite,
            child: const Text('Начать за белых'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onBlack,
            child: const Text('Начать за чёрных'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRandom,
            child: const Text('Рандомный цвет'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onFlip,
            child: const Text('Повернуть доску'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onUndo,
            child: const Text('Отменить 2 хода'),
          ),
          const Spacer(),
          const Text(
            'Сегодня это крепкая база.\nЗавтра поверх неё добавим шах и рокировку.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovesPanel extends StatelessWidget {
  final List<_MovePair> groupedMoves;

  const _MovesPanel({required this.groupedMoves});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF26231F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3B352F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'История ходов',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: groupedMoves.isEmpty
                ? const Center(
              child: Text(
                'Сделай первый ход',
                style: TextStyle(color: Colors.white54),
              ),
            )
                : ListView.builder(
              itemCount: groupedMoves.length,
              itemBuilder: (_, index) {
                final move = groupedMoves[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 42,
                        child: Text(
                          '${move.moveNumber}.',
                          style: const TextStyle(
                            color: Color(0xFFD6B37A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          move.white,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          move.black,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardCard extends StatelessWidget {
  final Widget child;

  const _BoardCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2A2623),
            Color(0xFF1D1A18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF4A4038), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _InfoTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD6B37A)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovePair {
  final int moveNumber;
  final String white;
  final String black;

  _MovePair({
    required this.moveNumber,
    required this.white,
    required this.black,
  });
}