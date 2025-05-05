class Review {
  final int id;
  final String username;
  final String comment;
  double rating;
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
      rating: (json['rating'] as num).toDouble(), 
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
