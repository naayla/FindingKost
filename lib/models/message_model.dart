class MessageModel {
  final String id;
  final String kostId;
  final String kostTitle;
  final String seekerName;
  final String seekerEmail;
  final String message;
  final DateTime createdAt;
  bool isRead;

  MessageModel({
    required this.id,
    required this.kostId,
    required this.kostTitle,
    required this.seekerName,
    required this.seekerEmail,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });
}
