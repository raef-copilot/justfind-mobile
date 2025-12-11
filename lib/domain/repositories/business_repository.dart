import 'package:dartz/dartz.dart';
import 'package:justfind_app/core/errors/failures.dart';
import 'package:justfind_app/domain/entities/business_entity.dart';

abstract class BusinessRepository {
  Future<Either<Failure, List<BusinessEntity>>> getBusinesses({
    String? category,
    String? search,
    double? latitude,
    double? longitude,
    int? radius,
  });
  
  Future<Either<Failure, BusinessEntity>> getBusinessById(String id);
  
  Future<Either<Failure, BusinessEntity>> createBusiness({
    required String name,
    required String description,
    required String categoryId,
    required String address,
    required double latitude,
    required double longitude,
    required String phone,
    String? email,
    String? website,
    String? imagePath,
  });
  
  Future<Either<Failure, BusinessEntity>> updateBusiness({
    required String id,
    String? name,
    String? description,
    String? categoryId,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? website,
    String? imagePath,
  });
  
  Future<Either<Failure, void>> deleteBusiness(String id);
  
  Future<Either<Failure, List<BusinessEntity>>> getFavoriteBusinesses();
  
  Future<Either<Failure, void>> addToFavorites(String businessId);
  
  Future<Either<Failure, void>> removeFromFavorites(String businessId);
}
