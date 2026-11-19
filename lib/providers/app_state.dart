import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_model.dart';
import '../models/category.dart';
import '../models/kost_model.dart';
import '../models/message_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';
import '../services/firebase_service.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  final FirebaseService _firebaseService;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // --- USER STATE & ROLE ---
  UserModel _currentUser = UserModel(
    id: 'user_seeker_1',
    name: 'Pengguna',
    email: 'pengguna@example.com',
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
    _favoriteKostIds.clear();
    _favoriteLoad = _loadFavoriteKostIds(user.id);
    notifyListeners();
  }

  void setRole(UserRole role) {
    _currentUser = _currentUser.copyWith(role: role);
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? institutionOrBusiness,
  }) {
    _currentUser = _currentUser.copyWith(
      name: name,
      email: email,
      phone: phone,
      institutionOrBusiness: institutionOrBusiness,
    );
    notifyListeners();
  }

  // --- FAVORITES (UNTUK PENCARI KOST) ---
  static const _favoriteStorageKeyPrefix = 'favorite_kost_ids_';
  final List<String> _favoriteKostIds = [];
  Future<void> _favoriteLoad = Future<void>.value();

  List<String> get favoriteKostIds => List.unmodifiable(_favoriteKostIds);

  bool isFavorite(String id) => _favoriteKostIds.contains(id);

  Future<bool> toggleFavorite(String id) async {
    await _favoriteLoad;
    final previousFavorites = List<String>.of(_favoriteKostIds);
    if (_favoriteKostIds.contains(id)) {
      _favoriteKostIds.remove(id);
    } else {
      _favoriteKostIds.add(id);
    }
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setStringList(
        _favoriteStorageKey(_currentUser.id),
        _favoriteKostIds,
      );
      if (saved) return true;
    } catch (error, stackTrace) {
      _favoriteKostIds
        ..clear()
        ..addAll(previousFavorites);
      notifyListeners();
      Error.throwWithStackTrace(error, stackTrace);
    }

    _favoriteKostIds
      ..clear()
      ..addAll(previousFavorites);
    notifyListeners();
    return false;
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
  AppState({FirebaseService? firebaseService})
    : _firebaseService = firebaseService ?? FirebaseService() {
    _favoriteLoad = _loadFavoriteKostIds(_currentUser.id);
    _loadDataFromFirebase();
  }

  String _favoriteStorageKey(String userId) =>
      '$_favoriteStorageKeyPrefix$userId';

  Future<void> _loadFavoriteKostIds(String userId) async {
    final preferences = await SharedPreferences.getInstance();
    final savedIds = preferences.getStringList(_favoriteStorageKey(userId));
    if (_currentUser.id != userId) return;

    _favoriteKostIds
      ..clear()
      ..addAll(savedIds ?? (userId == 'user_seeker_1' ? ['1', '4', '9'] : []));

    if (savedIds == null && userId == 'user_seeker_1') {
      final saved = await preferences.setStringList(
        _favoriteStorageKey(userId),
        _favoriteKostIds,
      );
      if (!saved) {
        throw StateError('Favorit awal gagal disimpan ke penyimpanan lokal.');
      }
    }
    notifyListeners();
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
          .where(
            (k) => k.ownerId == _currentUser.id || k.ownerId == 'user_owner_1',
          )
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
      if (_favoriteKostIds.remove(id)) {
        final preferences = await SharedPreferences.getInstance();
        final saved = await preferences.setStringList(
          _favoriteStorageKey(_currentUser.id),
          _favoriteKostIds,
        );
        if (!saved) {
          throw StateError('Perubahan favorit gagal disimpan.');
        }
      }
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

  // --- BOOKINGS & REVIEWS & ACTIVITY LOGS ---
  final List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  void addBooking(BookingModel booking) {
    _bookings.insert(0, booking);
    _activityLogs.insert(0, 'Mengajukan sewa untuk ${booking.kostTitle}');
    notifyListeners();
  }

  void updateBookingStatus(String id, String newStatus) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      final booking = _bookings[index];
      booking.status = newStatus;

      if (newStatus == 'Disetujui') {
        final kostIndex = _kostList.indexWhere((k) => k.id == booking.kostId);
        if (kostIndex != -1) {
          final currentKost = _kostList[kostIndex];
          final remaining = (currentKost.availableRooms - 1).clamp(0, 999);
          _kostList[kostIndex] = currentKost.copyWith(
            availableRooms: remaining,
            isAvailable: remaining > 0,
          );
        }
      }

      _activityLogs.insert(
        0,
        'Status booking ${booking.kostTitle} diubah menjadi $newStatus',
      );
      notifyListeners();
    }
  }

  final Map<String, List<ReviewModel>> _reviewsMap = {
    '1': [
      ReviewModel(
        id: 'r1',
        kostId: '1',
        userName: 'Nayla Syifa',
        rating: 5.0,
        comment: 'Kos sangat bersih dan dekat kampus USU!',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'r2',
        kostId: '1',
        userName: 'Budi Santoso',
        rating: 4.5,
        comment: 'Pemilik ramah dan fasilitas lengkap.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ],
    '4': [
      ReviewModel(
        id: 'r3',
        kostId: '4',
        userName: 'Siti Rahma',
        rating: 5.0,
        comment: 'Eksklusif mewah, AC dingin, air panas lancar.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  };

  List<ReviewModel> getReviewsForKost(String kostId) {
    return _reviewsMap[kostId] ?? [];
  }

  void addReview(ReviewModel review) {
    if (_reviewsMap[review.kostId] == null) {
      _reviewsMap[review.kostId] = [];
    }
    _reviewsMap[review.kostId]!.insert(0, review);
    _activityLogs.insert(0, 'Menambahkan ulasan untuk kos');
    notifyListeners();
  }

  final List<String> _activityLogs = [
    'Masuk ke aplikasi Finding Kost',
    'Menjelajahi katalog kos di Medan',
  ];
  List<String> get activityLogs => _activityLogs;

  void logActivity(String message) {
    _activityLogs.insert(0, message);
    notifyListeners();
  }

  // --- OWNER MESSAGES & CHAT NOTIFICATIONS ---
  final List<MessageModel> _ownerMessages = [];

  List<MessageModel> get ownerMessages => _ownerMessages;

  void sendOwnerMessage(MessageModel msg) {
    _ownerMessages.insert(0, msg);
    _activityLogs.insert(
      0,
      'Mengirim pesan chat ke pemilik kos ${msg.kostTitle}',
    );
    notifyListeners();
  }

  void markMessageAsRead(String id) {
    final index = _ownerMessages.indexWhere((m) => m.id == id);
    if (index != -1) {
      _ownerMessages[index].isRead = true;
      notifyListeners();
    }
  }

  // Notifikasi pemilik
  final List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  void addNotification(String message, {required String targetOwnerId}) {
    _notifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'message': message,
      'targetOwnerId': targetOwnerId,
      'createdAt': DateTime.now(),
    });
    notifyListeners();
  }
}
