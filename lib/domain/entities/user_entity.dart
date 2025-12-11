class UserEntity {
  final int id;
  final String email;
  final String phone;
  final String nameEn;
  final String nameAr;
  final String role;
  final bool isVerified;
  
  UserEntity({
    required this.id,
    required this.email,
    required this.phone,
    required this.nameEn,
    required this.nameAr,
    required this.role,
    required this.isVerified,
  });

  String get name => nameEn.isNotEmpty ? nameEn : nameAr;
  
  bool get isAdmin => role == 'admin';
  bool get isBusinessOwner => role == 'business_owner';
  bool get isCustomer => role == 'customer';
  
  String get displayName => name;
}
