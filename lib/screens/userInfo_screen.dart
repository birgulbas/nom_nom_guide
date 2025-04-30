import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nom_nom_guide/services/api_services.dart'; // <-- BURASI ÖNEMLİ

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // API'den kullanıcı bilgilerini çek
    final api = ApiServices();
    final userInfo = await api.getUserInfo();

    if (userInfo != null) {
      setState(() {
        firstNameController.text = userInfo['first_name'] ?? '';
        lastNameController.text = userInfo['last_name'] ?? '';
        usernameController.text = userInfo['username'] ?? '';
        emailController.text = userInfo['email'] ?? '';
      });

      // Bilgileri SharedPreferences'a da kaydet
      await prefs.setString('firstName', userInfo['first_name'] ?? '');
      await prefs.setString('lastName', userInfo['last_name'] ?? '');
      await prefs.setString('username', userInfo['username'] ?? '');
      await prefs.setString('email', userInfo['email'] ?? '');
    } else {
      // Eğer API'den alamadıysa, SharedPreferences'tan oku
      setState(() {
        firstNameController.text = prefs.getString('firstName') ?? '';
        lastNameController.text = prefs.getString('lastName') ?? '';
        usernameController.text = prefs.getString('username') ?? '';
        emailController.text = prefs.getString('email') ?? '';
      });
    }
  }

  Future<void> _saveUserInfo() async {
    final api = ApiServices();
    bool success = await api.updateUserInfo(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
      email: emailController.text,
    );

    if (success) {
      // API'ye kaydettikten sonra lokal SharedPreferences'a da kaydedelim
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', firstNameController.text);
      await prefs.setString('lastName', lastNameController.text);
      await prefs.setString('username', usernameController.text);
      await prefs.setString('email', emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update information.')),
      );
      // İstersen burada sunucuya PATCH isteği atıp server'da da güncelleyebilirsin
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My User Information"),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Surname'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                onPressed: _saveUserInfo,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
