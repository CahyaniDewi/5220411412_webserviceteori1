import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/avatar.jpeg'), // Gambar avatar dari assets
            ),
            SizedBox(height: 16),
            Text(
              'NI MADE CAHYANI DEWI', 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              ' Universitas Teknologi Yogyakarta', 
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aksi lain jika diperlukan
              },
              child: Text('Edit Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Setel warna latar belakang tombol
              ),
            ),
          ],
        ),
      ),
    );
  }
}
