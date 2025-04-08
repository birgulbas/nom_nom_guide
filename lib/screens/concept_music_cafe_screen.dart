import 'package:flutter/material.dart';

class ConceptMusicCafeScreen extends StatelessWidget {
  const ConceptMusicCafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Music Cafe")),
      body: Center(
        child: Text("Music Cafeler burada listelenecek"),
      ),
    );
  }
}
