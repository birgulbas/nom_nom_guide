import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nom_nom_guide/manager/favorites.dart';
import 'package:nom_nom_guide/screens/places_screen.dart'; 

class FavoritesPlacesScreen extends StatelessWidget {
  const FavoritesPlacesScreen({super.key});

  // - tıklandığında detay sayfasına yönlendir
  void _onPlaceTapped(BuildContext context, place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceScreen(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesManager = Provider.of<FavoritesManager>(context);
    final favorites = favoritesManager.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.deepOrangeAccent,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text("Favorites will be listed here."),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final place = favorites[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100, // arka plan rengi
                      borderRadius: BorderRadius.circular(16), // Köşe yumuşatma
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3), 
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        place.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(place.location),
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _onPlaceTapped(context, place), // favori kafeye tıklandığında yönlendirme
                    ),
                  ),
                );
              },
            ),
    );
  }
}



