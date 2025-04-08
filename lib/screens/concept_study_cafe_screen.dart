import 'package:flutter/material.dart';

class ConceptStudyCafeScreen extends StatelessWidget {
  const ConceptStudyCafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Cafes"),
        backgroundColor:Colors.pink.shade600,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCafeCard(
            context,
            title: "study & Coffee",
            description: "school things",
            imagePath: "assets/images/workshop1.jpg",
          ),
          _buildCafeCard(
            context,
            title: "Study cafe",
            description: "çalış",
            imagePath: "assets/images/workshop2.jpg",
          ),
          _buildCafeCard(
            context,
            title: "çalış kafe",
            description: "derssss",
            imagePath: "assets/images/workshop3.jpg",
          ),
        ],
      ),
    );
  }

  Widget _buildCafeCard(BuildContext context, {
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
