import 'package:flutter/material.dart';
import 'package:nom_nom_guide/models/place.dart';

class PlaceScreen extends StatelessWidget {
  final Place place;

  const PlaceScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kafe Adı
            Text(
              place.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Lokasyon
            Row(
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 5),
                Text(place.location),
              ],
            ),
            const SizedBox(height: 12),

            // Puan ve yorum Sayısı
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 5),
                Text('${place.rating.toStringAsFixed(1)} (${place.totalReviews} yorum)'),
              ],
            ),
            const SizedBox(height: 20),

            // Açıklama
            const Text(
              'Açıklama',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              place.description ?? 'Açıklama bulunamadı.',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Kategori
            const Text(
              'Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _translateCategory(place.category),
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Fiyat Aralığı
            const Text(
              'Fiyat Aralığı',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _translatePriceRange(place.priceRange),
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Wi-Fi Durumu
            const Text(
              'Wi-Fi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              place.hasWifi ? 'Var' : 'Yok',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _translateCategory(String category) {
    switch (category) {
      case 'coffee':
        return 'Kahve';
      case 'bakery':
        return 'Fırın';
      case 'restaurant':
        return 'Restoran';
      case 'dessert':
        return 'Tatlı';
      default:
        return category;
    }
  }

  String _translatePriceRange(String priceRange) {
    switch (priceRange) {
      case 'cheap':
        return 'Uygun';
      case 'medium':
        return 'Orta';
      case 'expensive':
        return 'Pahalı';
      default:
        return priceRange;
    }
  }
}
