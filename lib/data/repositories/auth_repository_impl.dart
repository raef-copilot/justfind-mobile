import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveToken(result['token']);
      await localDataSource.saveUser(result['user']);
      return Right(result['user']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String nameEn,
    required String nameAr,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final result = await remoteDataSource.register(
        nameEn: nameEn,
        nameAr: nameAr,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      await localDataSource.saveToken(result['token']);
      await localDataSource.saveUser(result['user']);
      return Right(result['user']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearToken();
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? nameEn,
    String? nameAr,
    String? email,
    String? phone,
  }) async {
    try {
      final user = await remoteDataSource.updateProfile(
        nameEn: nameEn ?? '',
        nameAr: nameAr ?? '',
        email: email,
        phone: phone,
      );
      await localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
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
