import 'package:justfind_app/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.id,
    required super.businessId,
    required super.userId,
    required super.rating,
    required super.comment,
    required super.commentEn,
    required super.commentAr,
    required super.status,
    super.userName,
    required super.createdAt,
    required super.updatedAt,
  });
  
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      businessId: json['business_id'] is int ? json['business_id'] : int.parse(json['business_id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
      rating: (json['rating'] is num ? json['rating'] : double.parse(json['rating'].toString())).toDouble(),
      comment: json['comment'] as String? ?? json['comment_en'] as String? ?? '',
      commentEn: json['comment_en'] as String? ?? json['comment'] as String? ?? '',
      commentAr: json['comment_ar'] as String? ?? '',
      status: json['status'] as String? ?? 'approved',
      userName: json['user_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'comment_en': commentEn,
      'comment_ar': commentAr,
      'status': status,
      'user_name': userName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
