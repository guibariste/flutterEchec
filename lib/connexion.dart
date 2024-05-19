// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class ConnexionScreen extends StatefulWidget {
//   @override
//   _ConnexionScreenState createState() => _ConnexionScreenState();
// }

// class _ConnexionScreenState extends State<ConnexionScreen> {
//   final _pseudoController = TextEditingController();
//   final _passwordController = TextEditingController();

//   Future<void> _sendData() async {
//     var response = await http.post(
//       Uri.parse('http://localhost:8080/connexion'),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({
//         'pseudo': _pseudoController.text,
//         'password': _passwordController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       print('Connexion réussie, session ID: ${data["sessionId"]}');
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('lastUser', _pseudoController.text);

//       // Vous pouvez maintenant stocker le sessionId et l'utiliser pour authentifier les requêtes futures
//     } else {
//       print('Erreur lors de la connexion');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connexion'),
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
// connexion.dart
import 'package:echec/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drawer.dart';
import 'main.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ConnexionScreen extends StatefulWidget {
  @override
  _ConnexionScreenState createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final _pseudoController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _sendData() async {
    var response = await http.post(
      Uri.parse('http://localhost:8080/connexion'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'pseudo': _pseudoController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Connexion réussie');
      var data = json.decode(response.body);
      print('Connexion réussie, session ID: ${data["sessionId"]}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastUser', _pseudoController.text);
      // Logique supplémentaire si nécessaire
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print('Erreur lors de la connexion: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Connexion',

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
