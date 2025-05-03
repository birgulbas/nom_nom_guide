// lib/models/review.dart
class Review {
  final int id;
  final String username;
  final String comment;
  final int rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.username,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      username: json['username'],
      comment: json['comment'],
      rating: json['rating'],
       createdAt: DateTime.parse(json['createdAt']),
    ); 
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
