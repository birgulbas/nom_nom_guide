import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../home_screen.dart';
import '../favorites_screen.dart';
import '../profile_screen.dart';
import '../settings_screen.dart';

final List<Widget> _pages = [
  HomeScreenContent(), // Ana sayfa içeriği
  FavoritesScreen(), // Favoriler sayfası
  ProfileScreen(), // Kullanıcı profili sayfası
  SettingsScreen(), // Ayarlar sayfası
];

class Cafe {
  final String name;
  final String description;
  final String hours;
  final String mapUrl;
  final String? image; //?
  final String priceLevel;
  final double rating;

  Cafe({
    required this.name,
    required this.description,
    required this.hours,
    required this.mapUrl,
    required this.priceLevel,
    required this.rating,
    this.image,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      name: json['name'],
      description: json['description'],
      hours: json['hours'],
      mapUrl: json['map_url'],
      image: json['image'],
      priceLevel: json['price_level'] ?? 'medium',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }
}

Future<List<Cafe>> fetchStudyCafes() async {
  final url = Uri.parse('http://127.0.0.1:8000/api/categories/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    final studyCategory = data.firstWhere((cat) => cat['slug'] == 'study');
    final cafes = studyCategory['cafes'] as List;
    return cafes.map((json) => Cafe.fromJson(json)).toList();
  } else {
    throw Exception('Veri alınamadı');
  }
}

class ConceptStudyCafeScreen extends StatefulWidget {
  @override
  _StudyCafePageState createState() => _StudyCafePageState();
}

class _StudyCafePageState extends State<ConceptStudyCafeScreen> {
  late Future<List<Cafe>> _allCafesFuture;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _allCafesFuture = fetchStudyCafes();
  }

  void _filterChanged(String value) {
    setState(() {
      _selectedFilter = value;
    });
  }

  bool _matchesFilter(Cafe cafe) {
    if (_selectedFilter == 'all') return true;
    return cafe.priceLevel == _selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Cafes'),
        backgroundColor: Colors.orange.shade300,

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 12,
              children: [
                FilterChip(
                  label: Text("All"),
                  selected: _selectedFilter == 'all',
                  onSelected: (_) => _filterChanged('all'),
                ),
                FilterChip(
                  label: Text("Cheaper"),
                  selected: _selectedFilter == 'low',
                  onSelected: (_) => _filterChanged('low'),
                ),
                FilterChip(
                  label: Text("medium"),
                  selected: _selectedFilter == 'medium',
                  onSelected: (_) => _filterChanged('medium'),
                ),
                FilterChip(
                  label: Text("more expensive"),
                  selected: _selectedFilter == 'high',
                  onSelected: (_) => _filterChanged('high'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Cafe>>(
              future: _allCafesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Hata: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Cafe is not found."));
                }

                final cafes = snapshot.data!
                    .where(_matchesFilter)
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cafes.length,
                  itemBuilder: (context, index) {
                    final cafe = cafes[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      child: ListTile(
                        leading: cafe.image != null
                            ? Image.network(cafe.image!, width: 70, fit: BoxFit.cover)
                            : Container(width: 70, color: Colors.grey[300], child: const Center(child: Text('FOTO'))),
                        title: Text(cafe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cafe.description, style: TextStyle(color: Colors.grey[700])),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                ...List.generate(5, (i) {
                                  return Icon(
                                    i < cafe.rating.round() ? Icons.star : Icons.star_border,
                                    size: 16,
                                    color: Colors.deepOrangeAccent,
                                  );
                                }),
                                const SizedBox(width: 4),
                                Text(cafe.rating.toString(), style: TextStyle(fontSize: 12, color: Colors.grey[700]))
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(cafe.hours, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.map),
                          onPressed: () async {
                            final uri = Uri.parse(cafe.mapUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } else {
                              print("URL açılamıyor: $uri");
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          // navigasyon eklenebilir
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
