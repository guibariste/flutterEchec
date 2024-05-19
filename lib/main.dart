// import 'package:echec/connexion.dart';
// import 'package:flutter/material.dart';
// import 'chess_board.dart';
// import 'inscription.dart'; // Nouvelle importation
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MyChessApp());
// }

// class MyChessApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Jeu d\'Échecs',
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String lastUser = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadLastUser();
//   }

//   _loadLastUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       lastUser = prefs.getString('lastUser') ?? '';
//     });
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Accueil du Jeu d\'Échecs'),
//         actions: [
//           if (lastUser.isNotEmpty)
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Center(child: Text('Bienvenue, $lastUser')),
//             ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: Text('Aller à l\'échiquier'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ChessBoardScreen()),
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: Text('Inscription'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => InscriptionScreen()),
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: Text('Connexion'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ConnexionScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// home_screen.dart
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'chess_board.dart';
import 'inscription.dart';
import 'connexion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "global.dart";

void main() {
  runApp(MyChessApp());
}

// class MyChessApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Jeu d\'Échecs',
//       home: HomeScreen(),
//     );
//   }
// }
class MyChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeu d\'Échecs',
      theme: ThemeData(
        // Personnalisation de l'AppBar
        appBarTheme: AppBarTheme(
          color: Colors.lightBlue, // Exemple de couleur
          // Vous pouvez ajouter d'autres personnalisation ici...
        ),
        // Autres configurations du thème...
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String lastUser = '';
  bool _isImagesPreloaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isImagesPreloaded) {
      _precacheImages(context);
      _isImagesPreloaded = true;
    }
  }

  void _precacheImages(BuildContext context) {
    precacheImage(AssetImage('assets/black_queen.png'), context);
    precacheImage(AssetImage('assets/white_queen.png'), context);
    precacheImage(AssetImage('assets/black_king.png'), context);
    precacheImage(AssetImage('assets/white_king.png'), context);
    precacheImage(AssetImage('assets/black_knight.png'), context);
    precacheImage(AssetImage('assets/white_knight.png'), context);
    precacheImage(AssetImage('assets/black_rook.png'), context);
    precacheImage(AssetImage('assets/white_rook.png'), context);
    precacheImage(AssetImage('assets/black_bishop.png'), context);
    precacheImage(AssetImage('assets/white_bishop.png'), context);
    precacheImage(AssetImage('assets/black_pawn.png'), context);
    precacheImage(AssetImage('assets/white_pawn.png'), context);
    // Répétez pour les autres images
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Accueil du Jeu d\'Échecs ',
      onDrawerItemTapped: onDrawerItemClicked,
      body: Center(
        child: Text('Contenu principal ici'),
      ),
    );
  }
}
