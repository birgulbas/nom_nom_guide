import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nom_nom_guide/models/place.dart';
import 'package:nom_nom_guide/services/api_services.dart';
import 'package:nom_nom_guide/screens/places_screen.dart'; 

class RandomAdventureScreen extends StatefulWidget {
  const RandomAdventureScreen({super.key});

  @override
  State<RandomAdventureScreen> createState() => _RandomAdventureScreenState();
}

class _RandomAdventureScreenState extends State<RandomAdventureScreen> with SingleTickerProviderStateMixin {
  List<Place> places = [];
  Place? selectedPlace;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isSpinning = false;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 4 * pi)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _selectRandomPlace();
          setState(() {
            isSpinning = false;
          });
        }
      });
  }

  Future<void> _fetchPlaces() async {
    try {
      final fetchedPlaces = await ApiServices().getPlaces();
      setState(() {
        places = fetchedPlaces;
      });
    } catch (e) {
      print('Yerler alınamadı: $e');
    }
  }

  void _startSpin() {
    if (places.isEmpty) return;
    setState(() {
      selectedPlace = null;
      isSpinning = true;
    });
    _controller.reset();
    _controller.forward();
  }

  void _selectRandomPlace() {
    final random = Random();
    setState(() {
      selectedPlace = places[random.nextInt(places.length)];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override   
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.995), // arkaplan 
     appBar: AppBar(
  title: const Text('Random Adventure'),
  backgroundColor: Colors.pink.shade600, 
),

      body: Center(
        child: places.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Can not decide where to go?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'See where the compass will take you! ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    RotationTransition(
                      turns: _animation,
                      child: Image.asset(
                        'assets/compass.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: isSpinning ? null : _startSpin,
                      child: const Text('Turn the Compass!'),
                    ),
                    const SizedBox(height: 30),
                    if (selectedPlace != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceScreen(place: selectedPlace!),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Go here, have fun! 🎯',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  selectedPlace!.name,
                                  style: const TextStyle(fontSize: 24, color: Colors.blueAccent),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  selectedPlace!.location,
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text(
                                      selectedPlace!.rating.toStringAsFixed(1),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
