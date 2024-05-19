// // base_scaffold.dart
// import 'package:flutter/material.dart';
// import 'drawer.dart'; // Assurez-vous d'avoir importé votre drawer personnalisé

// class BaseScaffold extends StatelessWidget {
//   final String title;
//   final Widget body;
//   final String lastUser;

//   BaseScaffold({
//     required this.title,
//     required this.body,
//     required this.lastUser,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       drawer: AppDrawer(
//           currentUser: lastUser,
//           onItemSelected: (index) {
//             // Navigation logic based on index
//           }),
//       body: body,
//     );
//   }
// }
