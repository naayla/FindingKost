import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kost_model.dart';
import '../models/category.dart';

class FirebaseService {

  // ---------------------------------------------------------------------------
  // 1. KOST (Properti/Kos) CRUD OPERATIONS
  // ---------------------------------------------------------------------------

  /// Mengambil semua data Kos dari Firestore
  Future<List<Kost>> getAllKosts() async {
    try {
      final snapshot = await _firestore.collection('kosts').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return _mapToKost(doc.id, data);
      }).toList();
    } catch (e) {
      print('Error getting kosts: $e');
      return [];
    }
  }

  /// Menambahkan data Kos baru ke Firestore
  Future<String?> addKost(Kost kost) async {
    try {
      final data = _kostToMap(kost);
      // Jika id kosong, biarkan firestore men-generate id
      if (kost.id.isEmpty) {
        final docRef = await _firestore.collection('kosts').add(data);
        return docRef.id;
      } else {
        await _firestore.collection('kosts').doc(kost.id).set(data);
        return kost.id;
      }
    } catch (e) {
      print('Error adding kost: $e');
      return null;
    }
  }

  /// Memperbarui data Kos di Firestore
  Future<bool> updateKost(Kost kost) async {
    try {
      await _firestore.collection('kosts').doc(kost.id).update(_kostToMap(kost));
      return true;
    } catch (e) {
      print('Error updating kost: $e');
      return false;
    }
  }

  /// Menghapus Kos dari Firestore
  Future<bool> deleteKost(String id) async {
    try {
      await _firestore.collection('kosts').doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting kost: $e');
      return false;
    }
  }


  // ---------------------------------------------------------------------------
  // 2. CATEGORY CRUD OPERATIONS
  // ---------------------------------------------------------------------------

  /// Mengambil semua data Kategori
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Category(
          id: doc.id,
          name: data['name'] ?? '',
          iconName: data['iconName'] ?? 'home',
        );
      }).toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }


  // ---------------------------------------------------------------------------
  // HELPER METHODS (MAPPING)
  // ---------------------------------------------------------------------------

  Kost _mapToKost(String id, Map<String, dynamic> data) {
    return Kost(
      id: id,
      categoryId: data['categoryId'] ?? '',
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      price: data['price'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      facilities: List<String>.from(data['facilities'] ?? []),
      ownerId: data['ownerId'] ?? '',
      ownerName: data['ownerName'] ?? '',
      ownerPhone: data['ownerPhone'] ?? '',
      description: data['description'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> _kostToMap(Kost kost) {
    return {
      'categoryId': kost.categoryId,
      'title': kost.title,
      'location': kost.location,
      'price': kost.price,
      'rating': kost.rating,
      'imageUrl': kost.imageUrl,
      'latitude': kost.latitude,
      'longitude': kost.longitude,
      'facilities': kost.facilities,
      'ownerId': kost.ownerId,
      'ownerName': kost.ownerName,
      'ownerPhone': kost.ownerPhone,
      'description': kost.description,
      'isAvailable': kost.isAvailable,
    };
  }
}
