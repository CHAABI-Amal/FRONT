import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light Mode';

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    Navigator.of(context).pop();
  }

  void _changeTheme(String theme) {
    setState(() {
      _selectedTheme = theme;
    });
    Navigator.of(context).pop();
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Delete Account',
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: GoogleFonts.poppins(
              color: Colors.grey,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Ajoutez ici la logique pour supprimer le compte
                Navigator.of(context).pop(); // Retournez à l'écran précédent
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingOption(
              icon: Icons.language,
              iconColor: Colors.purple,
              title: 'Language',
              value: _selectedLanguage,
              onTap: _showLanguagePicker,
            ),
            _buildSettingOption(
              icon: Icons.brightness_6,
              iconColor: Colors.grey,
              title: 'Light/Dark Mode',
              value: _selectedTheme,
              onTap: _showThemePicker,
            ),
            SizedBox(height: 20),
            _buildDeleteAccountOption(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.black,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.black),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDeleteAccountOption() {
    return ListTile(
      leading: Icon(Icons.delete, color: Colors.red),
      title: Text(
        'Delete Account',
        style: GoogleFonts.poppins(
          color: Colors.black,
        ),
      ),
      onTap: _deleteAccount,
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'English',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () => _changeLanguage('English'),
            ),
            ListTile(
              title: Text(
                'Français',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () => _changeLanguage('Français'),
            ),
            ListTile(
              title: Text(
                'العربية',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () => _changeLanguage('العربية'),
            ),
          ],
        );
      },
    );
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Light Mode',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () => _changeTheme('Light Mode'),
            ),
            ListTile(
              title: Text(
                'Dark Mode',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () => _changeTheme('Dark Mode'),
            ),
          ],
        );
      },
    );
  }
}
