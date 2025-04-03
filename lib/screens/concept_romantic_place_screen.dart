import 'package:flutter/material.dart';

class ConceptRomanticPlaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Romantic Place"),
        backgroundColor: Colors.green.shade300,
      ),
      body: Center(
        child: Text(
          "Romantic Place burada listelenecek.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
