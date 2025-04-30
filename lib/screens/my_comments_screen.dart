import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyCommentsScreen extends StatefulWidget {
  final String username;

  const MyCommentsScreen({super.key, required this.username});

  @override
  State<MyCommentsScreen> createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends State<MyCommentsScreen> {
  List<dynamic> userComments = [];

  @override
  void initState() {
    super.initState();
    _fetchUserComments();
  }

  Future<void> _fetchUserComments() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/comments/${widget.username}/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        userComments = json.decode(response.body);
      });
    } else {
      // hata kontrolü
      print('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Comments'),
        backgroundColor: Colors.grey,
      ),
      body: userComments.isEmpty
          ? Center(child: Text('You have not made any comments yet.'))
          : ListView.builder(
        itemCount: userComments.length,
        itemBuilder: (context, index) {
          final comment = userComments[index];
          return ListTile(
            leading: Icon(Icons.comment),
            title: Text(comment['place_name']),
            subtitle: Text(comment['comment_text']),
          );
        },
      ),
    );
  }
}

