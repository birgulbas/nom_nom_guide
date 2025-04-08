import 'package:flutter/material.dart';

class ConceptCozyPlaceScreen extends StatelessWidget {
  const ConceptCozyPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cozy Place")),
      body: Center(
        child: Text("Cozy Place burada listelenecek."),
      ),
    );
  }
}
