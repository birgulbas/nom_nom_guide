import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 🟣 http paketi eklendi
import 'dart:convert'; // 🟣 JSON ayrıştırmak için

import 'login_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'nearbyPlaces_screen.dart';
import 'conceptPlaces_screen.dart';
import 'userFavorites_screen.dart';
import 'randomAdventure_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreenContent(),
    FavoritesScreen(),
    ProfileScreen(),
    SettingsScreen(),
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
        actions: [
          IconButton(
            icon: Icon(Icons.person, size: 30, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreenContent()),
              );
            },
          )
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
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

// 🟣 StatefulWidget olarak HomeScreenContent yeniden yazıldı
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String message = "Django'dan veri bekleniyor..."; // 🟣 Gelen veri burada tutulur

  @override
  void initState() {
    super.initState();
    fetchData(); // 🟣 Sayfa açıldığında veri çekilir
  }

  // 🟣 Django'dan veri çeken fonksiyon
  void fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/hello/'));


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          message = data['message']; // 🟣 JSON içindeki mesaj alınır
        });
      } else {
        setState(() {
          message = "Hata kodu: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        message = "Bağlantı hatası: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            decoration: InputDecoration(
              labelText: 'Search Cafes & Restaurants',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),

Padding(
  padding: const EdgeInsets.all(16.0),
  child: Text(
    message,
    style: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.red, // 🔴 Renk ekledik, hemen görünsün
    ),
    textAlign: TextAlign.center,
  ),
),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              _buildCustomListTile(
                  context, "Nearby Places", Icons.location_on, Colors.pink.shade300, NearbyScreen()),
              _buildCustomListTile(
                  context, "Concept Places", Icons.category, Colors.blue.shade300, ConceptScreen()),
              _buildCustomListTile(
                  context, "User Favorites", Icons.star, Colors.green.shade300, FavoritesPlacesScreen()),
              _buildCustomListTile(
                  context, "Random Adventure", Icons.casino, Colors.orange.shade300, RandomScreen()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomListTile(BuildContext context, String title, IconData icon, Color bgColor, Widget targetScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
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

