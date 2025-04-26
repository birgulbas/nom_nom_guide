import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nom_nom_guide/manager/favorites.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesManager = Provider.of<FavoritesManager>(context);
    final favorites = favoritesManager.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text("FAVORITES")),
      body: favorites.isEmpty
          ? const Center(
              child: Text("Favoriler burada listelenecek."),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final place = favorites[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Text(place.location),
                );
              },
            ),
    );
  }
}
