import 'package:justfind_app/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    required super.nameEn,
    required super.nameAr,
    super.parentId,
    required super.icon,
    required super.sortOrder,
    super.businessCount,
  });
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] as String? ?? json['name_en'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      parentId: json['parent_id'] != null ? (json['parent_id'] is int ? json['parent_id'] : int.tryParse(json['parent_id'].toString())) : null,
      icon: json['icon'] as String? ?? '📁',
      sortOrder: json['sort_order'] != null ? (json['sort_order'] is int ? json['sort_order'] : int.tryParse(json['sort_order'].toString()) ?? 0) : 0,
      businessCount: json['business_count'] != null ? (json['business_count'] is int ? json['business_count'] : int.tryParse(json['business_count'].toString())) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'name_ar': nameAr,
      'parent_id': parentId,
      'icon': icon,
      'sort_order': sortOrder,
      'business_count': businessCount,
    };
  }
  
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      nameEn: nameEn,
      nameAr: nameAr,
      parentId: parentId,
      icon: icon,
      sortOrder: sortOrder,
      businessCount: businessCount,
    );
  }
}
