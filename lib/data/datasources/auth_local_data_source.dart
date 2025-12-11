import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:justfind_app/core/constants/app_constants.dart';
import 'package:justfind_app/data/models/user_model.dart';

class AuthLocalDataSource {
  final GetStorage storage;
  
  AuthLocalDataSource(this.storage);
  
  Future<void> saveToken(String token) async {
    await storage.write(AppConstants.storageToken, token);
  }
  
  Future<String?> getToken() async {
    return storage.read<String>(AppConstants.storageToken);
  }
  
  Future<void> saveUser(UserModel user) async {
    await storage.write(AppConstants.storageUser, jsonEncode(user.toJson()));
  }
  
  Future<UserModel?> getUser() async {
    final userJson = storage.read<String>(AppConstants.storageUser);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }
  
  Future<void> clearToken() async {
    await storage.remove(AppConstants.storageToken);
  }
  
  Future<void> clearUser() async {
    await storage.remove(AppConstants.storageUser);
  }
  
  Future<void> clearAuth() async {
    await storage.remove(AppConstants.storageToken);
    await storage.remove(AppConstants.storageUser);
  }
}
