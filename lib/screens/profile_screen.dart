import 'package:flutter/material.dart';
import 'package:nom_nom_guide/screens/avatar_selection_screen.dart';
import 'package:nom_nom_guide/screens/userInfo_screen.dart';
import 'package:nom_nom_guide/screens/login_screen.dart';
import 'package:nom_nom_guide/screens/changePassword_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nom_nom_guide/services/api_services.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
      await fetchUserInfo();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back), color:Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("My Profiles"),
        backgroundColor: Colors.pink,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      body: isLoggedIn
          ? LoggedInView(
        avatarPath: avatarPath,
        username: username ?? '',
        onAvatarChanged: _saveAvatar,
      )
          : _buildLoggedOutView(context),
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Center(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade100,
              ),
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
    );
  }
}

class LoggedInView extends StatelessWidget {
  final String? avatarPath;
  final String username;
  final Function(String) onAvatarChanged;

  const LoggedInView({
    super.key,
    required this.avatarPath,
    required this.username,
    required this.onAvatarChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: GestureDetector(
            onTap: () async {
              final selectedAvatarPath = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (context) => AvatarSelectionScreen()),
              );
              if (selectedAvatarPath != null) {
                onAvatarChanged(selectedAvatarPath);
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orangeAccent,
              child: CircleAvatar(
                radius: 46,
                backgroundImage: AssetImage(avatarPath ?? 'assets/images/avatar1.png'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            username.isNotEmpty ? username : "Guest User",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        _buildTile(
          context,
          icon: Icons.lock_outline,
          text: "Change Password",
          color: Colors.teal.shade300,
          destination: const ChangePasswordScreen(),
        ),
        _buildTile(
          context,
          icon: Icons.info_outline,
          text: "My User Information",
          color: Colors.lightGreen,
          destination: const UserInfoScreen(),
        ),

        _buildTile(
          context,
          icon: Icons.logout,
          text: "Log Out",
          color: Colors.redAccent,
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

  Widget _buildTile(BuildContext context,
      {required IconData icon,
        required String text,
        Color? color,
        Widget? destination,
        VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.pink),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap ??
                () {
              if (destination != null) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
              }
            },
      ),
    );
  }
}
