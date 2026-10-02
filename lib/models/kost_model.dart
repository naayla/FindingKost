class Kost {
  final String id;
  final String categoryId;
  final String title;
  final String location;
  final String price;
  final double rating;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final List<String> facilities;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final String description;
  final bool isAvailable;

  Kost({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.latitude = 3.5952,
    this.longitude = 98.6722,
    this.facilities = const ['WiFi', 'Kamar Mandi Dalam', 'AC', 'Kasur'],
    this.ownerId = 'owner_1',
    this.ownerName = 'Bapak H. Rahmad',
    this.ownerPhone = '+6281234567890',
    this.description = 'Kos bersih, aman, dan nyaman berlokasi strategis dekat fasilitas umum dan kampus.',
    this.isAvailable = true,
  });

  Kost copyWith({
    String? id,
    String? categoryId,
    String? title,
    String? location,
    String? price,
    double? rating,
    String? imageUrl,
    double? latitude,
    double? longitude,
    List<String>? facilities,
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    String? description,
    bool? isAvailable,
  }) {
    return Kost(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      location: location ?? this.location,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      facilities: facilities ?? this.facilities,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
