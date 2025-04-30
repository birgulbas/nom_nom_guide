import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English'];

  void _changeLanguage(String? newLang) {
    if (newLang != null) {
      setState(() {
        _selectedLanguage = newLang;
      });
    }
  }

  void _openFeedbackDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Feedback"),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(hintText: "Write your problem or feedback."),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Send"),
            onPressed: () {
              // Feedback işleme kısmı
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Your feedback has been sent!")),
              );
            },
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Support"),
        content: Text("If you encounter any problems, you can reach us at:\n\nsupport@nomnomguide.com"),
        actions: [
          TextButton(
            child: Text("Okay"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget buildSettingsCard({required IconData icon, required String title, Widget? trailing, VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.pink,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        children: [
          buildSettingsCard(
            icon: Icons.language,
            title: "Language Selection",
            trailing: Text(_selectedLanguage),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return ListView(
                    children: _languages.map((lang) {
                      return RadioListTile(
                        title: Text(lang),
                        value: lang,
                        groupValue: _selectedLanguage,
                        onChanged: (val) {
                          _changeLanguage(val);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 2,
            child: SwitchListTile(
              title: Text("Open Notifications", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              secondary: Icon(Icons.notifications, color: Colors.pink),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  _notificationsEnabled = val;
                });
              },
            ),
          ),
          buildSettingsCard(
            icon: Icons.feedback,
            title: "Feedback",
            onTap: _openFeedbackDialog,
          ),
          buildSettingsCard(
            icon: Icons.support_agent,
            title: "Support",
            onTap: _contactSupport,
          ),
        ],
      ),
    );
  }
}
