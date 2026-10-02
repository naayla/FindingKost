import 'package:flutter/material.dart';

import '../models/kost_model.dart';
import '../models/category.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // 1. Minimal 5 Record Referensi/Kategori
  final List<Category> _categories = [
    Category(id: 'cat_1', name: 'Putri', iconName: 'female'),
    Category(id: 'cat_2', name: 'Putra', iconName: 'male'),
    Category(id: 'cat_3', name: 'Campur', iconName: 'people'),
    Category(id: 'cat_4', name: 'Eksklusif', iconName: 'star'),
    Category(id: 'cat_5', name: 'Bebas 24 Jam', iconName: 'access_time'),
  ];

  // 2. Minimal 20 Record Utama (dengan Relasi CategoryID)
  final List<Kost> _kostList = [
    Kost(
      id: '1',
      categoryId: 'cat_1',
      title: 'Kos Bahagia Medan',
      location: 'Kec. Medan Baru • 500m dari lokasi',
      price: 'Rp 850.000 / bulan',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1554995207-c18c203602cb?q=80&w=600',
    ),
    Kost(
      id: '2',
      categoryId: 'cat_1',
      title: 'Kost Putri Harmoni',
      location: 'Kec. Medan Selayang • 1.2km dari lokasi',
      price: 'Rp 750.000 / bulan',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=600',
    ),
    Kost(
      id: '3',
      categoryId: 'cat_2',
      title: 'Kost Mahasiswa Medan',
      location: 'Kec. Medan Petisah • 2km dari lokasi',
      price: 'Rp 700.000 / bulan',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=600',
    ),
    Kost(
      id: '4',
      categoryId: 'cat_4',
      title: 'Grand Residence Executive',
      location: 'Kec. Medan Baru • 300m dari lokasi',
      price: 'Rp 1.800.000 / bulan',
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=600',
    ),
    Kost(
      id: '5',
      categoryId: 'cat_3',
      title: 'Kost Melati Campur',
      location: 'Kec. Medan Tembung • 1.5km dari lokasi',
      price: 'Rp 650.000 / bulan',
      rating: 4.4,
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=600',
    ),
    Kost(
      id: '6',
      categoryId: 'cat_5',
      title: 'Kost Freedom 24 Jam',
      location: 'Kec. Medan Sunggal • 800m dari lokasi',
      price: 'Rp 900.000 / bulan',
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=600',
    ),
    Kost(
      id: '7',
      categoryId: 'cat_1',
      title: 'Kost Anggrek Asri Putri',
      location: 'Kec. Medan Kota • 1.1km dari lokasi',
      price: 'Rp 800.000 / bulan',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?q=80&w=600',
    ),
    Kost(
      id: '8',
      categoryId: 'cat_2',
      title: 'Kost Putra Perjuangan',
      location: 'Kec. Medan Perjuangan • 900m dari lokasi',
      price: 'Rp 720.000 / bulan',
      rating: 4.3,
      imageUrl: 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?q=80&w=600',
    ),
    Kost(
      id: '9',
      categoryId: 'cat_4',
      title: 'Royal Family Kost Exclusif',
      location: 'Kec. Medan Polonia • 2.5km dari lokasi',
      price: 'Rp 2.200.000 / bulan',
      rating: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=600',
    ),
    Kost(
      id: '10',
      categoryId: 'cat_3',
      title: 'Kost Griya Utama',
      location: 'Kec. Medan Barat • 1.8km dari lokasi',
      price: 'Rp 800.000 / bulan',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?q=80&w=600',
    ),
    Kost(
      id: '11',
      categoryId: 'cat_1',
      title: 'Kost Mawar Indah Putri',
      location: 'Kec. Medan Selayang • 600m dari lokasi',
      price: 'Rp 820.000 / bulan',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?q=80&w=600',
    ),
    Kost(
      id: '12',
      categoryId: 'cat_5',
      title: 'Kost NightOwl 24 Jam',
      location: 'Kec. Medan Baru • 400m dari lokasi',
      price: 'Rp 950.000 / bulan',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?q=80&w=600',
    ),
    Kost(
      id: '13',
      categoryId: 'cat_2',
      title: 'Kost Putra Nusantara',
      location: 'Kec. Medan Helvetia • 3km dari lokasi',
      price: 'Rp 600.000 / bulan',
      rating: 4.2,
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=600',
    ),
    Kost(
      id: '14',
      categoryId: 'cat_4',
      title: 'Kencana Luxury Residence',
      location: 'Kec. Medan Johor • 3.2km dari lokasi',
      price: 'Rp 2.500.000 / bulan',
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=600',
    ),
    Kost(
      id: '15',
      categoryId: 'cat_3',
      title: 'Kost Pelangi Kampus',
      location: 'Kec. Medan Baru • 200m dari lokasi',
      price: 'Rp 880.000 / bulan',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1507089947368-19c1da9775ae?q=80&w=600',
    ),
    Kost(
      id: '16',
      categoryId: 'cat_1',
      title: 'Kost Cendana Putri',
      location: 'Kec. Medan Tembung • 1.0km dari lokasi',
      price: 'Rp 780.000 / bulan',
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=600',
    ),
    Kost(
      id: '17',
      categoryId: 'cat_2',
      title: 'Kost Garuda Putra',
      location: 'Kec. Medan Denai • 2.1km dari lokasi',
      price: 'Rp 680.000 / bulan',
      rating: 4.3,
      imageUrl: 'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?q=80&w=600',
    ),
    Kost(
      id: '18',
      categoryId: 'cat_5',
      title: 'Kost Central Park 24h',
      location: 'Kec. Medan Petisah • 1.3km dari lokasi',
      price: 'Rp 1.000.000 / bulan',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=600',
    ),
    Kost(
      id: '19',
      categoryId: 'cat_4',
      title: 'The Suites Platinum',
      location: 'Kec. Medan Baru • 100m dari lokasi',
      price: 'Rp 3.000.000 / bulan',
      rating: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1567496898669-ee935f5f647a?q=80&w=600',
    ),
    Kost(
      id: '20',
      categoryId: 'cat_3',
      title: 'Kost Harapan Kita',
      location: 'Kec. Medan Maimun • 2.8km dari lokasi',
      price: 'Rp 750.000 / bulan',
      rating: 4.4,
      imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?q=80&w=600',
    ),
  ];

  List<Category> get categories => _categories;
  List<Kost> get items => _kostList;

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
    notifyListeners();
  }

  // Alias method untuk kompatibilitas layar lama
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
