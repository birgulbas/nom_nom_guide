class Place {
  final String name;
  final String location;
  final String category;
  final double rating;
  final int totalReviews;
  final String? description;
  final String priceRange;
  final bool hasWifi;

  Place({
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.totalReviews,
    this.description,
    required this.priceRange,
    required this.hasWifi,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      location: json['location'],
      category: json['category'],
      rating: json['rating'].toDouble(),
      totalReviews: json['total_reviews'],
      description: json['description'], // varsa
      priceRange: json['price_range'],
      hasWifi: json['has_wifi'],
    );
  }
}