import 'package:flutter/material.dart';

class SimpleAnimationScreen extends StatefulWidget {
  @override
  _SimpleAnimationScreenState createState() => _SimpleAnimationScreenState();
}

class _SimpleAnimationScreenState extends State<SimpleAnimationScreen> {
  bool _moved = false;

  void _animate() {
    setState(() {
      _moved = !_moved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double xPosition = _moved ? 0 : 0; // Déplace l'objet horizontalement
    final double yPosition = _moved ? 100 : 0; // Déplace l'objet verticalement

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Animation'),
      ),
      body: Center(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(seconds: 2), // Durée de l'animation
              left: xPosition,
              top: yPosition,
              child: GestureDetector(
                onTap: _animate,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
