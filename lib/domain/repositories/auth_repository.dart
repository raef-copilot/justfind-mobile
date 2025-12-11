import 'package:dartz/dartz.dart';
import 'package:justfind_app/core/errors/failures.dart';
import 'package:justfind_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, UserEntity>> register({
    required String nameEn,
    required String nameAr,
    required String email,
    required String phone,
    required String password,
    required String role,
  });
  
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  
  Future<Either<Failure, void>> logout();
  
  Future<Either<Failure, String?>> getToken();
  
  Future<Either<Failure, bool>> isLoggedIn();
  
  Future<Either<Failure, UserEntity>> updateProfile({
    String? nameEn,
    String? nameAr,
    String? email,
    String? phone,
  });
  
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
