import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nayla Syifa Tanjung',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Mahasiswa Ilmu Komputer / Persona Utama',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Card(
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.teal),
                title: Text('Email'),
                subtitle: Text('nayla@example.com'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.school, color: Colors.teal),
                title: Text('Institusi'),
                subtitle: Text('Universitas Sumatera Utara'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}