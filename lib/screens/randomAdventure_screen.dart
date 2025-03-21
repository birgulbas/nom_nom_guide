import 'package:flutter/material.dart';

class RandomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Random Adventure")),
      body: Center(
        child: Text("Rastgele bir kafe önerisi burada olacak."),
      ),
    );
  }
}
