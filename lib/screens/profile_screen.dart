import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nom_nom_guide/screens/avatar_selection_screen.dart';
import 'package:nom_nom_guide/screens/my_comments_screen.dart';
import 'package:nom_nom_guide/screens/my_ratings_screen.dart';
import 'package:nom_nom_guide/screens/userInfo_screen.dart';
import 'package:nom_nom_guide/screens/login_screen.dart';
import 'package:nom_nom_guide/screens/changePassword_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nom_nom_guide/services/api_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? avatarPath;
  bool isLoggedIn = false;
  String? username;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadAvatar();
    _loadUsername();
    fetchUserInfo();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');
    setState(() {
      isLoggedIn = loggedIn ?? false;
    });
  }

  Future<void> _loadAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      avatarPath = prefs.getString('avatarPath') ?? 'assets/images/avatar1.png';
    });
  }

  Future<void> _saveAvatar(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarPath', path);
    setState(() {
      avatarPath = path;
    });
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });

    if (username == null) {
      await fetchUserInfo();  // Eğer localde username yoksa API'den çek
    }
  }

  Future<void> fetchUserInfo() async {
    final api = ApiServices();
    final userInfo = await api.getUserInfo();
    if (userInfo != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', userInfo['username']);
      setState(() {
        username = userInfo['username'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.pink,
      ),
      body: isLoggedIn
          ? LoggedInView(
        avatarPath: avatarPath,
        username: username ?? '',
        onAvatarChanged: _saveAvatar,
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text("Do you have an account?", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text("Sign In / Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoggedInView extends StatelessWidget {
  final String? avatarPath;
  final String username;
  final Function(String) onAvatarChanged;

  const LoggedInView({
    Key? key,
    required this.avatarPath,
    required this.username,
    required this.onAvatarChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GestureDetector(
          onTap: () async {
            final selectedAvatarPath = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) => AvatarSelectionScreen(),
              ),
            );
            if (selectedAvatarPath != null) {
              onAvatarChanged(selectedAvatarPath);
            }
          },
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade300,
            child: ClipOval(
              child: Image.asset(
                avatarPath ?? 'assets/images/avatar1.png',
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            username.isNotEmpty ? username : "Guest User",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 40),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text("Change Password"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text("My User Information"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserInfoScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text("My Comments"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyCommentsScreen(username: username)),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.star_border),
          title: const Text("My Ratings"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyRatingsScreen(username: username)),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Log Out"),
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', false);
            await prefs.remove('username');
            await prefs.remove('avatarPath');

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );


  }
}
