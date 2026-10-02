import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/kost_model.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // --- USER STATE & ROLE ---
  UserModel _currentUser = UserModel(
    id: 'user_seeker_1',
    name: 'Nayla Syifa Tanjung',
    email: 'nayla@example.com',
    phone: '+62 812 3456 7890',
    role: UserRole.pencariKost,
    institutionOrBusiness: 'Universitas Sumatera Utara',
  );

  UserModel get currentUser => _currentUser;
  UserRole get currentRole => _currentUser.role;
  bool get isOwner => _currentUser.role == UserRole.pemilikKost;
  bool get isSeeker => _currentUser.role == UserRole.pencariKost;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setRole(UserRole role) {
    _currentUser = _currentUser.copyWith(role: role);
    notifyListeners();
  }

  void updateProfile({String? name, String? email, String? phone, String? institutionOrBusiness}) {
    _currentUser = _currentUser.copyWith(
      name: name,
      email: email,
      phone: phone,
      institutionOrBusiness: institutionOrBusiness,
    );
    notifyListeners();
  }

  // --- FAVORITES (UNTUK PENCARI KOST) ---
  final List<String> _favoriteKostIds = ['1', '4', '9'];

  List<String> get favoriteKostIds => _favoriteKostIds;

  bool isFavorite(String id) => _favoriteKostIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteKostIds.contains(id)) {
      _favoriteKostIds.remove(id);
    } else {
      _favoriteKostIds.add(id);
    }
    notifyListeners();
  }

  List<Kost> get favoriteKosts {
    return _kostList.where((k) => _favoriteKostIds.contains(k.id)).toList();
  }

  // --- CATEGORIES (MINIMAL 5 REFERENSI) ---
  final List<Category> _categories = [
    Category(id: 'cat_1', name: 'Putri', iconName: 'female'),
    Category(id: 'cat_2', name: 'Putra', iconName: 'male'),
    Category(id: 'cat_3', name: 'Campur', iconName: 'people'),
    Category(id: 'cat_4', name: 'Eksklusif', iconName: 'star'),
    Category(id: 'cat_5', name: 'Bebas 24 Jam', iconName: 'access_time'),
  ];

  List<Category> get categories => _categories;

  // --- KOST LIST (MINIMAL 20 DATA DENGAN KOORDINAT GOOGLE MAPS DI MEDAN) ---
  final List<Kost> _kostList = [
    Kost(
      id: '1',
      categoryId: 'cat_1',
      title: 'Kos Bahagia Medan Baru',
      location: 'Jl. Dr. Mansyur, Kec. Medan Baru',
      price: 'Rp 850.000 / bulan',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1554995207-c18c203602cb?q=80&w=600',
      latitude: 3.5651,
      longitude: 98.6538,
      facilities: ['WiFi', 'Kamar Mandi Dalam', 'AC', 'Kasur', 'Lemari', 'Parkir'],
      ownerId: 'owner_1',
      ownerName: 'H. Rahmad S.T.',
      ownerPhone: '+6281234567890',
      description: 'Kos khusus putri aman 24 jam dengan gerbang terunci. Berada sangat dekat dengan pintu masuk USU Medan.',
      isAvailable: true,
    ),
    Kost(
      id: '2',
      categoryId: 'cat_1',
      title: 'Kost Putri Harmoni',
      location: 'Jl. Setiabudi, Kec. Medan Selayang',
      price: 'Rp 750.000 / bulan',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=600',
      latitude: 3.5592,
      longitude: 98.6472,
      facilities: ['WiFi', 'Kasur', 'Lemari', 'Meja Belajar', 'Dapur Bersama'],
      ownerId: 'user_owner_1',
      ownerName: 'Ibu Hj. Aminah',
      ownerPhone: '+6281398765432',
      description: 'Lingkungan asri, tenang, sangat cocok untuk mahasiswa yang butuh suasana fokus belajar.',
      isAvailable: true,
    ),
    Kost(
      id: '3',
      categoryId: 'cat_2',
      title: 'Kost Mahasiswa Medan Petisah',
      location: 'Jl. Gatot Subroto, Kec. Medan Petisah',
      price: 'Rp 700.000 / bulan',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=600',
      latitude: 3.5910,
      longitude: 98.6650,
      facilities: ['WiFi', 'Parkir Motor Luas', 'Kasur', 'Lemari'],
      ownerId: 'owner_2',
      ownerName: 'Bpk. Hendra Kurniawan',
      ownerPhone: '+6285211223344',
      description: 'Kos putra praktis dekat kawasan bisnis dan angkutan umum kota Medan.',
      isAvailable: true,
    ),
    Kost(
      id: '4',
      categoryId: 'cat_4',
      title: 'Grand Residence Executive',
      location: 'Jl. Babura, Kec. Medan Baru',
      price: 'Rp 1.800.000 / bulan',
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=600',
      latitude: 3.5780,
      longitude: 98.6601,
      facilities: ['Smart TV', 'AC', 'Water Heater', 'Kamar Mandi Dalam', 'Kulkas', 'WiFi Super Cepat', 'Parkir Mobil'],
      ownerId: 'user_owner_1',
      ownerName: 'Ibu Hj. Aminah',
      ownerPhone: '+6281398765432',
      description: 'Kos eksklusif bergaya hotel bintang 3 lengkap dengan layanan kebersihan kamar mingguan.',
      isAvailable: true,
    ),
    Kost(
      id: '5',
      categoryId: 'cat_3',
      title: 'Kost Melati Campur',
      location: 'Jl. Aksara, Kec. Medan Tembung',
      price: 'Rp 650.000 / bulan',
      rating: 4.4,
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=600',
      latitude: 3.5980,
      longitude: 98.7010,
      facilities: ['Kamar Mandi Dalam', 'Kasur', 'Lemari', 'CCTV 24 Jam'],
      ownerId: 'owner_3',
      ownerName: 'Ibu Sinta',
      ownerPhone: '+6282165430099',
      description: 'Akses mudah ke pusat perbelanjaan dan stasiun kereta api Medan.',
      isAvailable: true,
    ),
    Kost(
      id: '6',
      categoryId: 'cat_5',
      title: 'Kost Freedom 24 Jam',
      location: 'Jl. Sunggal, Kec. Medan Sunggal',
      price: 'Rp 900.000 / bulan',
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=600',
      latitude: 3.5822,
      longitude: 98.6321,
      facilities: ['Akses Kunci Digital 24 Jam', 'WiFi', 'AC', 'Kasur Springbed', 'Laundry Bag'],
      ownerId: 'user_owner_1',
      ownerName: 'Ibu Hj. Aminah',
      ownerPhone: '+6281398765432',
      description: 'Akses gerbang mandiri 24 jam dengan sistem pin digital, cocok untuk pekerja shift.',
      isAvailable: true,
    ),
    Kost(
      id: '7',
      categoryId: 'cat_1',
      title: 'Kost Anggrek Asri Putri',
      location: 'Jl. SM Raja, Kec. Medan Kota',
      price: 'Rp 800.000 / bulan',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?q=80&w=600',
      latitude: 3.5700,
      longitude: 98.6850,
      facilities: ['WiFi', 'Kamar Mandi Dalam', 'Dapur', 'Balkon Atas'],
      ownerId: 'owner_4',
      ownerName: 'Bpk. Drs. Subagyo',
      ownerPhone: '+6281277889900',
      description: 'Dekat dengan Masjid Raya Medan dan Istana Maimun, area tenang dan bersih.',
      isAvailable: true,
    ),
    Kost(
      id: '8',
      categoryId: 'cat_2',
      title: 'Kost Putra Perjuangan',
      location: 'Jl. Prof. HM Yamin, Kec. Medan Perjuangan',
      price: 'Rp 720.000 / bulan',
      rating: 4.3,
      imageUrl: 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?q=80&w=600',
      latitude: 3.6012,
      longitude: 98.6880,
      facilities: ['WiFi', 'Kasur', 'Lemari', 'Parkir Motor Terpadu'],
      ownerId: 'owner_5',
      ownerName: 'Bpk. Faisal',
      ownerPhone: '+6285399887766',
      description: 'Sangat hemat untuk mahasiswa Unimed / UINSU dengan tempat tidur nyaman.',
      isAvailable: true,
    ),
    Kost(
      id: '9',
      categoryId: 'cat_4',
      title: 'Royal Family Kost Exclusif',
      location: 'Jl. Polonia, Kec. Medan Polonia',
      price: 'Rp 2.200.000 / bulan',
      rating: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=600',
      latitude: 3.5580,
      longitude: 98.6720,
      facilities: ['Kolam Renang Mini', 'Gym Access', 'AC', 'Water Heater', 'Smart Lock', 'Room Service'],
      ownerId: 'user_owner_1',
      ownerName: 'Ibu Hj. Aminah',
      ownerPhone: '+6281398765432',
      description: 'Hunian mewah eksklusif di kawasan privat elit Polonia Medan.',
      isAvailable: true,
    ),
    Kost(
      id: '10',
      categoryId: 'cat_3',
      title: 'Kost Griya Utama',
      location: 'Jl. Amir Hamzah, Kec. Medan Barat',
      price: 'Rp 800.000 / bulan',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?q=80&w=600',
      latitude: 3.6050,
      longitude: 98.6600,
      facilities: ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Ruang Tamu'],
      ownerId: 'owner_6',
      ownerName: 'Ibu Maya',
      ownerPhone: '+6281233445566',
      description: 'Dekat dengan Merdeka Walk dan Lapangan Merdeka Medan.',
      isAvailable: true,
    ),
    Kost(
      id: '11',
      categoryId: 'cat_1',
      title: 'Kost Mawar Indah Putri',
      location: 'Jl. Flamboyan Raya, Kec. Medan Selayang',
      price: 'Rp 820.000 / bulan',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?q=80&w=600',
      latitude: 3.5480,
      longitude: 98.6380,
      facilities: ['WiFi', 'AC', 'Kasur Queen', 'CCTV', 'Mesin Cuci'],
      ownerId: 'owner_7',
      ownerName: 'Ibu Tari',
      ownerPhone: '+6281311223344',
      description: 'Lingkungan sangat hijau, sejuk, ramah mahasiswi.',
      isAvailable: true,
    ),
    Kost(
      id: '12',
      categoryId: 'cat_5',
      title: 'Kost NightOwl 24 Jam',
      location: 'Jl. Kampus USU, Kec. Medan Baru',
      price: 'Rp 950.000 / bulan',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?q=80&w=600',
      latitude: 3.5680,
      longitude: 98.6570,
      facilities: ['WiFi High-Speed 100Mbps', 'Akses 24 Jam', 'AC', 'Meja Kerja Ergonomis'],
      ownerId: 'user_owner_1',
      ownerName: 'Ibu Hj. Aminah',
      ownerPhone: '+6281398765432',
      description: 'Dirancang khusus untuk freelancer dan mahasiswa akhir yang sering mengerjakan tugas hingga larut malam.',
      isAvailable: true,
    ),
    Kost(
      id: '13',
      categoryId: 'cat_2',
      title: 'Kost Putra Nusantara',
      location: 'Jl. Helvetia Raya, Kec. Medan Helvetia',
      price: 'Rp 600.000 / bulan',
      rating: 4.2,
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=600',
      latitude: 3.6180,
      longitude: 98.6420,
      facilities: ['WiFi', 'Kasur', 'Lemari', 'Parkir Motor Inside'],
      ownerId: 'owner_8',
      ownerName: 'Bpk. Doni',
      ownerPhone: '+6285233441122',
      description: 'Harga super ramah kantong dengan lokasi strategis Medan Helvetia.',
      isAvailable: true,
    ),
    Kost(
      id: '14',
      categoryId: 'cat_4',
      title: 'Kencana Luxury Residence',
      location: 'Jl. Karya Wisata, Kec. Medan Johor',
      price: 'Rp 2.500.000 / bulan',
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=600',
      latitude: 3.5290,
      longitude: 98.6650,
      facilities: ['Full Furnished Premium', 'Smart TV 43"', 'Bathtub', 'AC Inverter', 'Security 24 Jam'],
      ownerId: 'owner_9',
      ownerName: 'Bpk. Ir. Rian Kencana',
      ownerPhone: '+6281122334455',
      description: 'Hunian eksklusif seluas studio apartemen di kompleks perumahan elite Medan Johor.',
      isAvailable: false,
    ),
    Kost(
      id: '15',
      categoryId: 'cat_3',
      title: 'Kost Pelangi Kampus',
      location: 'Jl. Padang Bulan, Kec. Medan Baru',
      price: 'Rp 880.000 / bulan',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1507089947368-19c1da9775ae?q=80&w=600',
      latitude: 3.5610,
      longitude: 98.6500,
      facilities: ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Jemuran Baju'],
      ownerId: 'user_owner_1',
      ownerName: 'Ibu Hj. Aminah',
      ownerPhone: '+6281398765432',
      description: 'Hanya 3 menit jalan kaki menuju fakultas Teknik & Kedokteran USU.',
      isAvailable: true,
    ),
    Kost(
      id: '16',
      categoryId: 'cat_1',
      title: 'Kost Cendana Putri',
      location: 'Jl. Letda Sujono, Kec. Medan Tembung',
      price: 'Rp 780.000 / bulan',
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=600',
      latitude: 3.6020,
      longitude: 98.7120,
      facilities: ['WiFi', 'Kamar Mandi Dalam', 'Dapur', 'Dispenser Air'],
      ownerId: 'owner_10',
      ownerName: 'Ibu Rosma',
      ownerPhone: '+6281377665544',
      description: 'Dekat dengan gerbang Tol Bandar Selamat dan Stasiun Kereta.',
      isAvailable: true,
    ),
    Kost(
      id: '17',
      categoryId: 'cat_2',
      title: 'Kost Garuda Putra',
      location: 'Jl. Menteng, Kec. Medan Denai',
      price: 'Rp 680.000 / bulan',
      rating: 4.3,
      imageUrl: 'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?q=80&w=600',
      latitude: 3.5620,
      longitude: 98.7050,
      facilities: ['Kasur', 'Lemari', 'Parkir Motor', 'WiFi'],
      ownerId: 'owner_11',
      ownerName: 'Bpk. Edi',
      ownerPhone: '+6285200112233',
      description: 'Lingkungan aman dan tenang di kawasan Medan Denai.',
      isAvailable: true,
    ),
    Kost(
      id: '18',
      categoryId: 'cat_5',
      title: 'Kost Central Park 24h',
      location: 'Jl. Orion, Kec. Medan Petisah',
      price: 'Rp 1.000.000 / bulan',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=600',
      latitude: 3.5890,
      longitude: 98.6690,
      facilities: ['Akses Bebas 24 Jam', 'AC', 'WiFi 50Mbps', 'Water Heater', 'Kamar Mandi Dalam'],
      ownerId: 'user_owner_1',
      ownerName: 'Ibu Hj. Aminah',
      ownerPhone: '+6281398765432',
      description: 'Dekat dengan Medan Fair Plaza dan pusat kuliner malam Medan.',
      isAvailable: true,
    ),
    Kost(
      id: '19',
      categoryId: 'cat_4',
      title: 'The Suites Platinum',
      location: 'Jl. Univ. Sumatera Utara, Kec. Medan Baru',
      price: 'Rp 3.000.000 / bulan',
      rating: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1567496898669-ee935f5f647a?q=80&w=600',
      latitude: 3.5670,
      longitude: 98.6550,
      facilities: ['Smart TV 50"', 'Private Kitchenette', 'Balcony View', 'King Bed', 'Card Access', 'Gym'],
      ownerId: 'user_owner_1',
      ownerName: 'Ibu Hj. Aminah',
      ownerPhone: '+6281398765432',
      description: 'Kost super luxury terbaik di Medan Baru dengan pemandangan kota.',
      isAvailable: true,
    ),
    Kost(
      id: '20',
      categoryId: 'cat_3',
      title: 'Kost Harapan Kita',
      location: 'Jl. Brigjend Katamso, Kec. Medan Maimun',
      price: 'Rp 750.000 / bulan',
      rating: 4.4,
      imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?q=80&w=600',
      latitude: 3.5750,
      longitude: 98.6810,
      facilities: ['WiFi', 'Kamar Mandi Dalam', 'Lemari Pakaian', 'Kipas Angin / AC'],
      ownerId: 'owner_12',
      ownerName: 'Bpk. Surya',
      ownerPhone: '+6281299001122',
      description: 'Dekat kantor perbankan dan Istana Maimun, lokasi sangat strategis.',
      isAvailable: true,
    ),
  ];

  List<Kost> get items => _kostList;

  // Filter items khusus untuk Pemilik Kost
  List<Kost> get ownerItems {
    if (currentRole == UserRole.pemilikKost) {
      return _kostList
          .where((k) => k.ownerId == _currentUser.id || k.ownerId == 'user_owner_1')
          .toList();
    }
    return _kostList;
  }

  // --- MODUL 1: CRUD KOST (DATA UTAMA) ---
  void addKost(Kost kost) {
    _kostList.add(kost);
    notifyListeners();
  }

  void updateKost(String id, Kost newKost) {
    final index = _kostList.indexWhere((k) => k.id == id);
    if (index != -1) {
      _kostList[index] = newKost;
      notifyListeners();
    }
  }

  void deleteKost(String id) {
    _kostList.removeWhere((k) => k.id == id);
    _favoriteKostIds.remove(id);
    notifyListeners();
  }

  void toggleKostAvailability(String id) {
    final index = _kostList.indexWhere((k) => k.id == id);
    if (index != -1) {
      final current = _kostList[index];
      _kostList[index] = current.copyWith(isAvailable: !current.isAvailable);
      notifyListeners();
    }
  }

  // Compatibility aliases
  void addItem(Kost kost) => addKost(kost);
  void updateItem(String id, Kost newKost) => updateKost(id, newKost);
  void deleteItem(String id) => deleteKost(id);

  // --- MODUL 2: CRUD CATEGORY (DATA REFERENSI) ---
  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(String id, Category newCategory) {
    final index = _categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      _categories[index] = newCategory;
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
