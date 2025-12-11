import 'package:justfind_app/domain/entities/category_entity.dart';

class BusinessEntity {
  final int id;
  final int ownerId;
  final int categoryId;
  final String name;
  final String nameEn;
  final String nameAr;
  final String description;
  final String descriptionEn;
  final String descriptionAr;
  final String phone;
  final String whatsapp;
  final String address;
  final String addressEn;
  final String addressAr;
  final double lat;
  final double lng;
  final String status;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool isFavorited;
  final String? email;
  final String? website;
  final String? city;
  final String? openingHours;
  final double? averageRating;
  final int? totalReviews;
  final CategoryEntity? category;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  BusinessEntity({
    required this.id,
    required this.ownerId,
    required this.categoryId,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    required this.description,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.phone,
    required this.whatsapp,
    required this.address,
    required this.addressEn,
    required this.addressAr,
    required this.lat,
    required this.lng,
    required this.status,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.isFavorited,
    this.email,
    this.website,
    this.city,
    this.openingHours,
    this.averageRating,
    this.totalReviews,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });
  
  String get displayName => nameEn.isNotEmpty ? nameEn : nameAr;
  String get displayDescription => descriptionEn.isNotEmpty ? descriptionEn : descriptionAr;
  String get displayAddress => addressEn.isNotEmpty ? addressEn : addressAr;
  
  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';
}
