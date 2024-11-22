import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'card_id_page.dart';
import 'community_proof_page.dart';
import 'photo_upload_page.dart';

class OnlineRegistrations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Online Registration",
          style: GoogleFonts.poppins(
            color: Colors.black, // Couleur du titre
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Couleur de l'icône retour
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0, // Retirer l'ombre
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOptionCard(
              context,
              title: 'Card ID',
              isVerified: true, // Changez cette valeur pour tester
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CardIDPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildOptionCard(
              context,
              title: 'Preuve de Communauté',
              isVerified: true, // Changez cette valeur pour tester
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunityProofPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildOptionCard(
              context,
              title: 'Photo',
              isVerified: true, // Changez cette valeur pour tester
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotoUploadPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required String title, required bool isVerified, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white, // Couleur de fond de la carte
        elevation: 5, // Ombre de la carte
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Couleur du texte du titre
            ),
          ),
          subtitle: Text(
            isVerified ? 'Verified' : 'Unverified',
            style: TextStyle(
              color: isVerified ? Colors.green : Colors.grey, // Couleur selon le statut
              fontWeight: isVerified ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.black), // Couleur de l'icône
        ),
      ),
    );
  }
}
