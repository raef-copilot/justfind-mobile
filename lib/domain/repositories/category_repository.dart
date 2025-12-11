import 'package:dartz/dartz.dart';
import 'package:justfind_app/core/errors/failures.dart';
import 'package:justfind_app/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id);
}
