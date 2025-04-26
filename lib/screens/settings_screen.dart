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
        title: Text("FeedBack"),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(hintText: "Write your problem or feedback."),
        ),
        actions: [
          TextButton(
            child: Text("cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Send"),
            onPressed: () {
              // Burada API ya da mail gönderimi yapılabilir
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
    // Destek kısmı - Örneğin e-posta uygulamasını aç
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Support"),
        content: Text("If you encounter any problems, you can reach us at:\n\nsupport@nomnomguide.com"),
        actions: [
          TextButton(
            child: Text("okay"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"), backgroundColor: Colors.pink,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language selection"),
            subtitle: Text(_selectedLanguage),
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
          SwitchListTile(
            title: Text("Open Notifications"),
            secondary: Icon(Icons.notifications),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text("FeedBack"),
            onTap: _openFeedbackDialog,
          ),
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text("Support"),
            onTap: _contactSupport,
          ),
        ],
      ),
    );
  }
}
