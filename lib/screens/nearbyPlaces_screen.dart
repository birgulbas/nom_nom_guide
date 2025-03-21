import 'package:flutter/material.dart';

class NearbyScreen extends StatelessWidget {
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
