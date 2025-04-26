import 'package:flutter/material.dart';
import 'package:nom_nom_guide/models/place.dart'; 

class FavoritesManager with ChangeNotifier {
  final List<Place> _favorites = [];

  List<Place> get favorites => _favorites;

  bool isFavorite(Place place) {
    return _favorites.any((element) => element.id == place.id);
  }

  void addFavorite(Place place) {
    _favorites.add(place);
    notifyListeners();
  }

  void removeFavorite(Place place) {
    _favorites.removeWhere((element) => element.id == place.id);
    notifyListeners();
  }

  void toggleFavorite(Place place) {
    if (isFavorite(place)) {
      removeFavorite(place);
    } else {
      addFavorite(place);
    }
  }
}
