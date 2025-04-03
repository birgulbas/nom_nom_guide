import 'package:flutter/material.dart';
import 'package:nom_nom_guide/screens/concept_book_cafe_screen.dart';
import 'package:nom_nom_guide/screens/concept_breakfast_place_screen.dart';
import 'package:nom_nom_guide/screens/concept_cozy_place_screen.dart';
import 'package:nom_nom_guide/screens/concept_dessert_shop_patisserie_screen.dart';
import 'package:nom_nom_guide/screens/concept_fast_food_screen.dart';
import 'package:nom_nom_guide/screens/concept_luxury_cafe_screen.dart';
import 'package:nom_nom_guide/screens/concept_music_cafe_screen.dart';
import 'package:nom_nom_guide/screens/concept_outdoor_place_screen.dart';
import 'package:nom_nom_guide/screens/concept_pet_friendly_cafe_screen.dart';
import 'package:nom_nom_guide/screens/concept_study_cafe_screen.dart';
import 'package:nom_nom_guide/screens/concept_themed_cafe_screen.dart';
import 'package:nom_nom_guide/screens/concept_vegan_friendly_cafe_screen.dart';
import 'package:nom_nom_guide/screens/concept_family_cafe_screen.dart';
import 'package:nom_nom_guide/screens/concept_romantic_place_screen.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class ConceptScreen extends StatefulWidget {
  @override
  _ConceptScreenState createState() => _ConceptScreenState();
}

class _ConceptScreenState extends State<ConceptScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    Widget? nextPage;

    switch (index) {
      case 0:
        nextPage = HomeScreen();
        break;
      case 1:
        nextPage = FavoritesScreen();
        break;
      case 2:
        nextPage = ProfileScreen();
        break;
      case 3:
        nextPage = SettingsScreen();
        break;
    }

    if (nextPage != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade100,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Concept Places',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildConceptTile(context, "Study Cafes", Icons.menu_book, Colors.orange.shade300, ConceptStudyCafeScreen()),
                _buildConceptTile(context, "Family Cafes", Icons.family_restroom, Colors.green.shade300, ConceptFamilyCafeScreen()),
                _buildConceptTile(context, "Romantic Places", Icons.favorite, Colors.pink.shade300, ConceptRomanticPlaceScreen()),
                _buildConceptTile(context, "Luxury Cafe", Icons.emoji_events, Colors.deepPurple.shade300, ConceptLuxuryCafeScreen()),
                _buildConceptTile(context, "Outdoor Place", Icons.park, Colors.teal.shade300, ConceptOutdoorPlaceScreen()),
                _buildConceptTile(context, "Vegan Friendly Cafe", Icons.eco, Colors.lightGreen.shade400, ConceptVeganFriendlyCafeScreen()),
                _buildConceptTile(context, "Pet Friendly Cafe", Icons.pets, Colors.cyan.shade400, ConceptPetFriendlyCafeScreen()),
                _buildConceptTile(context, "Breakfast Places", Icons.breakfast_dining, Colors.brown.shade300, ConceptBreakfastPlaceScreen()),
                _buildConceptTile(context, "Dessert Shop / Patisserie", Icons.cake, Colors.purple.shade300, ConceptDessertShopPatisserieScreen()),
                _buildConceptTile(context, "Book Cafe", Icons.book, Colors.indigo.shade300, ConceptBookCafeScreen()),
                _buildConceptTile(context, "Cozy Places", Icons.spa, Colors.red.shade200, ConceptCozyPlaceScreen()),
                _buildConceptTile(context, "Fast Food", Icons.fastfood, Colors.amber.shade600, ConceptFastFoodScreen()),
                _buildConceptTile(context, "Themed Cafe", Icons.brush, Colors.blue.shade300, ConceptThemedCafeScreen()),
                _buildConceptTile(context, "Music Cafe", Icons.music_note, Colors.deepOrange.shade200, ConceptMusicCafeScreen()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.pink.shade600,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HomePage'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildConceptTile(BuildContext context, String title, IconData icon, Color color, Widget targetPage) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
      ),
    );
  }
}