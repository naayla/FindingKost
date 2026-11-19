import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/category.dart';
import '../models/kost_model.dart';
import '../models/message_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

class AppState extends ChangeNotifier {
  // --- 1. DARK MODE STATE ---
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // --- 2. MANAJEMEN USER & ROLE ---
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isOwner => _currentUser?.role == UserRole.pemilikKost;

  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  void setRole(UserRole role) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(role: role);
    } else {
      _currentUser = UserModel(
        id: role == UserRole.pemilikKost ? 'user_owner_1' : 'user_seeker_1',
        name: role == UserRole.pemilikKost ? 'Pemilik Kos' : 'Pengguna',
        email: role == UserRole.pemilikKost ? 'pemilik@example.com' : 'pengguna@example.com',
        phone: '',
        role: role,
      );
    }
    notifyListeners();
  }

  // --- 3. FAVORIT KOS ---
  final List<String> _favoriteKostIds = ['1', '3'];
  List<String> get favoriteKostIds => _favoriteKostIds;
  List<Kost> get favoriteKosts => _kostList.where((k) => _favoriteKostIds.contains(k.id)).toList();

  bool isFavorite(Kost kost) {
    return _favoriteKostIds.contains(kost.id);
  }

  void toggleFavorite(Kost kost) {
    if (_favoriteKostIds.contains(kost.id)) {
      _favoriteKostIds.remove(kost.id);
      _activityLogs.insert(0, 'Menghapus ${kost.title} dari favorit');
    } else {
      _favoriteKostIds.add(kost.id);
      _activityLogs.insert(0, 'Menambahkan ${kost.title} ke favorit');
    }
    notifyListeners();
  }

  // --- 4. BOOKINGS & INBOX ---
  final List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  void addBooking(BookingModel booking) {
    _bookings.insert(0, booking);
    _activityLogs.insert(0, 'Mengajukan sewa untuk ${booking.kostTitle}');
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, String newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: newStatus);
      _activityLogs.insert(0, 'Status pengajuan diperbarui menjadi $newStatus');
      notifyListeners();
    }
  }

  final List<MessageModel> _ownerMessages = [];
  List<MessageModel> get ownerMessages => _ownerMessages;

  void sendOwnerMessage(MessageModel message) {
    _ownerMessages.insert(0, message);
    notifyListeners();
  }

  void markMessageAsRead(String messageId) {
    final index = _ownerMessages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _ownerMessages[index].isRead = true;
      notifyListeners();
    }
  }

  final List<String> _activityLogs = [];
  List<String> get activityLogs => _activityLogs;

  // --- 5. REVIEWS ---
  final List<ReviewModel> _reviews = [];
  List<ReviewModel> getReviewsForKost(String kostId) {
    return _reviews.where((r) => r.kostId == kostId).toList();
  }

  void addReview(ReviewModel review) {
    _reviews.insert(0, review);
    _activityLogs.insert(0, 'Menambahkan ulasan baru');
    notifyListeners();
  }

  // --- 6. KATEGORI & KOS ---
  final List<Category> _categories = [
    Category(id: 'cat_1', name: 'Putri', iconName: 'female'),
    Category(id: 'cat_2', name: 'Putra', iconName: 'male'),
    Category(id: 'cat_3', name: 'Campur', iconName: 'people'),
    Category(id: 'cat_4', name: 'Eksklusif', iconName: 'star'),
    Category(id: 'cat_5', name: 'Bebas 24 Jam', iconName: 'access_time'),
  ];
  List<Category> get categories => _categories;

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

  final List<Kost> _kostList = [
    Kost(
      id: '1',
      categoryId: 'cat_1',
      title: 'Kos Bahagia Medan Baru',
      location: 'Jl. Dr. Mansyur, Kec. Medan Baru',
      price: 'Rp 850.000 / bulan',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1554995207-c18c203602cb?q=80&w=600',
      description: 'Kos khusus putri aman 24 jam dengan gerbang terunci. Berada sangat dekat dengan pintu masuk USU Medan.',
      ownerName: 'Ibu Hj. Siti Aminah',
      ownerPhone: '+62 812 3456 7890',
      availableRooms: 3,
      genderRule: 'Putri',
      marriageStatus: 'Pasutri Diizinkan',
      maxOccupants: '2 Orang',
      latitude: 3.5651,
      longitude: 98.6538,
    ),
    Kost(
      id: '2',
      categoryId: 'cat_1',
      title: 'Kost Putri Harmoni',
      location: 'Kec. Medan Selayang',
      price: 'Rp 750.000 / bulan',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=600',
      description: 'Kos putri nyaman dekat area kampus.',
      ownerName: 'Bapak Budi',
      ownerPhone: '+62 812 9876 5432',
      availableRooms: 2,
      genderRule: 'Putri',
      marriageStatus: 'Belum Menikah',
      maxOccupants: '1 Orang',
      latitude: 3.5500,
      longitude: 98.6400,
    ),
    Kost(
      id: '3',
      categoryId: 'cat_2',
      title: 'Kost Mahasiswa Medan',
      location: 'Kec. Medan Petisah',
      price: 'Rp 700.000 / bulan',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=600',
      description: 'Kos putra strategis pusat kota.',
      ownerName: 'Bapak Joko',
      ownerPhone: '+62 811 2222 3333',
      availableRooms: 4,
      genderRule: 'Putra',
      marriageStatus: 'Belum Menikah',
      maxOccupants: '1 Orang',
      latitude: 3.5800,
      longitude: 98.6700,
    ),
    Kost(
      id: '4',
      categoryId: 'cat_4',
      title: 'Grand Residence Executive',
      location: 'Kec. Medan Baru',
      price: 'Rp 1.800.000 / bulan',
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=600',
      description: 'Kos eksklusif fasilitas lengkap.',
      ownerName: 'Ibu Rina',
      ownerPhone: '+62 813 4444 5555',
      availableRooms: 1,
      genderRule: 'Campur / Bebas',
      marriageStatus: 'Pasutri Diizinkan',
      maxOccupants: '2 Orang',
      latitude: 3.5600,
      longitude: 98.6600,
    ),
    Kost(
      id: '5',
      categoryId: 'cat_3',
      title: 'Kost Melati Campur',
      location: 'Kec. Medan Tembung',
      price: 'Rp 650.000 / bulan',
      rating: 4.4,
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=600',
      description: 'Kos campur ekonomis.',
      ownerName: 'Bapak Santoso',
      ownerPhone: '+62 815 6666 7777',
      availableRooms: 5,
      genderRule: 'Campur / Bebas',
      marriageStatus: 'Belum Menikah',
      maxOccupants: '1 Orang',
      latitude: 3.6000,
      longitude: 98.7000,
    ),
  ];
  List<Kost> get items => _kostList;

  void addKost(Kost kost) {
    final newKost = kost.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
    _kostList.insert(0, newKost);
    _activityLogs.insert(0, 'Menambahkan kos baru: ${newKost.title}');
    notifyListeners();
  }

  void updateKost(String id, Kost updatedKost) {
    final index = _kostList.indexWhere((k) => k.id == id);
    if (index != -1) {
      _kostList[index] = updatedKost;
      _activityLogs.insert(0, 'Memperbarui kos: ${updatedKost.title}');
      notifyListeners();
    }
  }

  void deleteKost(String id) {
    _kostList.removeWhere((k) => k.id == id);
    _activityLogs.insert(0, 'Menghapus kos ID: $id');
    notifyListeners();
  }
}
