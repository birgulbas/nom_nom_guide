import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("FAVORITES")),
        body: Center(
          child: Text("Favoriler  burada listelenecek."),
        ),
      );
    }
}