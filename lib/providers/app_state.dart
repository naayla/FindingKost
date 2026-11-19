import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/kost_model.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';
import '../services/firebase_service.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  final FirebaseService _firebaseService = FirebaseService();

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

  // --- CATEGORIES ---
  List<Category> _categories = [
    Category(id: 'cat_1', name: 'Putri', iconName: 'female'),
    Category(id: 'cat_2', name: 'Putra', iconName: 'male'),
    Category(id: 'cat_3', name: 'Campur', iconName: 'people'),
    Category(id: 'cat_4', name: 'Eksklusif', iconName: 'star'),
    Category(id: 'cat_5', name: 'Bebas 24 Jam', iconName: 'access_time'),
  ];

  List<Category> get categories => _categories;

  // --- KOST LIST (Sekarang akan diambil dari Firebase) ---
  List<Kost> _kostList = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Kost> get items => _kostList;

  // Constructor
  AppState() {
    _loadDataFromFirebase();
  }

  // ---------------------------------------------------------------------------
  // INTEGRASI FIREBASE (MEMBACA DATA)
  // ---------------------------------------------------------------------------
  Future<void> _loadDataFromFirebase() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Mengambil data Kos dari Firestore
      final firestoreKosts = await _firebaseService.getAllKosts();
      
      // Jika di Firestore ada data, gunakan data tersebut
      if (firestoreKosts.isNotEmpty) {
        _kostList = firestoreKosts;
      } else {
        // Fallback ke data kosong jika belum ada di database
        _kostList = [];
      }

      // (Opsional) 2. Mengambil Kategori dari Firestore 
      // Jika belum diupload, kita akan tetap pakai _categories hardcoded di atas.
      // final firestoreCategories = await _firebaseService.getCategories();
      // if (firestoreCategories.isNotEmpty) {
      //   _categories = firestoreCategories;
      // }

    } catch (e) {
      print("Gagal memuat data dari Firebase: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Untuk memanggil reload data secara manual
  Future<void> reloadData() async {
    await _loadDataFromFirebase();
  }

  // Filter items khusus untuk Pemilik Kost
  List<Kost> get ownerItems {
    if (currentRole == UserRole.pemilikKost) {
      return _kostList
          .where((k) => k.ownerId == _currentUser.id || k.ownerId == 'user_owner_1')
          .toList();
    }
    return _kostList;
  }

  // --- MODUL 1: CRUD KOST (Telah Terhubung ke Firebase) ---
  Future<void> addKost(Kost kost) async {
    final resultId = await _firebaseService.addKost(kost);
    if (resultId != null) {
      final newKost = kost.copyWith(id: resultId);
      _kostList.add(newKost);
      notifyListeners();
    }
  }

  Future<void> updateKost(String id, Kost newKost) async {
    final success = await _firebaseService.updateKost(newKost);
    if (success) {
      final index = _kostList.indexWhere((k) => k.id == id);
      if (index != -1) {
        _kostList[index] = newKost;
        notifyListeners();
      }
    }
  }

  Future<void> deleteKost(String id) async {
    final success = await _firebaseService.deleteKost(id);
    if (success) {
      _kostList.removeWhere((k) => k.id == id);
      _favoriteKostIds.remove(id);
      notifyListeners();
    }
  }

  Future<void> toggleKostAvailability(String id) async {
    final index = _kostList.indexWhere((k) => k.id == id);
    if (index != -1) {
      final current = _kostList[index];
      final updatedKost = current.copyWith(isAvailable: !current.isAvailable);
      
      final success = await _firebaseService.updateKost(updatedKost);
      if (success) {
        _kostList[index] = updatedKost;
        notifyListeners();
      }
    }
  }

  // Compatibility aliases
  void addItem(Kost kost) => addKost(kost);
  void updateItem(String id, Kost newKost) => updateKost(id, newKost);
  void deleteItem(String id) => deleteKost(id);

  // --- MODUL 2: CRUD CATEGORY (Sementara tetap lokal) ---
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
