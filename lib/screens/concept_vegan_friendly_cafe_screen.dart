import 'package:flutter/material.dart';

class ConceptVeganFriendlyCafeScreen extends StatelessWidget {
  const ConceptVeganFriendlyCafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vegan Friendly Cafe"),
        backgroundColor: Colors.green.shade300,
      ),
      body: Center(
        child: Text(
          "vegan frienl cafe burada listelenecek.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
