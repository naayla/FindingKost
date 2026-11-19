class ReviewModel {
  final String id;
  final String kostId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.kostId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
