import 'package:flutter/material.dart';

class ConceptBookCafeScreen extends StatelessWidget {
  const ConceptBookCafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Cafe")),
      body: Center(
        child: Text("Book Cafeler burada listelenecek"),
      ),
    );
  }
}
