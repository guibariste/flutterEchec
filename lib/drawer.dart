import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  final String currentUser;
  final Function(BuildContext, int) onItemSelected;

  AppDrawer({required this.currentUser, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(currentUser.isEmpty ? '' : currentUser),
            accountEmail: Text(''),
          ),
          ListTile(
            title: Text('Accueil'),
            onTap: () => onItemSelected(context, 0),
          ),
          ListTile(
            title: Text('Inscription'),
            onTap: () => onItemSelected(context, 1),
          ),
          ListTile(
            title: Text('Connexion'),
            onTap: () => onItemSelected(context, 2),
          ),
          ListTile(
            title: Text('Jeu'),
            onTap: () => onItemSelected(context, 3),
          ),
          ListTile(
            title: Text('Déconnexion'),
            onTap: () => onItemSelected(
                context, 4), // Supposons que l'index 3 est pour la déconnexion
          ),
          ListTile(
            title: Text('Multijoueur'),
            onTap: () => onItemSelected(
                context, 5), // Supposons que l'index 3 est pour la déconnexion
          ),
        ],
      ),
    );
  }
}

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final Function(BuildContext, int) onDrawerItemTapped;

  BaseScaffold({
    required this.title,
    required this.body,
    required this.onDrawerItemTapped,
  });

  static String _lastUser = 'non connecte';

  // Méthode statique pour accéder à _lastUser
  static String getLastUser() {
    return _lastUser;
  }

  // Méthode statique pour définir _lastUser
  static void setLastUser(String username) {
    _lastUser = username;
  }

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  void initState() {
    super.initState();
    _loadLastUser();
  }

  _loadLastUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      BaseScaffold.setLastUser(prefs.getString('lastUser') ?? 'non connecte');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (BaseScaffold.getLastUser().isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(child: Text(BaseScaffold.getLastUser())),
            ),
        ],
      ),
      drawer: AppDrawer(
        // Ajout du drawer ici
        currentUser: BaseScaffold._lastUser,
        onItemSelected: widget.onDrawerItemTapped,
      ),
      body: widget.body,
    );
  }
}
