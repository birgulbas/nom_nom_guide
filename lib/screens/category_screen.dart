import 'package:flutter/material.dart';

import 'package:nom_nom_guide/services/api_services.dart';
import 'package:nom_nom_guide/models/place.dart';
import 'package:nom_nom_guide/screens/places_screen.dart';

class CategoryPlaceScreen extends StatefulWidget {
  final String? category;

  const CategoryPlaceScreen({super.key, this.category});

  @override
  _CategoryPlaceScreenState createState() => _CategoryPlaceScreenState();
}

class _CategoryPlaceScreenState extends State<CategoryPlaceScreen> {
  String? selectedCategory;
  late Future<List<Place>> places;
  List<Map<String, String>> categories = [];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category;
    fetchCategories();
    fetchPlaces();
  }

  void fetchCategories() async {
    try {
      final fetchedCategories = await ApiServices().getCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Kategori çekilirken hata: $e');
    }
  }

  void fetchPlaces() {
    setState(() {
      places = ApiServices().getPlaces(
        category: selectedCategory?.isEmpty ?? true ? null : selectedCategory,
      );
    });
  }

  void onCategorySelected(String? categoryKey) {
    setState(() {
      selectedCategory = selectedCategory == categoryKey ? null : categoryKey;
    });
    fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mekanlar')),
      body: Column(
        children: [
          // Kategoriler Yatay Liste
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category['key'];

                return GestureDetector(
                  onTap: () => onCategorySelected(category['key']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category['label']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Mekanlar Listesi
          Expanded(
            child: FutureBuilder<List<Place>>(
              future: places,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Mekan bulunamadı.'));
                }

                final placeList = snapshot.data!;
                return ListView.builder(
                  itemCount: placeList.length,
                  itemBuilder: (context, index) {
                    final place = placeList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(place.name),
                        subtitle: Text(place.location),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceScreen(place: place),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}  