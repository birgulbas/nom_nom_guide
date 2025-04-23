import 'package:flutter/material.dart';
import 'login_screen.dart';


class ProfileScreen extends StatelessWidget {
  final bool isLoggedIn = false;

  const ProfileScreen({super.key}); // TODO: Gerçek auth sistemine bağla

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profiles"),
        centerTitle: true,
      ),
      body: isLoggedIn ? LoggedInView() : NotLoggedInView(),
    );
  }
}

class NotLoggedInView extends StatelessWidget {
  const NotLoggedInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text("Do you have an account?", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => (LoginScreen())),
                );
              },
              child: Text("Sign In/Sing Up"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoggedInView extends StatelessWidget {
  const LoggedInView({super.key});


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("assets/images/profile_pic.png"),
        ),
        SizedBox(height: 12),
        Divider(height: 40),
        ListTile(
          leading: Icon(Icons.lock_outline),
          title: Text("Change Password"),
          onTap: () {
            Navigator.pushNamed(context, "/change-password");
          },
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("My User Information"),
          onTap: () {
            Navigator.pushNamed(context, "/user-info");
          },
        ),
        ListTile(
          leading: Icon(Icons.comment),
          title: Text("My Comments"),
          onTap: () {
            Navigator.pushNamed(context, "/my-comments");
          },
        ),
        ListTile(
          leading: Icon(Icons.star_border),
          title: Text("My Ratings"),
          onTap: () {
            Navigator.pushNamed(context, "/my-ratings");
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Log out"),
          onTap: () {
            // logout işlemi (auth sistemine bağlı)
          },
        ),
      ],
    );
  }
}
