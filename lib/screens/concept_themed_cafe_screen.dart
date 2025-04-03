import 'package:flutter/material.dart';

class ConceptThemedCafeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Themed Cafe"),
        backgroundColor: Colors.green.shade300,
      ),
      body: Center(
        child: Text(
          "Themed Cafe burada listelenecek.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
