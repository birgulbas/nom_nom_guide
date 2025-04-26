// models/review.dart
class Review {
  final int id;
  final String user;
  final String comment;
  final int rating;

  Review({
    required this.id,
    required this.user,
    required this.comment,
    required this.rating,
  });

  // JSON'dan Review nesnesi oluşturma
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      user: json['user'],
      comment: json['comment'],
      rating: json['rating'],
    );
  }

  // Review nesnesini JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'comment': comment,
      'rating': rating,
    };
  }
}
