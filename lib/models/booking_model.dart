class BookingModel {
  final String id;
  final String kostId;
  final String kostTitle;
  final String kostImageUrl;
  final String userName;
  final String durationMonths;
  final String startDate;
  final String status; // 'Menunggu Konfirmasi', 'Disetujui', 'Ditolak'
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.kostId,
    required this.kostTitle,
    required this.kostImageUrl,
    required this.userName,
    required this.durationMonths,
    required this.startDate,
    required this.status,
    required this.createdAt,
  });
}
