class MainItem {
  final String id;
  final String categoryId;
  String title;
  String description;
  double price;
  double rating;

  MainItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
  });
}