import 'package:echec/main.dart';
import 'package:flutter/material.dart';
import 'chess_board.dart';
import 'inscription.dart';
import 'connexion.dart';
import 'deconnexion.dart';
import 'multijoueur.dart';

void onDrawerItemClicked(BuildContext context, int index) {
  Navigator.pop(context); // Fermer le drawer
  switch (index) {
    case 0:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      break;
    case 1:
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => InscriptionScreen()));
      break;
    case 2:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConnexionScreen()));
      break;
    case 3:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChessBoardScreen(
                    role: "",
                    adversaire: "",
                    pseudo: "",
                  )));
      break;
    case 4: // Supposons que l'index 3 est pour la déconnexion
      showDialog(
        context: context,
        builder: (context) => Deconnexion(
          onConfirmed: () {
            // Planifier la navigation après la fin de la phase de construction
            Future.microtask(() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            });
          },
        ),
      );
      break;
    case 5:
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MultijoueurScreen()));
      break;
  }
}
