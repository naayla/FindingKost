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

  BookingModel copyWith({
    String? id,
    String? kostId,
    String? kostTitle,
    String? kostImageUrl,
    String? userName,
    String? userEmail,
    String? seekerGender,
    String? seekerMarriageStatus,
    String? occupantsCount,
    String? durationMonths,
    String? startDate,
    String? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      kostId: kostId ?? this.kostId,
      kostTitle: kostTitle ?? this.kostTitle,
      kostImageUrl: kostImageUrl ?? this.kostImageUrl,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      seekerGender: seekerGender ?? this.seekerGender,
      seekerMarriageStatus: seekerMarriageStatus ?? this.seekerMarriageStatus,
      occupantsCount: occupantsCount ?? this.occupantsCount,
      durationMonths: durationMonths ?? this.durationMonths,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
