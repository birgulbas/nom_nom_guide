import 'package:flutter/material.dart';

class ConceptPetFriendlyCafeScreen extends StatelessWidget {
  const ConceptPetFriendlyCafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Friendly Cafe"),
        backgroundColor: Colors.green.shade300,
      ),
      body: Center(
        child: Text(
          "Pet Friendly Cafe burada listelenecek.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
