import 'package:flutter/material.dart';
import 'package:nom_nom_guide/models/place.dart';
import 'package:nom_nom_guide/models/review.dart';
import 'package:nom_nom_guide/manager/favorites.dart';
import 'package:nom_nom_guide/services/api_services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'all_reviews_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  bool isLoadingReviews = true;
  bool isFavorite = false;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadData();
    _fetchReviews();
    _checkIfFavorite();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? reviewsJson = prefs.getString('reviews_${widget.place.id}');
    if (reviewsJson != null) {
      List<dynamic> reviewsList = jsonDecode(reviewsJson);
      setState(() {
        _reviews = reviewsList.map((review) => Review.fromJson(review)).toList();
      });
    }
    setState(() {
      isLoadingReviews = false;
    });
  }

  void _showEditDialog(Review review) {
    final TextEditingController editController = TextEditingController(text: review.comment);
    int editRating = review.rating;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit your comment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Update your comment...',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < editRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      editRating = index + 1;
                    });
                  },
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (editController.text.isEmpty || editRating == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill in all fields.")),
                );
                return;
              }

              final prefs = await SharedPreferences.getInstance();
              setState(() {
                final index = _reviews.indexWhere((r) => r.id == review.id);
                if (index != -1) {
                  _reviews[index] = Review(
                    id: review.id,
                    username: review.username,
                    comment: editController.text,
                    rating: editRating,
                    createdAt: review.createdAt,
                  );
                }
              });

              prefs.setString(
                'reviews_${widget.place.id}',
                jsonEncode(_reviews.map((r) => r.toJson()).toList()),
              );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Comment updated.")),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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

  void _deleteReview(Review reviewToDelete) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (reviewToDelete.username != username) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only delete your own comments.")),
      );
      return;
    }

    String? reviewsJson = prefs.getString('reviews_${widget.place.id}');
    if (reviewsJson == null) return;

    List<dynamic> reviewsList = jsonDecode(reviewsJson);
    List<Review> allReviews = reviewsList.map((review) => Review.fromJson(review)).toList();

    List<Review> updatedReviews = allReviews.where((r) => r.id != reviewToDelete.id).toList();

    prefs.setString(
      'reviews_${widget.place.id}',
      jsonEncode(updatedReviews.map((review) => review.toJson()).toList()),
    );

    setState(() {
      _reviews = updatedReviews;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Your comment has been deleted.")),
    );
  }

  Future<void> _fetchReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reviewsJson = prefs.getString('reviews_${widget.place.id}');
      if (reviewsJson != null) {
        final List<dynamic> decoded = jsonDecode(reviewsJson);
        setState(() {
          _reviews = decoded.map((r) => Review.fromJson(r)).toList();
        });
      }
    } catch (e) {
      print('Error while retrieving comments: $e');
    }
  }

  Future<void> _addReview() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in.")),
      );
      return;
    }

    bool alreadyCommented = _reviews.any((review) => review.username == username);
    if (alreadyCommented) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have already submitted a comment.")),
      );
      return;
    }

    if (_commentController.text.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter comments and ratings.")),
      );
      return;
    }

    try {
      final newReview = Review(
        id: DateTime.now().millisecondsSinceEpoch,
        username: username,
        comment: _commentController.text,
        rating: _rating,
        createdAt: DateTime.now(),
      );

      List<Review> updatedReviews = [..._reviews, newReview];
      prefs.setString(
        'reviews_${widget.place.id}',
        jsonEncode(updatedReviews.map((review) => review.toJson()).toList()),
      );
      setState(() {
        _reviews = updatedReviews;
      });

      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your comment has been sent successfully.")),
      );
    } catch (e) {
      print('Error while adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment could not be added.")),
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
    List<Review> limitedReviews = _reviews.length > 3 ? _reviews.sublist(0, 3) : _reviews;
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
                onDoubleTap: _openInGoogleMaps,
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
        overflow: TextOverflow.ellipsis, // metin taşarsa üç nokta  ekle
        softWrap: true, // metin fazlaysa  alt satıra geçer
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
  itemCount: limitedReviews.length,
  itemBuilder: (context, index) {
    final review = limitedReviews[index];

    return ListTile(
      title: Text('${review.username}: ${review.comment}'),
      subtitle: Text('Rating: ${review.rating}'),
 trailing: review.username == (_username ?? '')
    ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              _showEditDialog(review);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _deleteReview(review);
            },
          ),
        ],
      )
    : Text(
        review.createdAt.toLocal().toString().split(' ')[0],
        style: const TextStyle(color: Colors.grey),
      ),


    );
  },
),
if (_reviews.length > 3)
  Align(
    alignment: Alignment.centerLeft,
    child: TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllReviewsScreen(reviews: _reviews),
          ),
        );
      },
      child: const Text(
        'See all comments',
        style: TextStyle(color: Colors.teal),
      ),
    ),
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
 
