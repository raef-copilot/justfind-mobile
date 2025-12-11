class ReviewEntity {
  final int id;
  final int businessId;
  final int userId;
  final double rating;
  final String comment;
  final String commentEn;
  final String commentAr;
  final String status;
  final String? userName;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  ReviewEntity({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.commentEn,
    required this.commentAr,
    required this.status,
    this.userName,
    required this.createdAt,
    required this.updatedAt,
  });
  
  String get displayComment => commentEn.isNotEmpty ? commentEn : commentAr;
  
  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
}
