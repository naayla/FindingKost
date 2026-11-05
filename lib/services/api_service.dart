import '../models/booking_model.dart';
import '../models/message_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

class ApiService {
  // Simulasi Latency Jaringan (Network Latency)
  static const Duration _simulatedNetworkDelay = Duration(milliseconds: 600);

  // Simulasi Login API
  Future<UserModel> login({required String email, required String password, required UserRole role}) async {
    await Future.delayed(_simulatedNetworkDelay);
    if (email.isEmpty) {
      throw Exception('Email tidak boleh kosong');
    }
    return UserModel(
      id: role == UserRole.pemilikKost ? 'user_owner_1' : 'user_seeker_1',
      name: role == UserRole.pemilikKost ? 'Pemilik Kos' : 'Pengguna',
      email: email,
      phone: '+62 812 3456 7890',
      role: role,
      institutionOrBusiness: role == UserRole.pemilikKost ? 'Pemilik Kos Mandiri' : 'Universitas Sumatera Utara',
    );
  }

  // Simulasi Register API
  Future<bool> register({required String name, required String email, required String password, required String phone}) async {
    await Future.delayed(_simulatedNetworkDelay);
    if (name.isEmpty || email.isEmpty) {
      throw Exception('Data registrasi tidak lengkap');
    }
    return true;
  }

  // Simulasi Submit Booking API
  Future<bool> submitBooking(BookingModel booking) async {
    await Future.delayed(_simulatedNetworkDelay);
    return true;
  }

  // Simulasi Send Chat API
  Future<bool> sendMessage(MessageModel message) async {
    await Future.delayed(_simulatedNetworkDelay);
    return true;
  }

  // Simulasi Submit Review API
  Future<bool> submitReview(ReviewModel review) async {
    await Future.delayed(_simulatedNetworkDelay);
    return true;
  }
}
