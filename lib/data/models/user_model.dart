import 'package:justfind_app/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.phone,
    required super.nameEn,
    required super.nameAr,
    required super.role,
    required super.isVerified,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      phone: json['phone'] as String,
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      role: json['role'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'name_en': nameEn,
      'name_ar': nameAr,
      'role': role,
      'is_verified': isVerified,
    };
  }
  
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      phone: phone,
      nameEn: nameEn,
      nameAr: nameAr,
      role: role,
      isVerified: isVerified,
    );
  }
}
