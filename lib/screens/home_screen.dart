import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'nearbyPlaces_screen.dart';
import 'category_screen.dart';
import 'randomAdventure_screen.dart';
import 'package:nom_nom_guide/models/place.dart';
import 'package:nom_nom_guide/services/api_services.dart';  
import 'places_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // sayfalar
  final List<Widget> _pages = [
    HomeScreenContent(), // Ana sayfa içeriği
    FavoritesScreen(), // Favoriler sayfası
    ProfileScreen(), // Kullanıcı profili sayfası
    SettingsScreen(), // Ayarlar sayfası
  ];

  // Butonlara tıklandığında sayfa değiştirme fonksiyonu
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_selectedIndex], // Seçili sayfayı göstermek için

      // Alt Navigasyon Çubuğu
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, //etiketleri gizlemek için
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.pink.shade600, 
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HomePage'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// Ana Sayfa İçeriği
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    try {
      // getPlaces fonksiyonunu çağırarak kafeleri çekiyoruz.
      final places = await ApiServices().getPlaces(
        category: null, // Kategoriyi burada belirleyebilirsiniz
        price: null, // Fiyat aralığı
        minRating: null, // Minimum puan
        hasWifi: null, // WiFi durumu
      );
      setState(() {
        _places = places;
      });
    } catch (e) {
      print("Yerler alınamadı: $e");
    }
  }


  void _handleSearch() {
    String query = _searchController.text.toLowerCase().trim();

   Place? matchedPlace;
try {
  matchedPlace = _places.firstWhere((place) => place.name.toLowerCase() == query);
} catch (e) {
  matchedPlace = null;
}



    if (matchedPlace != null) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PlaceScreen(place: matchedPlace!), // dikkat: matchedPlace!
    ),
  );
}
 else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("There is no such cafe.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(color: Colors.deepOrange.shade100),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) => _handleSearch(),
            decoration: InputDecoration(
              labelText: 'Search Cafes & Restaurants',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _handleSearch,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              _buildCustomListTile(
                  context, "Nearby Places", Icons.location_on, Colors.pink.shade300, NearbyScreen()),
              _buildCustomListTile(
                  context, "Concept Places", Icons.category, Colors.blue.shade300, CategoryPlaceScreen()),
              _buildCustomListTile(
                  context, "Random Adventure", Icons.casino, Colors.orange.shade300, RandomAdventureScreen()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomListTile(BuildContext context, String title, IconData icon, Color bgColor, Widget targetScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }
}
