import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justfind_app/routes/app_routes.dart';
import '../../domain/entities/business_entity.dart';
import '../../domain/repositories/business_repository.dart';
import '../../core/utils/snackbar_helper.dart';
import 'auth_controller.dart';

class DashboardController extends GetxController {
  final BusinessRepository _businessRepository;

  DashboardController(this._businessRepository);

  final RxList<BusinessEntity> myBusinesses = <BusinessEntity>[].obs;
  final RxList<BusinessEntity> myFavorites = <BusinessEntity>[].obs;
  final RxBool isLoadingBusinesses = false.obs;
  final RxBool isLoadingFavorites = false.obs;
  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    if (authController.isBusinessOwner) {
      fetchMyBusinesses();
    }
    fetchMyFavorites();
  }

  Future<void> fetchMyBusinesses() async {
    try {
      isLoadingBusinesses.value = true;
      // Get businesses owned by current user
      final result = await _businessRepository.getBusinesses();
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
        },
        (businesses) {
          myBusinesses.value = businesses;
        },
      );
    } finally {
      isLoadingBusinesses.value = false;
    }
  }

  Future<void> fetchMyFavorites() async {
    try {
      isLoadingFavorites.value = true;
      final result = await _businessRepository.getFavoriteBusinesses();
      
      result.fold(
        (failure) {
          final errorMsg = failure.message == 'null' ? 'Failed to load favorites' : failure.message;
          SnackbarHelper.showError('Error', errorMsg, StackTrace.current);
        },
        (favorites) {
          myFavorites.value = favorites;
        },
      );
    } catch (e, stack) {
      SnackbarHelper.showError('Error', 'Failed to load favorites: $e', stack);
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  Future<void> deleteBusiness(String businessId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Business'),
        content: const Text('Are you sure you want to delete this business?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final result = await _businessRepository.deleteBusiness(businessId);
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
        },
        (_) {
          myBusinesses.removeWhere((b) => b.id.toString() == businessId);
          SnackbarHelper.showSuccess('Success', 'Business deleted successfully');
        },
      );
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to delete business');
    }
  }

  void navigateToCreateBusiness() {
    Get.toNamed(AppRoutes.createBusiness);
  }

  void navigateToEditBusiness(String businessId) {
    Get.toNamed(AppRoutes.editBusiness.replaceAll(':id', businessId));
  }

  void navigateToBusinessDetail(String businessId) {
    Get.toNamed(AppRoutes.businessDetail.replaceAll(':id', businessId));
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void refreshData() {
    final authController = Get.find<AuthController>();
    if (authController.isBusinessOwner) {
      fetchMyBusinesses();
    }
    fetchMyFavorites();
  }
}
