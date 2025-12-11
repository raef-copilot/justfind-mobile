class CategoryEntity {
  final int id;
  final String name;
  final String nameEn;
  final String nameAr;
  final int? parentId;
  final String icon;
  final int sortOrder;
  final int? businessCount;
  
  CategoryEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    this.parentId,
    required this.icon,
    required this.sortOrder,
    this.businessCount,
  });
  
  String get displayName => nameEn.isNotEmpty ? nameEn : nameAr;
}
