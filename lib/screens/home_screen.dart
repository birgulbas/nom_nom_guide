import 'package:flutter/material.dart';
import 'package:nom_nom_guide/screens/category_screen.dart';
import 'package:nom_nom_guide/screens/nearbyPlaces_screen.dart';
import 'package:nom_nom_guide/screens/userFavorites_screen.dart';
import 'package:nom_nom_guide/screens/randomAdventure_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreenContent(),
    const FavoritesPlacesScreen(),
    const Placeholder(), // Profil yerine Placeholder eklendi (profil ekranı eklenince değiştir)
    const Placeholder(), // Ayarlar için de aynı şekilde
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Login ikonu kaldırıldı
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.pink.shade600,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HomePage'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade100,
            ),
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
              decoration: const InputDecoration(
                labelText: 'Search Cafes & Restaurants',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                _buildCustomListTile(
                  context,
                  "Nearby Places",
                  Icons.location_on,
                  Colors.pink.shade300,
                  const NearbyScreen(),
                ),
                _buildCustomListTile(
                  context,
                  "Concept Places",
                  Icons.category,
                  Colors.blue.shade300,
                  const CategoryPlaceScreen(category: 'concept'),
                ),
                _buildCustomListTile(
                  context,
                  "User Favorites",
                  Icons.star,
                  Colors.green.shade300,
                  const FavoritesPlacesScreen(),
                ),
                _buildCustomListTile(
                  context,
                  "Random Adventure",
                  Icons.casino,
                  Colors.orange.shade300,
                  const RandomScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomListTile(
    BuildContext context,
    String title,
    IconData icon,
    Color bgColor,
    Widget targetScreen,
  ) {
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
