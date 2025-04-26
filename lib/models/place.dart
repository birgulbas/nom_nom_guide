class Place {
  final int id;
  final String name;
  final String location;
  final String category;
  final double rating;
  final int totalReviews;
  final String? description;
  final String priceRange;
  final bool hasWifi;
  final double? latitude; // artık nullable
  final double? longitude;

  Place({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.totalReviews,
    this.latitude,
    this.longitude,
    this.description,
    required this.priceRange,
    required this.hasWifi,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      description: json['description'],
      priceRange: json['price_range'] ?? '',
      hasWifi: json['has_wifi'] ?? false,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}
