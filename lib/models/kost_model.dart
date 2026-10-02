class Kost {
  final String id;
  final String categoryId;
  final String title;
  final String location;
  final String price;
  final double rating;
  final String imageUrl;
  final String? imagePath;

  Kost({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.imagePath,
  });
}