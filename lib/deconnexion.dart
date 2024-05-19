import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Deconnexion extends StatelessWidget {
  final VoidCallback onConfirmed;

  Deconnexion({required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    // Différer l'affichage de la boîte de dialogue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showConfirmationDialog(context);
    });

    return Container(); // Retourne un conteneur vide
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('lastUser');
                onConfirmed(); // Callback après la déconnexion
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
            ),
          ],
        );
      },
    );
  }
}
