import 'piece.dart';

enum PlayerSideOption { white, black, random }

class GameSettings {
  final PlayerSideOption playerSideOption;
  final bool autoFlipBoard;

  const GameSettings({
    required this.playerSideOption,
    this.autoFlipBoard = true,
  });

  PieceColor resolvePlayerColor() {
    switch (playerSideOption) {
      case PlayerSideOption.white:
        return PieceColor.white;
      case PlayerSideOption.black:
        return PieceColor.black;
      case PlayerSideOption.random:
        return DateTime.now().millisecond.isEven
            ? PieceColor.white
            : PieceColor.black;
    }
  }
}