//revooir lechec et mat avec threatening pieces

import 'package:flutter/material.dart';
import 'package:echec/piece.dart';
import 'package:echec/mouvements.dart';
import 'drawer.dart';
import 'package:echec/global.dart';
import 'package:echec/multijoueur.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//ca marche bien il faut pouvoir quitter et recommencer une partie sans se deconnecter
//le joueur noir a 2 alertes c a son tour de jouer c pas normal

//tester plusieurs parties serveurs
class ChessBoardScreen extends StatefulWidget {
  final String role; // "blanc" ou "noir"
  final String adversaire;
  final String pseudo;

  ChessBoardScreen(
      {required this.role, required this.adversaire, required this.pseudo});

  @override
  _ChessBoardScreenState createState() => _ChessBoardScreenState();
}

class _ChessBoardScreenState extends State<ChessBoardScreen> {
  bool tour = false; // Cette variable gère le tour

  void toggleTour() {
    setState(() {
      tour = !tour;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BaseScaffold(
  //     title: 'Jeu d\'échecs',
  //     onDrawerItemTapped: onDrawerItemClicked,
  //     body: SafeArea(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           // Pseudo de l'adversaire en haut si le joueur est noir, sinon en bas
  //           if (widget.role == "blanc") _buildPlayerName(widget.adversaire),
  //           if (widget.role == "noir")
  //             _buildPlayerName(widget.pseudo) + buildTurnIndicator(noir),
  //           Expanded(
  //             child: Center(
  //               child: ChessBoard(
  //                 onToggleTour: toggleTour,
  //                 role: widget.role,
  //               ),
  //             ),
  //           ),
  //           // Pseudo du joueur en bas si le joueur est blanc, sinon en haut
  //           if (widget.role == "blanc")
  //             _buildPlayerName(widget.pseudo) + buildTurnIndicator(blanc),
  //           if (widget.role == "noir") _buildPlayerName(widget.adversaire),
  //           // _buildTurnIndicator(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPlayerName(String playerName) {
  //   return Padding(
  //     padding: EdgeInsets.all(8.0),
  //     child: Text(
  //       playerName,
  //       style: TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 20.0,
  //         color: Colors.blueGrey,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildTurnIndicator() {
  //   return Container(
  //     padding: EdgeInsets.all(8),
  //     color: widget.role == "blanc"
  //         ? Color.fromARGB(255, 201, 197, 197)
  //         : Colors.black,
  //     child: Text(
  //       widget.role == "blanc"
  //           ? "Vous etes les Blancs "
  //           : "Vous etes les Noirs",
  //       style: TextStyle(
  //         color: widget.role == "blanc" ? Colors.black : Colors.white,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Jeu d\'échecs',
      onDrawerItemTapped: onDrawerItemClicked,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.role == "noir")
              _buildPlayerInfoRow(widget.pseudo, "noir"),
            if (widget.role == "blanc") _buildPlayerName(widget.adversaire),
            Expanded(
              child: Center(
                child: ChessBoard(
                  onToggleTour: toggleTour,
                  role: widget.role,
                ),
              ),
            ),
            if (widget.role == "blanc")
              _buildPlayerInfoRow(widget.pseudo, "blanc"),
            if (widget.role == "noir") _buildPlayerName(widget.adversaire),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerInfoRow(String playerName, String role) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildPlayerName(playerName),
        _buildTurnIndicator(role),
      ],
    );
  }

  Widget _buildPlayerName(String playerName) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        playerName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildTurnIndicator(String role) {
    return Container(
      padding: EdgeInsets.all(8),
      color:
          role == "blanc" ? Color.fromARGB(255, 201, 197, 197) : Colors.black,
      child: Text(
        role == "blanc" ? "Vous etes les Blancs" : "Vous etes les Noirs",
        style: TextStyle(
          color: role == "blanc" ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// class ChessBoard extends StatefulWidget {
//   final Function onToggleTour;

//   ChessBoard({required this.onToggleTour});

class ChessBoard extends StatefulWidget {
  final Function onToggleTour;
  final String role; // "blanc" ou "noir"

  ChessBoard({required this.onToggleTour, required this.role});
  @override
  ChessBoardState createState() => ChessBoardState();
}

class ChessBoardState extends State<ChessBoard>
    with SingleTickerProviderStateMixin {
  // ChessPiece? _selectedPiece;
  // Offset? _selectedPiecePosition;
  // Offset? _selectedPiecePosition2;
  bool echec = false;
  bool roiSeulVs = false;
  bool roiSeul = false;
  bool finPartie = false;
  bool isWhiteKingInCheck = false;
  bool isBlackKingInCheck = false;
  ChessPiece _selectedPiece = Pawn(PieceColor.White);
  Offset _selectedPiecePosition = Offset(0, 0);
  // Offset _selectedPiecePosition2 = Offset(0, 0);
  late IO.Socket socket;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  Offset _startPosition = Offset(-2000, 0);
  Offset _endPosition = Offset(2000, 0);
  bool pieceSelect = false;
  bool caseVide = false;
  bool cleared = false;
  List<Offset> legalMoves = [];
  bool tour = false;
  bool mat = false;
  bool moved = false;
  MultijoueurScreenState multi = MultijoueurScreenState();
  List<List<ChessPiece?>> board = List.generate(8, (_) => List.filled(8, null));

  @override
  void initState() {
    super.initState();

    board = _initializeBoard();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<Offset>(begin: _startPosition, end: _endPosition)
        .animate(_animationController);
    if (widget.role == "blanc") {
      tour = true;

      // Les blancs commencent
    } else {
      tour = false; // Les noirs commencent
      // _showInvalidMoveAlert(context, "C'est a votre tour de jouer");
    }
    print(widget.role);
    multi.connectToSocket();
    multi.onEchec = (bool mat) {
      if (mat) {
        _showInvalidMoveAlert(context, "Échec et mat ,partie terminee!");
        finPartie = true;
      } else {
        _showInvalidMoveAlert(context, "Vous etes en echec !");
      }
    };
    multi.onPositionReceived = (Offset pos, Offset newPos) {
      final size = MediaQuery.of(context).size;
      final double boardSize =
          size.width < size.height ? size.width : size.height;
      final double tileSize = boardSize / 10;
      int oldRow = (pos.dy / tileSize).toInt();
      int oldCol = (pos.dx / tileSize).toInt();
      int newRow = (newPos.dy / tileSize).toInt();
      int newCol = (newPos.dx / tileSize).toInt();
      // _clearPreviousPosition(pos)
      _selectedPiece = board[oldRow][oldCol]!;
      _selectedPiecePosition = Offset(oldCol * tileSize, oldRow * tileSize);

      movePiece(_selectedPiecePosition, newPos);
      _clearPreviousPosition(tileSize);
      _showInvalidMoveAlert(context, "C'est a votre tour de jouer");
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          board[newRow][newCol] = _selectedPiece;
          tour = !tour;
        });
      });
    };
  }

  List<List<ChessPiece?>> _initializeBoard() {
    finPartie = false;
    List<List<ChessPiece?>> board =
        List.generate(8, (_) => List.filled(8, null));
    for (int i = 0; i < 8; i++) {
      // board[1][i] = Pawn(PieceColor.Black);
      // board[6][i] = Pawn(PieceColor.White);
    }

    board[7][7] = Tour(PieceColor.White);
    board[7][0] = Tour(PieceColor.White);
    board[7][1] = Knight(PieceColor.White);
    board[7][6] = Knight(PieceColor.White);
    board[7][2] = Fou(PieceColor.White);
    board[7][5] = Fou(PieceColor.White);
    board[7][3] = Queen(PieceColor.White);
    board[7][4] = King(PieceColor.White);
    // board[0][7] = Tour(PieceColor.Black);
    // board[0][0] = Tour(PieceColor.Black);
    // board[0][1] = Knight(PieceColor.Black);
    // board[0][6] = Knight(PieceColor.Black);
    // board[0][2] = Fou(PieceColor.Black);
    // board[0][5] = Fou(PieceColor.Black);
    board[0][4] = King(PieceColor.Black);
    board[0][3] = Queen(PieceColor.Black);

    return board;
  }

  void _onTileTapped(int row, int col, double tileSize) {
    if (widget.role == "blanc" && !pieceSelect) {
      if (board[row][col]!.color == PieceColor.Black) {
        return;
      }
    } else if (widget.role == "noir" && !pieceSelect) {
      if (board[row][col]!.color == PieceColor.White) {
        return;
      }
    }

    bool currentKingInCheck = isKingInCheck(
        findOpposingKing(board,
            widget.role == "blanc" ? PieceColor.Black : PieceColor.White),
        board);
    if (!currentKingInCheck) {
      roiSeul = false;
    }
    if (currentKingInCheck) {
      // print("echecMonRoi");
      ChessPiece currentKing = findOpposingKing(
          board, widget.role == "blanc" ? PieceColor.Black : PieceColor.White);
      // print(currentKing.color);

//ca c bon

      List<Map<String, dynamic>> threats =
          findThreateningPieces(currentKing, board);

      ChessPiece? counterPiece = findPieceThatCanCounterThreat(threats, board,
          widget.role == "blanc" ? PieceColor.White : PieceColor.Black);

      if (counterPiece == null) {
        roiSeul = true;
      }
    }

    if (board[row][col] != null && !pieceSelect && (!roiSeul) ||
        board[row][col]?.name == "King") {
      if (!tour) {
        return;
      }
      setState(() {
        pieceSelect = true;
        _selectedPiece = board[row][col]!;
        _selectedPiecePosition = Offset(col * tileSize, row * tileSize);
        _animation = Tween<Offset>(
                begin: _selectedPiecePosition, end: _selectedPiecePosition)
            .animate(_animationController);

        legalMoves = getMoves(row, col, _selectedPiece, board);
      });
    } else if (pieceSelect) {
      Offset destination = Offset(col.toDouble(), row.toDouble());
      if (legalMoves.contains(destination)) {
        // Sauvegarder l'état actuel du plateau
        ChessPiece? originalPiece = board[row][col];
        board[row][col] = _selectedPiece;

        board[_selectedPiecePosition.dy ~/ tileSize]
            [_selectedPiecePosition.dx ~/ tileSize] = null;

        // Vérifier si le mouvement met le roi en échec
        bool selfCheck = isKingInCheck(
            findOpposingKing(board,
                widget.role == "blanc" ? PieceColor.Black : PieceColor.White),
            board);

        board[_selectedPiecePosition.dy ~/ tileSize]
            [_selectedPiecePosition.dx ~/ tileSize] = _selectedPiece;
        board[row][col] = originalPiece;

        if (selfCheck) {
          _showInvalidMoveAlert(context, "Vous etes en échec.");
        } else {
          // Sinon, finaliser le mouvement
          movePiece(
              _selectedPiecePosition, Offset(col * tileSize, row * tileSize));
          if (moved) {
            multi.envoiPos(_selectedPiecePosition,
                Offset(col * tileSize, row * tileSize), echec);
          }
          _clearPreviousPosition(tileSize);

          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              board[row][col] = _selectedPiece;
              pieceSelect = false;
              // Vérifier si le mouvement met l'adversaire en échec
              bool opponentCheck = isKingInCheck(
                  findOpposingKing(
                      board,
                      widget.role == "blanc"
                          ? PieceColor.White
                          : PieceColor.Black),
                  board);
              if (opponentCheck) {
                ChessPiece vsKing = findOpposingKing(
                    board,
                    widget.role == "blanc"
                        ? PieceColor.White
                        : PieceColor.Black);

                List<Map<String, dynamic>> threats =
                    findThreateningPieces(vsKing, board);
                ChessPiece? counterPieceVs = findPieceThatCanCounterThreat(
                    threats,
                    board,
                    widget.role == "blanc"
                        ? PieceColor.Black
                        : PieceColor.White);

                if (counterPieceVs == null) {
                  roiSeulVs = true;
                }

                ChessPiece opposingKing = findOpposingKing(
                    board,
                    widget.role == "blanc"
                        ? PieceColor.White
                        : PieceColor.Black);
                // print(opposingKing.color);
                // print("opposing");
                if (echecMat(opposingKing, board) && roiSeulVs) {
                  print("mat");
                  multi.envoiEchec(true);
                  _showInvalidMoveAlert(context, "Échec et mat !");
                  finPartie = true;
                  // Vous pouvez ajouter ici une logique pour terminer le jeu
                } else {
                  multi.envoiEchec(false);
                  _showInvalidMoveAlert(
                      context, "Le roi adverse est en échec !");
                }
              }
              tour = !tour;
              widget.onToggleTour();
              // Mettre à jour les indicateurs d'échec
              // ... Reste de la logique de mise à jour ...
            });
          });
        }
        // Restaurer la sélection de pièce et les mouvements légaux
        setState(() {
          pieceSelect = false;
          legalMoves.clear();
        });
      } else {
        setState(() {
          pieceSelect = false;
          legalMoves.clear();
        });
      }
    }
  }

  void _showInvalidMoveAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Attention"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _clearPreviousPosition(double tileSize) {
    int oldRow = (_selectedPiecePosition.dy / tileSize).toInt();
    int oldCol = (_selectedPiecePosition.dx / tileSize).toInt();
    board[oldRow][oldCol] = null;
  }

  void movePiece(Offset pos, Offset newPos) {
    setState(() {
      // print(pos);
      // print(newPos);
      _startPosition = pos;
      _endPosition = newPos;
      _animation = Tween<Offset>(begin: _startPosition, end: _endPosition)
          .animate(_animationController);
      _animationController
        ..reset()
        ..forward();
      moved = true;
    });
  }

  // void movePieceVs(Offset pos, Offset newPos) {
  //   setState(() {
  //     final size = MediaQuery.of(context).size;
  //     final double boardSize =
  //         size.width < size.height ? size.width : size.height;
  //     final double tileSize = boardSize / 8;

  //     int oldRow = (pos.dy / tileSize).toInt();
  //     int oldCol = (pos.dx / tileSize).toInt();
  //     int newRow = (newPos.dy / tileSize).toInt();
  //     int newCol = (newPos.dx / tileSize).toInt();

  //     // Récupérer la pièce à l'ancienne position
  //     ChessPiece? movingPiece = board[oldRow][oldCol];

  //     if (movingPiece != null) {
  //       // Déplacer la pièce et mettre à jour le plateau
  //       board[newRow][newCol] = movingPiece;
  //       board[oldRow][oldCol] = null;

  //       // Animation (si nécessaire)
  //       _startPosition = Offset(oldCol * tileSize, oldRow * tileSize);
  //       _endPosition = Offset(newCol * tileSize, newRow * tileSize);
  //       _animation = Tween<Offset>(begin: _startPosition, end: _endPosition)
  //           .animate(_animationController);
  //       _animationController
  //         ..reset()
  //         ..forward();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double boardSize =
        size.width < size.height ? size.width : size.height;
    final double tileSize = boardSize / 10;

    return GestureDetector(
      onTapUp: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset localOffset = box.globalToLocal(details.globalPosition);
        final int row = (localOffset.dy ~/ tileSize).toInt();
        final int col = (localOffset.dx ~/ tileSize).toInt();
        if (!finPartie) _onTileTapped(row, col, tileSize);
      },
      child: Container(
        width: tileSize * 8,
        height: tileSize * 8,
        child: Stack(
          children: [
            _buildChessBoard(tileSize),
            ..._buildChessPieces(tileSize),
            if (pieceSelect)
              Positioned(
                left: _selectedPiecePosition.dx,
                top: _selectedPiecePosition.dy,
                child: Container(
                  width: tileSize,
                  height: tileSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                  ),
                ),
              ),
            ...legalMoves.map((pos) => Positioned(
                  left: pos.dx * tileSize,
                  top: pos.dy * tileSize,
                  child: Container(
                    width: tileSize,
                    height: tileSize,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.5),
                    ),
                  ),
                )),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  left: _animation.value.dx,
                  top: _animation.value.dy,
                  child: Container(
                    width: tileSize,
                    height: tileSize,
                    child: Image.asset(_selectedPiece.image),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChessBoard(double tileSize) {
    List<Widget> tiles = List.generate(
      64,
      (i) {
        int x = i % 8;
        int y = i ~/ 8;
        return Container(
          width: tileSize,
          height: tileSize,
          color: (x + y) % 2 == 0
              ? const Color.fromARGB(255, 119, 114, 114)
              : Colors.white,
        );
      },
    );

    return GridView.count(
      crossAxisCount: 8,
      children: tiles,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  List<Widget> _buildChessPieces(double tileSize) {
    List<Widget> pieces = [];
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board[row][col] != null) {
          bool isKing = board[row][col]?.name == "King";
          bool isHighlighted = (isWhiteKingInCheck &&
                  board[row][col]?.color == PieceColor.White &&
                  isKing) ||
              (isBlackKingInCheck &&
                  board[row][col]?.color == PieceColor.Black &&
                  isKing);

          pieces.add(Positioned(
            left: col * tileSize,
            top: row * tileSize,
            child: Container(
              width: tileSize,
              height: tileSize,
              decoration: isHighlighted
                  ? BoxDecoration(
                      border: Border.all(color: Colors.red, width: 3),
                    )
                  : null,
              child: Image.asset(board[row][col]!.image),
            ),
          ));
        }
      }
    }
    return pieces;
  }

  // List<Widget> _buildChessPieces(double tileSize) {
  //   List<Widget> pieces = [];
  //   for (int row = 0; row < 8; row++) {
  //     for (int col = 0; col < 8; col++) {
  //       if (board[row][col] != null &&
  //           !(row == _startPosition.dy ~/ tileSize &&
  //               col == _startPosition.dx ~/ tileSize)) {
  //         pieces.add(Positioned(
  //           left: col * tileSize,
  //           top: row * tileSize,
  //           child: Container(
  //             width: tileSize,
  //             height: tileSize,
  //             child: Image.asset(board[row][col]!.image),
  //           ),
  //         ));
  //       }
  //     }
  //   }
  //   return pieces;
  // }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}
