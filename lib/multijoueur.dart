import 'package:echec/chess_board.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drawer.dart';
import 'package:echec/global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MultijoueurScreen extends StatefulWidget {
  @override
  MultijoueurScreenState createState() => MultijoueurScreenState();
}

class MultijoueurScreenState extends State<MultijoueurScreen> {
  Function(Offset, Offset)? onPositionReceived;
  Function(bool)? onEchec;
  List<String> joueurs = [];
  late String pseudo;
  late IO.Socket socket;

  var _showInvitation = false;
  String transfert = "";
  var hote = "";
  @override
  void initState() {
    super.initState();
    pseudo = BaseScaffold.getLastUser();
    connectToSocket();
    sendPseudo(pseudo);
    rejoindreMultijoueur(pseudo);
  }

  @override
  void dispose() {
    super.dispose();
    // sendPseudo(pseudo);
    socket.disconnect();
  }

  Future<void> rejoindreMultijoueur(String pseudo) async {
    var response = await http.post(
      Uri.parse('http://localhost:8080/rejoindreMultijoueur'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'pseudo': pseudo}),
    );

    if (response.statusCode == 200) {
      List<String> tousLesJoueurs =
          List<String>.from(json.decode(response.body)['joueurs']);
      setState(() {
        joueurs = tousLesJoueurs.where((j) => j != pseudo).toList();
      });
    }
  }

  Future<void> quitterMultijoueur(String pseudo) async {
    var response = await http.post(
      Uri.parse('http://localhost:8080/quitterMultijoueur'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'pseudo': pseudo}),
    );

    if (response.statusCode == 200) {
      List<String> tousLesJoueurs =
          List<String>.from(json.decode(response.body)['joueurs']);
      setState(() {
        joueurs = tousLesJoueurs.where((j) => j != pseudo).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Multijoueur',
      onDrawerItemTapped: onDrawerItemClicked,
      body: Column(
        children: <Widget>[
          ElevatedButton(
            child: Text('Rejoindre le Mode Multijoueur'),
            onPressed: () => rejoindreMultijoueur(pseudo),
          ),
          ElevatedButton(
            child: Text('Quitter le Mode Multijoueur'),
            onPressed: () => quitterMultijoueur(pseudo),
          ),
          if (_showInvitation)
            AlertDialog(
              title: Text('Invitation'),
              content: Text(
                  'Vous avez été invité par $hote à rejoindre une partie.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // Accepter l'invitation - Ajoutez votre logique ici
                    acceptInvitation(hote, pseudo);
                    _showInvitation = false;
                    // _isVersus = true;
                  },
                  child: Text('Accepter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    refuseInvitation(hote, pseudo);
                    _showInvitation = false;
                  },
                  child: Text('Refuser'),
                ),
              ],
            ),
          Expanded(
            child: joueurs.isEmpty
                ? Center(
                    child:
                        Text('Il n\'y a pas encore de joueurs dans le mode.'))
                : ListView.builder(
                    itemCount: joueurs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(joueurs[index]),
                        trailing: ElevatedButton(
                          child: Text('Inviter'),
                          onPressed: () {
                            inviteFriend(joueurs[index]);
                            // Logique d'invitation
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

//--------------------FONCTIONS----------------------------

  void connectToSocket() {
//     // socket = IO.io('http://192.168.164.141:8080', <String, dynamic>{
//     //   'transports': ['websocket'],
//     // });
    socket = IO.io('http://localhost:8080', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('connect', (_) {});

    socket.on('position', (data) {
      Offset pos = _parseOffset(data['pos']);
      Offset newPos = _parseOffset(data['newPos']);
      if (onPositionReceived != null) {
        onPositionReceived!(pos, newPos);
      }
    });
    socket.on('echec', (data) {
      bool mat = (data['mat']);
      if (onEchec != null) {
        onEchec!(mat);
      }
    });

    socket.on('invitation', (message) {
      if (mounted)
        setState(() {
          _showInvitation = true;
          hote = message;
        });
    });

    socket.on('invitationRefusee', (invite) {
      // Afficher un message indiquant que l'invitation a été refusée
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$invite a refusé l'invitation")),
      );
    });

    socket.on('partieCommence', (data) {
      String role = data['role'];
      String adversaire = data['adversaire'];
      // String nomPartie = data['nomPartie'];

      // Définir un délai en fonction du rôle
      int delayDuration = (role == 'blanc') ? 1 : 2;

      // Attendre avant de naviguer vers l'écran de jeu
      Future.delayed(Duration(seconds: delayDuration), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChessBoardScreen(
                role: role, adversaire: adversaire, pseudo: pseudo),
          ),
        );
      });
    });
  }

  void sendPseudo(String pseudo) {
    socket.emit('pseudo', {'pseudo': pseudo});
  }

  void inviteFriend(String friendPseudo) {
    // Émettre l'événement 'inviteFriend' avec le pseudonyme de l'ami
    socket.emit('inviteFriend', {'invite': friendPseudo});
  }

  Offset _parseOffset(String offsetString) {
    var parts =
        offsetString.replaceAll('Offset(', '').replaceAll(')', '').split(', ');
    return Offset(double.parse(parts[0]), double.parse(parts[1]));
  }

  void acceptInvitation(String hote, String pseudo) {
    socket.emit('acceptInvitation', {'hote': hote, 'invite': pseudo});
  }

  void envoiPos(pos, newPos, bool echec) {
    socket.emit('pos', {'pos': pos.toString(), 'newPos': newPos.toString()});
  }

  void envoiEchec(bool mat) {
    socket.emit('echec', {'mat': mat});
  }

  void refuseInvitation(String hote, String pseudo) {
    socket.emit('refuseInvitation', {'hote': hote, 'invite': pseudo});
  }
}
