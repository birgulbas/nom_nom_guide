import 'package:flutter/material.dart';

class FavoritesPlacesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Favorites")),
      body: Center(
        child: Text("Favori mekanlar burada görüntülenecek."),
      ),
    );
  }
}
