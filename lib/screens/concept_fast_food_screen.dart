import 'package:flutter/material.dart';

class ConceptFastFoodScreen extends StatelessWidget {
  const ConceptFastFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fast Food"),
        backgroundColor: Colors.green.shade300,
      ),
      body: Center(
        child: Text(
          "Fast Food burada listelenecek.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
