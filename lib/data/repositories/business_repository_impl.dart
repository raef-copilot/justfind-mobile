import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/business_entity.dart';
import '../../domain/repositories/business_repository.dart';
import '../datasources/business_remote_data_source.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessRemoteDataSource remoteDataSource;

  BusinessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BusinessEntity>>> getBusinesses({
    String? category,
    String? search,
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    try {
      final businesses = await remoteDataSource.getBusinesses(
        category: category,
        search: search,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
      return Right(businesses);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BusinessEntity>> getBusinessById(String id) async {
    try {
      final business = await remoteDataSource.getBusinessById(id);
      return Right(business);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final business = await remoteDataSource.createBusiness(
        name: name,
        description: description,
        categoryId: categoryId,
        address: address,
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        email: email,
        website: website,
        imagePath: imagePath,
      );
      return Right(business);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final business = await remoteDataSource.updateBusiness(
        id: id,
        name: name,
        description: description,
        categoryId: categoryId,
        address: address,
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        email: email,
        website: website,
        imagePath: imagePath,
      );
      return Right(business);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBusiness(String id) async {
    try {
      await remoteDataSource.deleteBusiness(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BusinessEntity>>> getFavoriteBusinesses() async {
    try {
      final businesses = await remoteDataSource.getFavoriteBusinesses();
      return Right(businesses);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String businessId) async {
    try {
      await remoteDataSource.addToFavorites(businessId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String businessId) async {
    try {
      await remoteDataSource.removeFromFavorites(businessId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
