import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justfind_app/routes/app_routes.dart';
import '../../domain/entities/business_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/business_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../core/utils/snackbar_helper.dart';

class AdminController extends GetxController {
  final BusinessRepository _businessRepository;
  final ReviewRepository _reviewRepository;

  AdminController(this._businessRepository, this._reviewRepository);

  final RxList<BusinessEntity> pendingBusinesses = <BusinessEntity>[].obs;
  final RxList<ReviewEntity> pendingReviews = <ReviewEntity>[].obs;
  final RxBool isLoadingBusinesses = false.obs;
  final RxBool isLoadingReviews = false.obs;
  
  final RxMap<String, dynamic> stats = <String, dynamic>{}.obs;
  final RxBool isLoadingStats = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingBusinesses();
    fetchPendingReviews();
    fetchStats();
  }

  Future<void> fetchPendingBusinesses() async {
    try {
      isLoadingBusinesses.value = true;
      // Get all businesses and filter by status
      final result = await _businessRepository.getBusinesses();
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
        },
        (businesses) {
          pendingBusinesses.value = businesses.where((b) => b.isPending).toList();
        },
      );
    } finally {
      isLoadingBusinesses.value = false;
    }
  }

  Future<void> fetchPendingReviews() async {
    try {
      isLoadingReviews.value = true;
      // Note: This would need a getReviews method in ReviewRepository
      // For now, just clear the list
      pendingReviews.clear();
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> fetchStats() async {
    try {
      isLoadingStats.value = true;
      // Mock stats - implement actual API call if available
      await Future.delayed(const Duration(milliseconds: 500));
      stats.value = {
        'totalBusinesses': 150,
        'totalUsers': 500,
        'totalReviews': 320,
        'pendingBusinesses': pendingBusinesses.length,
        'pendingReviews': pendingReviews.length,
      };
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> approveBusiness(String businessId) async {
    try {
      // TODO: Implement approve business endpoint in backend and repository
      SnackbarHelper.showInfo('Info', 'Approve business feature not yet implemented');
      pendingBusinesses.removeWhere((b) => b.id.toString() == businessId);
      fetchStats();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to approve business');
    }
  }

  Future<void> rejectBusiness(String businessId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reject Business'),
        content: const Text('Are you sure you want to reject this business?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // TODO: Implement reject business endpoint in backend and repository
      SnackbarHelper.showInfo('Info', 'Reject business feature not yet implemented');
      pendingBusinesses.removeWhere((b) => b.id.toString() == businessId);
      fetchStats();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to reject business');
    }
  }

  Future<void> approveReview(String reviewId) async {
    try {
      // TODO: Implement approve review endpoint in backend and repository
      SnackbarHelper.showInfo('Info', 'Approve review feature not yet implemented');
      pendingReviews.removeWhere((r) => r.id.toString() == reviewId);
      fetchStats();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to approve review');
    }
  }

  Future<void> rejectReview(String reviewId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reject Review'),
        content: const Text('Are you sure you want to reject this review?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // TODO: Implement reject review endpoint in backend and repository
      SnackbarHelper.showInfo('Info', 'Reject review feature not yet implemented');
      pendingReviews.removeWhere((r) => r.id.toString() == reviewId);
      fetchStats();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to reject review');
    }
  }

  void navigateToBusinessDetail(String businessId) {
    Get.toNamed(AppRoutes.businessDetail.replaceAll(':id', businessId));
  }

  void refreshAll() {
    fetchPendingBusinesses();
    fetchPendingReviews();
    fetchStats();
  }
}
