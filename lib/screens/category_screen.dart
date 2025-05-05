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

  String? selectedPriceRange;
  bool wifiOnly = false;

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
  final futurePlaces = ApiServices().getPlaces(
    category: selectedCategory,
    price: selectedPriceRange,
    hasWifi: wifiOnly ? true : null,
  );

  setState(() {
    places = futurePlaces;
    
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
      appBar: AppBar(title: const Text('Places')),
      body: Column(
        children: [
          // Kategori, fiyat ve WiFi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Category
                  SizedBox(
                    width: 160,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedCategory,
                      hint: const Text("Category"),
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['key'],
                          child: Text(
                            category['label']!,
                            overflow: TextOverflow.ellipsis, // taşmayı engellemek için
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        onCategorySelected(value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Price
                  SizedBox(
                    width: 160,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedPriceRange,
                      hint: const Text("Price"),
                      items: [
                        DropdownMenuItem(value: null, child: Text("All")),
                        DropdownMenuItem(value: 'cheap', child: Text("Cheap")),
                        DropdownMenuItem(value: 'medium', child: Text("Medium")),
                        DropdownMenuItem(value: 'expensive', child: Text("Expensive")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPriceRange = value;
                        });
                        fetchPlaces();
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // WiFi
                  SizedBox(
                    width: 160,
                    child: SwitchListTile(
                      title: const Text("has WiFi "),
                      value: wifiOnly,
                      onChanged: (value) {
                        setState(() {
                          wifiOnly = value;
                        });
                        fetchPlaces();
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),

          

          // Mekanlar listesi
          Expanded(
            child: FutureBuilder<List<Place>>(
              future: places,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Places not found.'));
                }

                final placeList = snapshot.data!;
                return ListView.builder(
  itemCount: placeList.length,
  itemBuilder: (context, index) {
    final place = placeList[index];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.pink.shade100,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.local_cafe, color: Colors.pink.shade700, size: 30),
        title: Row(
          children: [
            Text(
              place.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
           
          ],
        ),
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
