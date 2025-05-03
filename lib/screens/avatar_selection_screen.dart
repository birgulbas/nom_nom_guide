import 'package:flutter/material.dart';

class AvatarSelectionScreen extends StatelessWidget {
  AvatarSelectionScreen({super.key});

  final List<String> avatarPaths = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
    'assets/images/avatar6.png',
    'assets/images/avatar7.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Avatar'), backgroundColor:Colors.lightBlueAccent,),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: avatarPaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, avatarPaths[index]);
            },
            child: CircleAvatar(
              backgroundImage: AssetImage(avatarPaths[index]),
              radius: 40,
            ),
          );
        },
      ),
    );
  }
}
