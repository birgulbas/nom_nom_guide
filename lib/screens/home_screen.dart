import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'nearbyPlaces_screen.dart';
import 'category_screen.dart';
import 'userFavorites_screen.dart';
import 'randomAdventure_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Navigasyon için sayfalar
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
      appBar: AppBar(

      ),


      body: _pages[_selectedIndex], // Seçili sayfayı göstermek için

      // Alt Navigasyon Çubuğu
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, //etiketleri gizlemek için
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.pink.shade600, //olduğun sayfanın rengini koyulaştırır
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
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // LOGO RESMİ & ARKAPLAN
        Container(
          width: double.infinity, // Tam ekran genişliği
          height: 200, // Yüksekliği artırdık
          decoration: BoxDecoration(
            color: Colors.deepOrange.shade100, // Arka plan rengi
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // ARAMA ÇUBUĞU
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

        // KATEGORİLER 
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              _buildCustomListTile(
                  context, "Nearby Places", Icons.location_on, Colors.pink.shade300, NearbyScreen()), //yakındaki mekanların sayfasını eklemek için
              _buildCustomListTile(
                  context, "Concept Places", Icons.category, Colors.blue.shade300, CategoryPlaceScreen()),
              _buildCustomListTile(
                  context, "User Favorites", Icons.star, Colors.green.shade300, FavoritesPlacesScreen()),
              _buildCustomListTile(
                  context, "Random Adventure", Icons.casino, Colors.orange.shade300, RandomAdventureScreen()),
            ],
          ),
        ),
      ],
    );
  }

  // Tıklanınca yeni sayfa açar
  Widget _buildCustomListTile(BuildContext context, String title, IconData icon, Color bgColor, Widget targetScreen) {
    return Container( //yakındaki mekanların divleri
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