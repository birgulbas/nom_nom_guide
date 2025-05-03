// lib/screens/all_reviews_screen.dart
import 'package:flutter/material.dart';
import 'package:nom_nom_guide/models/review.dart'; // Doğru import bu

class AllReviewsScreen extends StatelessWidget {
  final List<Review> reviews;

  const AllReviewsScreen({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Reviews')),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return ListTile(
            title: Text(review.username),
            subtitle: Text(review.comment),
            trailing: Text('${review.rating}/5'),
          );
        },
      ),
    );
  }
}
