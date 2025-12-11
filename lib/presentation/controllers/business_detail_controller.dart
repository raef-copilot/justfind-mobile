import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../domain/entities/business_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/business_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../core/utils/snackbar_helper.dart';
import 'auth_controller.dart';

class BusinessDetailController extends GetxController {
  final BusinessRepository _businessRepository;
  final ReviewRepository _reviewRepository;

  BusinessDetailController(this._businessRepository, this._reviewRepository);

  final Rx<BusinessEntity?> business = Rx<BusinessEntity?>(null);
  final RxList<ReviewEntity> reviews = <ReviewEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingReviews = false.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isTogglingFavorite = false.obs;

  late String businessId;

  @override
  void onInit() {
    super.onInit();
    businessId = Get.parameters['id'] ?? '';
    if (businessId.isNotEmpty) {
      fetchBusinessDetails();
    }
  }

  Future<void> fetchBusinessDetails() async {
    try {
      isLoading.value = true;
      isLoadingReviews.value = true;
      final result = await _businessRepository.getBusinessById(businessId);
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
          Get.back();
        },
        (businessData) {
          business.value = businessData;
          // Check if business is in user's favorites
          _checkFavoriteStatus();
          // Fetch reviews separately since they come from business detail
          _fetchReviewsFromApi();
        },
      );
    } catch (e, stack) {
      SnackbarHelper.showError('Error', 'Failed to load business: $e', stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchReviewsFromApi() async {
    // Note: Reviews are included in the business detail response
    // This separate call is optional and may fail if the reviews endpoint has issues
    try {
      final result = await _reviewRepository.getReviewsByBusinessId(businessId);
      
      result.fold(
        (failure) {
          // Reviews failed to load, but don't show error to user
          // The business detail already includes reviews
          if (kDebugMode) {
            print('Reviews API failed (optional): ${failure.message}');
          }
        },
        (reviewList) {
          reviews.value = reviewList;
        },
      );
    } catch (e) {
      // Silent fail - reviews endpoint is optional
      if (kDebugMode) {
        print('Reviews API error (optional): $e');
      }
    } finally {
      isLoadingReviews.value = false;
    }
  }

  void _checkFavoriteStatus() {
    // Check favorite status from business entity
    if (business.value != null) {
      isFavorite.value = business.value!.isFavorited;
    }
  }

  Future<void> toggleFavorite() async {
    final authController = Get.find<AuthController>();
    if (!authController.isAuthenticated.value) {
      SnackbarHelper.showError('Error', 'Please login to add favorites');
      Get.toNamed(AppRoutes.login);
      return;
    }

    try {
      isTogglingFavorite.value = true;
      final result = isFavorite.value
          ? await _businessRepository.removeFromFavorites(businessId)
          : await _businessRepository.addToFavorites(businessId);
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
        },
        (_) {
          isFavorite.value = !isFavorite.value;
          SnackbarHelper.showSuccess(
            'Success',
            isFavorite.value ? 'Added to favorites' : 'Removed from favorites',
          );
        },
      );
    } finally {
      isTogglingFavorite.value = false;
    }
  }

  Future<void> createReview({
    required int rating,
    required String comment,
  }) async {
    final authController = Get.find<AuthController>();
    if (!authController.isAuthenticated.value) {
      SnackbarHelper.showError('Error', 'Please login to write a review');
      Get.toNamed(AppRoutes.login);
      return;
    }

    try {
      isLoadingReviews.value = true;
      final result = await _reviewRepository.createReview(
        businessId: businessId,
        rating: rating,
        comment: comment,
      );
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
        },
        (review) {
          reviews.insert(0, review);
          SnackbarHelper.showSuccess('Success', 'Review submitted successfully');
          Get.back(); // Close review dialog
          fetchBusinessDetails(); // Refresh to update average rating
        },
      );
    } finally {
      isLoadingReviews.value = false;
    }
  }

  void showReviewDialog() {
    Get.dialog(
      _ReviewDialog(controller: this),
    );
  }
}

class _ReviewDialog extends StatelessWidget {
  final BusinessDetailController controller;

  const _ReviewDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    final ratingController = RxInt(5);
    final commentController = TextEditingController();

    return AlertDialog(
      title: const Text('Write a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Rating:'),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < ratingController.value ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => ratingController.value = index + 1,
              );
            }),
          )),
          const SizedBox(height: 16),
          TextField(
            controller: commentController,
            decoration: const InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (commentController.text.trim().isEmpty) {
              SnackbarHelper.showError('Error', 'Please write a comment');
              return;
            }
            controller.createReview(
              rating: ratingController.value,
              comment: commentController.text.trim(),
            );
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
