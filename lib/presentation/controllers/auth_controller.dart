import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../data/datasources/auth_local_data_source.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final AuthLocalDataSource _localDataSource;

  AuthController(this._authRepository, this._localDataSource);

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = await _localDataSource.getToken();
      if (token != null) {
        final user = await _localDataSource.getUser();
        if (user != null) {
          currentUser.value = user;
          isAuthenticated.value = true;
        }
      }
    } catch (e) {
      // Token expired or invalid
      await logout();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final result = await _authRepository.login(email: email, password: password);
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Login Failed', failure.message);
        },
        (user) async {
          currentUser.value = user;
          isAuthenticated.value = true;
          SnackbarHelper.showSuccess('Success', 'Logged in successfully');
          Get.offAllNamed('/home');
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String nameEn,
    required String nameAr,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      final result = await _authRepository.register(
        nameEn: nameEn,
        nameAr: nameAr,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Registration Failed', failure.message);
        },
        (user) async {
          currentUser.value = user;
          isAuthenticated.value = true;
          SnackbarHelper.showSuccess('Success', 'Account created successfully');
          Get.offAllNamed('/home');
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final result = await _authRepository.logout();
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', 'Failed to logout');
        },
        (_) {
          currentUser.value = null;
          isAuthenticated.value = false;
          Get.offAllNamed('/login');
          SnackbarHelper.showSuccess('Success', 'Logged out successfully');
        },
      );
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to logout');
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    try {
      isLoading.value = true;
      final result = await _authRepository.updateProfile(
        nameEn: name,
        nameAr: name,
        email: email,
        phone: phone,
      );
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Update Failed', failure.message);
        },
        (user) async {
          if (user is UserModel) {
            await _localDataSource.saveUser(user);
          }
          currentUser.value = user;
          SnackbarHelper.showSuccess('Success', 'Profile updated successfully');
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool get isAdmin => currentUser.value?.role == 'admin';
  bool get isBusinessOwner => currentUser.value?.role == 'business_owner';
  bool get isCustomer => currentUser.value?.role == 'customer';
}
