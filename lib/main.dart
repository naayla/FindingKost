import 'package:flutter/material.dart';

void main() {
runApp(const FindingKostApp());
}

class FindingKostApp extends StatelessWidget {
const FindingKostApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Finding Kost',
theme: ThemeData(
primarySwatch: Colors.blue,
scaffoldBackgroundColor: const Color(0xFFF5F5F5),
),
home: const LoginScreen(),
);
}
}

// ==========================================
// 1. LAYAR LOGIN
// ==========================================

class LoginScreen extends StatelessWidget {
const LoginScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const Icon(
Icons.home_work_rounded,
size: 80,
color: Colors.blue,
),

const SizedBox(height: 16),

const Text(
'Finding Kost',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),

const SizedBox(height: 8),

const Text(
'Temukan tempat kos impianmu dengan mudah',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey,
fontSize: 14,
),
),

const SizedBox(height: 36),

// EMAIL
TextField(
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
labelText: 'Email',
hintText: 'Masukkan email anda',
prefixIcon: const Icon(Icons.email_outlined),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
filled: true,
fillColor: Colors.white,
),
),

const SizedBox(height: 16),

// PASSWORD
TextField(
obscureText: true,
decoration: InputDecoration(
labelText: 'Kata Sandi',
hintText: 'Masukkan kata sandi',
prefixIcon: const Icon(Icons.lock_outline),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
filled: true,
fillColor: Colors.white,
),
),

const SizedBox(height: 24),

// TOMBOL MASUK
ElevatedButton(
onPressed: () {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => const HomeScreen(),
),
);
},
style: ElevatedButton.styleFrom(
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: const Text(
'Masuk',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),

const SizedBox(height: 16),

// LINK DAFTAR
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text('Belum punya akun? '),

InkWell(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const RegisterScreen(),
),
);
},
child: const Text(
'Daftar Sekarang',
style: TextStyle(
color: Colors.blue,
fontWeight: FontWeight.bold,
),
),
),
],
),
],
),
),
),
),
);
}
}

// ==========================================
// 2. LAYAR REGISTER
// ==========================================

class RegisterScreen extends StatelessWidget {
const RegisterScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Buat Akun Baru'),
elevation: 0,
),

body: SingleChildScrollView(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const Text(
'Daftar Akun',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),

const SizedBox(height: 8),

const Text(
'Lengkapi data di bawah ini untuk mendaftar',
style: TextStyle(color: Colors.grey),
),

const SizedBox(height: 24),

// NAMA LENGKAP
TextField(
decoration: InputDecoration(
labelText: 'Nama Lengkap',
prefixIcon: const Icon(Icons.person_outline),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
filled: true,
fillColor: Colors.white,
),
),

const SizedBox(height: 16),

// EMAIL
TextField(
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
labelText: 'Email',
prefixIcon: const Icon(Icons.email_outlined),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
filled: true,
fillColor: Colors.white,
),
),

const SizedBox(height: 16),

// PASSWORD
TextField(
obscureText: true,
decoration: InputDecoration(
labelText: 'Kata Sandi',
prefixIcon: const Icon(Icons.lock_outline),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
filled: true,
fillColor: Colors.white,
),
),

const SizedBox(height: 24),

// DAFTAR
ElevatedButton(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Pendaftaran Berhasil! Silakan Login.',
),
),
);

Navigator.pop(context);
},
style: ElevatedButton.styleFrom(
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: const Text(
'Daftar',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
],
),
),
);
}
}

// ==========================================
// 3. LAYAR BERANDA
// ==========================================

class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

void _showLogoutDialog(BuildContext context) {
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: const Text('Konfirmasi Logout'),
content: const Text(
'Apakah Anda yakin ingin keluar dari akun?',
),
actions: [
TextButton(
onPressed: () {
Navigator.of(context).pop();
},
child: const Text('Batal'),
),

ElevatedButton(
onPressed: () {
Navigator.of(context).pop();

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (context) => const LoginScreen(),
),
(route) => false,
);
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red,
),
child: const Text(
'Logout',
style: TextStyle(color: Colors.white),
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
appBar: AppBar(
title: const Text(
'Finding Kost',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
elevation: 0,

actions: [
// NOTIFIKASI
IconButton(
icon: const Icon(Icons.notifications_none),
onPressed: () {},
),

// LOGOUT
IconButton(
icon: const Icon(Icons.logout),
tooltip: 'Logout',
onPressed: () {
_showLogoutDialog(context);
},
),
],
),

// ==========================================
// BAGIAN INI BISA DI-SCROLL
// ==========================================

body: ListView(
padding: const EdgeInsets.all(16.0),
children: [
// SEARCH
TextField(
decoration: InputDecoration(
hintText: 'Cari nama kos atau lokasi...',
prefixIcon: const Icon(Icons.search),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
filled: true,
fillColor: Colors.white,
),
),

const SizedBox(height: 12),

// ==========================================
// TOMBOL LOKASI + FILTER
// ==========================================

Row(
children: [
Expanded(
child: ElevatedButton.icon(
onPressed: () {},
icon: const Icon(
Icons.my_location,
size: 18,
),
label: const Text(
'Search by Location',
),
style: ElevatedButton.styleFrom(
padding: const EdgeInsets.symmetric(
vertical: 12,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
),
),

const SizedBox(width: 8),

OutlinedButton.icon(
onPressed: () {},
icon: const Icon(
Icons.filter_alt_outlined,
size: 18,
),
label: const Text('Filter'),
style: OutlinedButton.styleFrom(
padding: const EdgeInsets.symmetric(
vertical: 12,
horizontal: 12,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
),
],
),

const SizedBox(height: 20),

// ==========================================
// JUDUL
// ==========================================

const Text(
'Rekomendasi Kos Terdekat',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

// ==========================================
// KOS 1
// ==========================================

KostCard(
imageUrl:
'https://images.unsplash.com/photo-1560185008-b033106af5c3?w=800',
nama: 'Kos Bahagia Medan',
lokasi:
'Kec. Medan Baru • 500m dari lokasi',
harga: 'Rp 850.000 / bulan',
rating: '4.8',
),

// ==========================================
// KOS 2
// ==========================================

KostCard(
imageUrl:
'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
nama: 'Kost Putri Harmoni',
lokasi:
'Kec. Medan Selayang • 1.2km dari lokasi',
harga: 'Rp 750.000 / bulan',
rating: '4.7',
),

// ==========================================
// KOS 3
// ==========================================

KostCard(
imageUrl:
'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800',
nama: 'Kost Nyaman Residence',
lokasi:
'Kec. Medan Kota • 1.5km dari lokasi',
harga: 'Rp 950.000 / bulan',
rating: '4.9',
),

// ==========================================
// KOS 4
// ==========================================

KostCard(
imageUrl:
'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
nama: 'Kost Mahasiswa Medan',
lokasi:
'Kec. Medan Petisah • 2km dari lokasi',
harga: 'Rp 700.000 / bulan',
rating: '4.6',
),

// ==========================================
// KOS 5
// ==========================================

KostCard(
imageUrl:
'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800',
nama: 'Kost Sejahtera',
lokasi:
'Kec. Medan Denai • 2.5km dari lokasi',
harga: 'Rp 800.000 / bulan',
rating: '4.7',
),

// ==========================================
// KOS 6
// ==========================================

KostCard(
imageUrl:
'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
nama: 'Kost Nyaman Bersama',
lokasi:
'Kec. Medan Amplas • 3km dari lokasi',
harga: 'Rp 900.000 / bulan',
rating: '4.8',
),

const SizedBox(height: 20),

const Center(
child: Text(
'Tidak ada kos lainnya',
style: TextStyle(
color: Colors.grey,
),
),
),

const SizedBox(height: 30),
],
),
);
}
}

// ==========================================
// 4. WIDGET KARTU KOS
// ==========================================

class KostCard extends StatelessWidget {
final String imageUrl;
final String nama;
final String lokasi;
final String harga;
final String rating;

const KostCard({
super.key,
required this.imageUrl,
required this.nama,
required this.lokasi,
required this.harga,
required this.rating,
});

@override
Widget build(BuildContext context) {
return Card(
margin: const EdgeInsets.only(bottom: 16),

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),

elevation: 2,

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// ==========================================
// FOTO KOS
// ==========================================

ClipRRect(
borderRadius: const BorderRadius.vertical(
top: Radius.circular(12),
),

child: Image.network(
imageUrl,

height: 170,
width: double.infinity,

fit: BoxFit.cover,

// Jika gambar gagal dimuat
errorBuilder: (
context,
error,
stackTrace,
) {
return Container(
height: 170,
color: Colors.grey[300],

child: const Center(
child: Icon(
Icons.home_work,
size: 50,
color: Colors.grey,
),
),
);
},
),
),

// ==========================================
// INFORMASI KOS
// ==========================================

Padding(
padding: const EdgeInsets.all(12.0),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
// NAMA KOS + RATING
Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Expanded(
child: Text(
nama,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),

Row(
children: [
const Icon(
Icons.star,
color: Colors.amber,
size: 16,
),

Text(
' $rating',
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
],
),
],
),

const SizedBox(height: 5),

// LOKASI
Text(
lokasi,
style: const TextStyle(
color: Colors.grey,
fontSize: 13,
),
),

const SizedBox(height: 8),

// HARGA
Text(
harga,
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),

const SizedBox(height: 10),

// TOMBOL DETAIL
SizedBox(
width: double.infinity,
child: OutlinedButton(
onPressed: () {},
child: const Text(
'Lihat Detail',
),
),
),
],
),
),
],
),
);
}
}