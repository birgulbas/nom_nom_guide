import 'package:flutter/material.dart';

class ConceptOutdoorPlaceScreen extends StatelessWidget {
  const ConceptOutdoorPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Outdoor Place"),
        backgroundColor: Colors.green.shade300,
      ),
      body: Center(
        child: Text(
          "Outdoor Place burada listelenecek.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
