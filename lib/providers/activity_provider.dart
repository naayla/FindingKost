import 'package:flutter/material.dart';

class ActivityItem {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final IconData icon;
  final Color themeColor;

  ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.icon = Icons.history_rounded,
    this.themeColor = const Color(0xFF2D6A4F), // Default warna hijau My Maps
  });
}

class ActivityProvider with ChangeNotifier {
  final List<ActivityItem> _activities = [
    ActivityItem(
      id: 'act-1',
      title: 'Melihat Detail Kos',
      description: 'Membuka informasi Kos Bahagia Medan',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      icon: Icons.search_rounded,
    ),
    ActivityItem(
      id: 'act-2',
      title: 'Membuka Google My Maps',
      description: 'Melihat peta lokasi kisaran kos di Medan',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.map_rounded,
    ),
  ];

  List<ActivityItem> get activities => [..._activities];

  // Menambahkan riwayat aktivitas baru
  void addActivity({
    required String title,
    required String description,
    IconData icon = Icons.check_circle_outline_rounded,
    Color themeColor = const Color(0xFF2D6A4F),
  }) {
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      timestamp: DateTime.now(),
      icon: icon,
      themeColor: themeColor,
    );
    _activities.insert(0, newActivity);
    notifyListeners();
  }

  // Menghapus seluruh riwayat aktivitas
  void clearActivities() {
    _activities.clear();
    notifyListeners();
  }
}