import 'package:justfind_app/core/constants/api_constants.dart';
import 'package:justfind_app/core/errors/exceptions.dart';
import 'package:justfind_app/core/network/dio_client.dart';
import 'package:justfind_app/data/models/user_model.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;
  
  AuthRemoteDataSource(this.dioClient);
  
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      return {
        'user': UserModel.fromJson(response.data['data']['user']),
        'token': response.data['data']['token'],
      };
    } catch (e) {
      throw ServerException('Login failed');
    }
  }
  
  Future<Map<String, dynamic>> register({
    required String nameEn,
    required String nameAr,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.register,
        data: {
          'name_en': nameEn,
          'name_ar': nameAr,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        },
      );
      
      return {
        'user': UserModel.fromJson(response.data['data']['user']),
        'token': response.data['data']['token'],
      };
    } catch (e) {
      throw ServerException('Registration failed');
    }
  }
  
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.get(ApiConstants.me);
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException('Failed to get user data');
    }
  }

  Future<UserModel> updateProfile({
    String? nameEn,
    String? nameAr,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await dioClient.put(
        ApiConstants.me,
        data: {
          if (nameEn != null) 'name_en': nameEn,
          if (nameAr != null) 'name_ar': nameAr,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
        },
      );
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException('Failed to update profile');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await dioClient.put(
        '${ApiConstants.me}/password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      throw ServerException('Failed to change password');
    }
  }
}
