import 'package:flutter/material.dart';

enum PieceColor { White, Black }

abstract class ChessPiece {
  final PieceColor color;
  String get image;
  String get name; // Nom de la pièce

  ChessPiece(this.color);
}

class Pawn extends ChessPiece {
  Pawn(PieceColor color) : super(color);

  @override
  String get image => color == PieceColor.White
      ? 'assets/white_pawn.png'
      : 'assets/black_pawn.png';

  @override
  String get name => 'Pawn';
}

class King extends ChessPiece {
  King(PieceColor color) : super(color);

  @override
  String get image => color == PieceColor.White
      ? 'assets/white_king.png'
      : 'assets/black_king.png';

  @override
  String get name => 'King';
}

class Queen extends ChessPiece {
  Queen(PieceColor color) : super(color);

  @override
  String get image => color == PieceColor.White
      ? 'assets/white_queen.png'
      : 'assets/black_queen.png';

  @override
  String get name => 'Queen';
}

class Knight extends ChessPiece {
  Knight(PieceColor color) : super(color);

  @override
  String get image => color == PieceColor.White
      ? 'assets/white_knight.png'
      : 'assets/black_knight.png';

  @override
  String get name => 'Knight';
}

class Tour extends ChessPiece {
  Tour(PieceColor color) : super(color);

  @override
  String get image => color == PieceColor.White
      ? 'assets/white_rook.png'
      : 'assets/black_rook.png';

  @override
  String get name => 'Tour';
}

class Fou extends ChessPiece {
  Fou(PieceColor color) : super(color);

  @override
  String get image => color == PieceColor.White
      ? 'assets/white_bishop.png'
      : 'assets/black_bishop.png';

  @override
  String get name => 'Fou';
}
// Vous pouvez ajouter d'autres classes pour les différentes pièces ici.
