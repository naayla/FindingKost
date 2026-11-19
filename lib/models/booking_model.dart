class BookingModel {
  final String id;
  final String kostId;
  final String kostTitle;
  final String kostImageUrl;
  final String userName;
  final String userEmail;
  final String seekerGender;
  final String seekerMarriageStatus;
  final String occupantsCount;
  final String durationMonths;
  final String startDate;
  String status;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.kostId,
    required this.kostTitle,
    required this.kostImageUrl,
    required this.userName,
    required this.userEmail,
    required this.seekerGender,
    required this.seekerMarriageStatus,
    required this.occupantsCount,
    required this.durationMonths,
    required this.startDate,
    required this.status,
    required this.createdAt,
  });
}
