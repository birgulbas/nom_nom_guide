import 'package:flutter/material.dart';

class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Places")),
      body: Center(
        child: Text("Yakındaki mekanlar burada listelenecek."),
      ),
    );
  }
}
