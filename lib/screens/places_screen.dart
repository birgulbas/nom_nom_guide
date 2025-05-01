import 'package:flutter/material.dart';
import 'package:nom_nom_guide/models/place.dart';
import 'package:nom_nom_guide/models/review.dart';
import 'package:nom_nom_guide/manager/favorites.dart';
import 'package:nom_nom_guide/services/api_services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';  // url_launcher paketini ekleyin

class PlaceScreen extends StatefulWidget {
  final Place place;

  const PlaceScreen({super.key, required this.place});

  @override
  _PlaceScreenState createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  List<Review> _reviews = [];
  bool isFavorite = false; // favori durumu

  @override
  void initState() {
    super.initState();
    _fetchReviews(); // yorumları başlatırken çağrılıyor
    _checkIfFavorite(); // favori durumu kontrolü
  }

  void _checkIfFavorite() {
    setState(() {
      isFavorite = Provider.of<FavoritesManager>(context, listen: false).isFavorite(widget.place);
    });
  }

  void _toggleFavorite() {
    final favoritesManager = Provider.of<FavoritesManager>(context, listen: false);

    setState(() {
      if (isFavorite) {
        favoritesManager.removeFavorite(widget.place);
      } else {
        favoritesManager.addFavorite(widget.place);
      }
      isFavorite = !isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to favorites.' : 'Removed from favorites.',
        ),
      ),
    );
  }

  Future<void> _fetchReviews() async {
    try {
      final reviews = await ApiServices().getReviews(widget.place.id);
      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      print('Yorumlar alınırken hata: $e');
    }
  }

  Future<void> _addReview() async {
    if (_commentController.text.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter comments and ratings.")),
      );
      return;
    }

    try {
      await ApiServices().addReview(
        widget.place.id,
        _commentController.text,
        _rating,
      );
      _fetchReviews();
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your comment has been sent successfully.")),
      );
    } catch (e) {
      print('Yorum eklerken hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment could not be added. Please log in.")),
      );
    }
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
        return 'Cheap';
      case 'medium':
        return 'Medium';
      case 'expensive':
        return 'Expensive';
      default:
        return priceRange;
    }
  }

  // Google Maps'te konumu açan fonksiyon
  Future<void> _openInGoogleMaps() async {
    final googleMapsUrl = 'https://www.google.com/maps?q=${widget.place.latitude},${widget.place.longitude}';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
        backgroundColor: Colors.pink.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
               widget.place.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
           //
            const SizedBox(height: 12),
            if (widget.place.latitude != null && widget.place.longitude != null) ...[
              GestureDetector(
                onDoubleTap: _openInGoogleMaps, // çift tıklamayla haritayı açar
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(widget.place.latitude!, widget.place.longitude!),
                        zoom: 16.0,
                        interactiveFlags: InteractiveFlag.none,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          userAgentPackageName: 'com.example.nom_nom_guide',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(widget.place.latitude!, widget.place.longitude!),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            Row(
  children: [
    const Icon(Icons.location_on, size: 20, color: Colors.blue),
    const SizedBox(width: 5),
    Expanded( // adresin sığmaması durumunda taşmasını engeller
      child: Text(
        widget.place.location,
        overflow: TextOverflow.ellipsis, // metin taşarsa üç nokta  ekler
        softWrap: true, // Metin fazlaysa  alt satıra geçer
      ),
    ),
  ],
),
            const SizedBox(height: 20),
            const Text(
              'Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _translateCategory(widget.place.category),
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              'Price',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _translatePriceRange(widget.place.priceRange),
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              'Wi-Fi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.place.hasWifi ? 'yes' : 'no',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 30,
              ),
              onPressed: _toggleFavorite,
            ),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text('${_reviews[index].user}: ${_reviews[index].comment}'),
                  subtitle: Text('Rating: ${_reviews[index].rating}'),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Write a comment.:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write your comment here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Comment',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
