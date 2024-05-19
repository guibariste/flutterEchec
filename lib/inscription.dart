// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class InscriptionScreen extends StatefulWidget {
//   @override
//   _InscriptionScreenState createState() => _InscriptionScreenState();
// }

// class _InscriptionScreenState extends State<InscriptionScreen> {
//   final _pseudoController = TextEditingController();
//   final _passwordController = TextEditingController();

//   Future<void> _sendData() async {
//     var response = await http.post(
//       Uri.parse('http://localhost:8080/inscription'),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({
//         'pseudo': _pseudoController.text,
//         'password': _passwordController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Si le serveur renvoie une réponse "OK"
//       print('Inscription réussie');
//     } else {
//       // Gérer les erreurs ici
//       print('Erreur lors de l\'inscription${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inscription'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextFormField(
//               controller: _pseudoController,
//               decoration: InputDecoration(
//                 labelText: 'Pseudo',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Mot de passe',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 24.0),
//             ElevatedButton(
//               child: Text('Valider'),
//               onPressed: _sendData,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:echec/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drawer.dart';

class InscriptionScreen extends StatefulWidget {
  @override
  _InscriptionScreenState createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final _pseudoController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _sendData() async {
    var response = await http.post(
      Uri.parse('http://localhost:8080/inscription'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'pseudo': _pseudoController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Inscription réussie');
      // Logique supplémentaire si nécessaire
    } else {
      print('Erreur lors de l\'inscription: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Inscription',

      onDrawerItemTapped:
          onDrawerItemClicked, // Implémentez la logique de navigation
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _pseudoController,
              decoration: InputDecoration(
                labelText: 'Pseudo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Valider'),
              onPressed: _sendData,
            ),
          ],
        ),
      ),
    );
  }
}
