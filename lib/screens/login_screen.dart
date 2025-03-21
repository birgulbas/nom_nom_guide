// screens/login_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Profili'),
      ),
      body: Center(
        child: Text(
          'Kullanıcı Profili Sayfası',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}