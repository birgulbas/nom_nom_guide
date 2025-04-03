import 'package:flutter/material.dart';

class ConceptFamilyCafeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Family Cafe"),
        backgroundColor: Colors.green.shade300,
      ),
      body: Center(
        child: Text(
          "Family Cafe burada listelenecek.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
