import 'package:flutter/material.dart';
import 'package:echec/piece.dart'; // Assurez-vous que ce fichier contient la définition des pièces

// List<Offset> getMoves(
//     int row, int col, ChessPiece piece, List<List<ChessPiece?>> board) {
List<Offset> getMoves(
    int row, int col, ChessPiece piece, List<List<ChessPiece?>> board) {
  List<Offset> moves = [];

  // if (piece.name == "Pawn") {
  //   int direction = piece.color == PieceColor.White ? -1 : 1;
  //   if (row + direction >= 0 && row + direction < 8) {
  //     moves.add(Offset(col.toDouble(), (row + direction).toDouble()));
  //   }
  // }

  if (piece.name == "Pawn") {
    int direction = piece.color == PieceColor.White ? -1 : 1;
    int startRow =
        piece.color == PieceColor.White ? 6 : 1; // Position de départ

    // Mouvement vers l'avant d'une case
    if (_isCellEmpty(board, row + direction, col)) {
      moves.add(Offset(col.toDouble(), (row + direction).toDouble()));

      // Mouvement initial de deux cases
      if (row == startRow && _isCellEmpty(board, row + 2 * direction, col)) {
        moves.add(Offset(col.toDouble(), (row + 2 * direction).toDouble()));
      }
    }

    // Capture en diagonale à gauche
    if (_isCellOccupiedByOpponent(
        board, row + direction, col - 1, piece.color)) {
      moves.add(Offset((col - 1).toDouble(), (row + direction).toDouble()));
    }

    // Capture en diagonale à droite
    if (_isCellOccupiedByOpponent(
        board, row + direction, col + 1, piece.color)) {
      moves.add(Offset((col + 1).toDouble(), (row + direction).toDouble()));
    }
  } else if (piece.name == "Knight") {
    List<Offset> potentialMoves = [
      Offset(2, 1),
      Offset(2, -1),
      Offset(-2, 1),
      Offset(-2, -1),
      Offset(1, 2),
      Offset(1, -2),
      Offset(-1, 2),
      Offset(-1, -2),
    ];
    for (var move in potentialMoves) {
      int newRow = row + move.dy.toInt();
      int newCol = col + move.dx.toInt();
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        if (board[newRow][newCol] == null ||
            board[newRow][newCol]!.color != piece.color) {
          moves.add(Offset(newCol.toDouble(), newRow.toDouble()));
        }
      }
    }
  }
  if (piece.name == "Tour") {
    // Mouvement horizontal
    for (int i = col + 1; i < 8; i++) {
      // Vers la droite
      if (board[row][i] == null) {
        moves.add(Offset(i.toDouble(), row.toDouble()));
      } else {
        if (board[row][i]?.color != piece.color) {
          moves.add(Offset(i.toDouble(), row.toDouble()));
        }
        break; // Arrêter si une pièce est trouvée
      }
    }
    for (int i = col - 1; i >= 0; i--) {
      // Vers la gauche
      if (board[row][i] == null) {
        moves.add(Offset(i.toDouble(), row.toDouble()));
      } else {
        if (board[row][i]?.color != piece.color) {
          moves.add(Offset(i.toDouble(), row.toDouble()));
        }
        break; // Arrêter si une pièce est trouvée
      }
    }

    // Mouvement vertical
    for (int i = row + 1; i < 8; i++) {
      // Vers le bas
      if (board[i][col] == null) {
        moves.add(Offset(col.toDouble(), i.toDouble()));
      } else {
        if (board[i][col]?.color != piece.color) {
          moves.add(Offset(col.toDouble(), i.toDouble()));
        }
        break; // Arrêter si une pièce est trouvée
      }
    }
    for (int i = row - 1; i >= 0; i--) {
      // Vers le haut
      if (board[i][col] == null) {
        moves.add(Offset(col.toDouble(), i.toDouble()));
      } else {
        if (board[i][col]?.color != piece.color) {
          moves.add(Offset(col.toDouble(), i.toDouble()));
        }
        break; // Arrêter si une pièce est trouvée
      }
    }
  } else if (piece.name == "Fou") {
    for (int i = 1; row - i >= 0 && col + i < 8; i++) {
      if (_addMoveIfPossible(row - i, col + i, piece, board, moves)) break;
    }

    for (int i = 1; row - i >= 0 && col - i >= 0; i++) {
      if (_addMoveIfPossible(row - i, col - i, piece, board, moves)) break;
    }

    for (int i = 1; row + i < 8 && col + i < 8; i++) {
      if (_addMoveIfPossible(row + i, col + i, piece, board, moves)) break;
    }

    for (int i = 1; row + i < 8 && col - i >= 0; i++) {
      if (_addMoveIfPossible(row + i, col - i, piece, board, moves)) break;
    }
  } else if (piece.name == "Queen") {
    for (int i = col + 1; i < 8; i++) {
      // Vers la droite
      if (board[row][i] == null) {
        moves.add(Offset(i.toDouble(), row.toDouble()));
      } else {
        if (board[row][i]?.color != piece.color) {
          moves.add(Offset(i.toDouble(), row.toDouble()));
        }
        break; // Arrêter si une pièce est trouvée
      }
    }
    for (int i = col - 1; i >= 0; i--) {
      // Vers la gauche
      if (board[row][i] == null) {
        moves.add(Offset(i.toDouble(), row.toDouble()));
      } else {
        if (board[row][i]?.color != piece.color) {
          moves.add(Offset(i.toDouble(), row.toDouble()));
        }
        break; // Arrêter si une pièce est trouvée
      }
    }

    // Mouvement vertical
    for (int i = row + 1; i < 8; i++) {
      // Vers le bas
      if (board[i][col] == null) {
        moves.add(Offset(col.toDouble(), i.toDouble()));
      } else {
        if (board[i][col]?.color != piece.color) {
          moves.add(Offset(col.toDouble(), i.toDouble()));
        }
        break; // Arrêter si une pièce est trouvée
      }
    }
    for (int i = row - 1; i >= 0; i--) {
      // Vers le haut
      if (board[i][col] == null) {
        moves.add(Offset(col.toDouble(), i.toDouble()));
      } else {
        if (board[i][col]?.color != piece.color) {
          moves.add(Offset(col.toDouble(), i.toDouble()));
        }
        break; // Arrêter si une pièce est trouvée
      }
    }

    for (int i = 1; row - i >= 0 && col + i < 8; i++) {
      if (_addMoveIfPossible(row - i, col + i, piece, board, moves)) break;
    }

    for (int i = 1; row - i >= 0 && col - i >= 0; i++) {
      if (_addMoveIfPossible(row - i, col - i, piece, board, moves)) break;
    }

    for (int i = 1; row + i < 8 && col + i < 8; i++) {
      if (_addMoveIfPossible(row + i, col + i, piece, board, moves)) break;
    }

    for (int i = 1; row + i < 8 && col - i >= 0; i++) {
      if (_addMoveIfPossible(row + i, col - i, piece, board, moves)) break;
    }
  }

  if (piece.name == "King") {
    List<Offset> possibleDirections = [
      Offset(1, 0), // Droite
      Offset(-1, 0), // Gauche
      Offset(0, 1), // Bas
      Offset(0, -1), // Haut
      Offset(1, 1), // Diagonale bas droite
      Offset(1, -1), // Diagonale haut droite
      Offset(-1, 1), // Diagonale bas gauche
      Offset(-1, -1) // Diagonale haut gauche
    ];

    for (Offset direction in possibleDirections) {
      int newRow = row + direction.dy.toInt();
      int newCol = col + direction.dx.toInt();

      // Vérifier que la nouvelle position est dans les limites de l'échiquier
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        // Vérifier si la case est vide ou occupée par une pièce ennemie
        if (board[newRow][newCol] == null ||
            board[newRow][newCol]!.color != piece.color) {
          moves.add(Offset(newCol.toDouble(), newRow.toDouble()));
        }
      }
    }
  }
  return moves;
}

bool _addMoveIfPossible(int newRow, int newCol, ChessPiece piece,
    List<List<ChessPiece?>> board, List<Offset> moves) {
  if (board[newRow][newCol] == null) {
    moves.add(Offset(newCol.toDouble(), newRow.toDouble()));
    return false;
  } else {
    if (board[newRow][newCol]?.color != piece.color) {
      moves.add(Offset(newCol.toDouble(), newRow.toDouble()));
    }
    return true;
  }
}

bool _isCellEmpty(List<List<ChessPiece?>> board, int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8 && board[row][col] == null;
}

bool _isCellOccupiedByOpponent(
    List<List<ChessPiece?>> board, int row, int col, PieceColor color) {
  return row >= 0 &&
      row < 8 &&
      col >= 0 &&
      col < 8 &&
      board[row][col] != null &&
      board[row][col]!.color != color;
}

bool isKingInCheck(ChessPiece king, List<List<ChessPiece?>> board) {
  int kingRow = 0, kingCol = 0;

  // Trouver la position du roi
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (board[i][j] == king) {
        kingRow = i;
        kingCol = j;
        break;
      }
    }
  }

  // Vérifier si des pièces ennemies peuvent attaquer le roi
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      ChessPiece? piece = board[i][j];
      if (piece != null && piece.color != king.color) {
        List<Offset> enemyMoves = getMoves(i, j, piece, board);
        if (enemyMoves
            .contains(Offset(kingCol.toDouble(), kingRow.toDouble()))) {
          return true; // Le roi est en échec
        }
      }
    }
  }
  return false; // Le roi n'est pas en échec
}

bool echecMat(ChessPiece king, List<List<ChessPiece?>> board) {
  int kingRow = 0, kingCol = 0;

  // Trouver la position du roi
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (board[i][j] == king) {
        kingRow = i;
        kingCol = j;
        break;
      }
    }
  }

  // Vérifier si le roi est en échec
  if (!isKingInCheck(king, board)) {
    return false; // Le roi n'est pas en échec, donc pas échec et mat
  }

  // Vérifier les mouvements possibles du roi
  List<Offset> kingMoves = getMoves(kingRow, kingCol, king, board);
  for (Offset move in kingMoves) {
    int newRow = move.dy.toInt();
    int newCol = move.dx.toInt();

    // Simuler le mouvement du roi
    ChessPiece? tempPiece = board[newRow][newCol];
    board[newRow][newCol] = king;
    board[kingRow][kingCol] = null;

    // Vérifier si le roi est toujours en échec après ce mouvement
    if (!isKingInCheck(king, board)) {
      // Si le roi n'est pas en échec après le mouvement, ce n'est pas échec et mat
      board[newRow][newCol] = tempPiece;
      board[kingRow][kingCol] = king;
      return false;
    }

    // Restaurer le plateau
    board[newRow][newCol] = tempPiece;
    board[kingRow][kingCol] = king;
  }

  // Si tous les mouvements possibles du roi le laissent en échec, c'est échec et mat
  return true;
}

List<Map<String, dynamic>> findThreateningPieces(
    ChessPiece king, List<List<ChessPiece?>> board) {
  List<Map<String, dynamic>> threateningPieces = [];
  int kingRow = 0, kingCol = 0;

  // Trouver la position du roi
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (board[i][j] == king) {
        kingRow = i;
        kingCol = j;
        break;
      }
    }
  }

  // Trouver les pièces qui menacent le roi et leur position
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      ChessPiece? piece = board[i][j];
      if (piece != null && piece.color != king.color) {
        List<Offset> enemyMoves = getMoves(i, j, piece, board);
        if (enemyMoves
            .contains(Offset(kingCol.toDouble(), kingRow.toDouble()))) {
          threateningPieces.add(
              {'piece': piece, 'position': Offset(j.toDouble(), i.toDouble())});
        }
      }
    }
  }

  return threateningPieces;
}

ChessPiece? findPieceThatCanCounterThreat(List<Map<String, dynamic>> threats,
    List<List<ChessPiece?>> board, PieceColor color) {
  for (Map<String, dynamic> threat in threats) {
    Offset threatPosition = threat['position'];

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        ChessPiece? piece = board[i][j];
        if (piece != null && piece.color == color) {
          List<Offset> moves = getMoves(i, j, piece, board);
          if (moves.contains(threatPosition)) {
            return piece; // Cette pièce peut contrer la menace
          }
        }
      }
    }
  }
  return null; // Aucune pièce ne peut contrer la menace
}

ChessPiece findOpposingKing(List<List<ChessPiece?>> board, PieceColor color) {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (board[i][j] is King && board[i][j]?.color != color) {
        return board[i][j]!;
      }
    }
  }
  throw Exception("Roi adverse introuvable");
}

class CounterCheckResult {
  bool canCounter;
  ChessPiece? counterPiece;

  CounterCheckResult({required this.canCounter, this.counterPiece});
}
