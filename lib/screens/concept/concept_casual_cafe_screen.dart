import 'package:flutter/material.dart';

class ConceptCasualCafeScreen extends StatelessWidget {
  const ConceptCasualCafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Casual Cafe")),
      body: Center(
        child: Text("Casual Cafe burada listelenecek."),
      ),
    );
  }
}
