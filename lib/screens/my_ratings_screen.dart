import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyRatingsScreen extends StatefulWidget {
  final String username;

  const MyRatingsScreen({super.key, required this.username});

  @override
  State<MyRatingsScreen> createState() => _MyRatingsScreenState();
}

class _MyRatingsScreenState extends State<MyRatingsScreen> {
  List<dynamic> userRatings = [];

  @override
  void initState() {
    super.initState();
    _fetchUserRatings();
  }

  Future<void> _fetchUserRatings() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/ratings/${widget.username}/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        userRatings = json.decode(response.body);
      });
    } else {
      // hata kontrolü
      print('Failed to load ratings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Ratings'),
        backgroundColor: Colors.grey,
      ),
      body: userRatings.isEmpty
          ? Center(child: Text('You have not rated any places yet.'))
          : ListView.builder(
        itemCount: userRatings.length,
        itemBuilder: (context, index) {
          final rating = userRatings[index];
          return ListTile(
            leading: Icon(Icons.star, color: Colors.yellow[700]),
            title: Text(rating['place_name']),
            subtitle: Text('Rating: ${rating['rating']} ⭐'),
          );
        },
      ),
    );
  }
}

