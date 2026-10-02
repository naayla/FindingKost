import 'user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? institutionOrBusiness;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.institutionOrBusiness,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? institutionOrBusiness,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      institutionOrBusiness: institutionOrBusiness ?? this.institutionOrBusiness,
    );
  }
}
