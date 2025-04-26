import 'package:flutter/material.dart';
import 'map_screen.dart'; 

class NearbyScreen extends StatelessWidget {
  const NearbyScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("near by places")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapScreen()),
            );
          },
          child: const Text("show the map"),
        ),
      ),
    );
  }
}
