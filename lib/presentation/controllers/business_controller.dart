import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../domain/entities/business_entity.dart';
import '../../domain/repositories/business_repository.dart';
import '../../core/utils/snackbar_helper.dart';

class BusinessController extends GetxController {
  final BusinessRepository _businessRepository;

  BusinessController(this._businessRepository);

  final RxList<BusinessEntity> businesses = <BusinessEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get arguments if passed from navigation
    if (Get.arguments != null) {
      searchQuery.value = Get.arguments['query'] ?? '';
      selectedCategoryId.value = Get.arguments['categoryId'] ?? '';
      selectedCity.value = Get.arguments['city'] ?? '';
    }
    searchBusinesses();
  }

  Future<void> searchBusinesses({bool loadMore = false}) async {
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      
      if (!loadMore) {
        businesses.clear();
        hasMore.value = true;
      }
      
      final result = await _businessRepository.getBusinesses(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        category: selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value,
      );
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message, StackTrace.current);
          hasMore.value = false;
        },
        (newBusinesses) {
          if (loadMore) {
            businesses.addAll(newBusinesses);
          } else {
            businesses.value = newBusinesses;
          }
          // If we got fewer results than expected or no results, there's no more data
          hasMore.value = newBusinesses.isNotEmpty && newBusinesses.length >= 10;
        },
      );
    } catch (e, stack) {
      SnackbarHelper.showError('Error', 'Failed to load businesses: $e', stack);
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    searchBusinesses();
  }

  void updateCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    searchBusinesses();
  }

  void updateCity(String city) {
    selectedCity.value = city;
    searchBusinesses();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCategoryId.value = '';
    selectedCity.value = '';
    searchBusinesses();
  }

  Future<void> loadMoreBusinesses() async {
    await searchBusinesses(loadMore: true);
  }

  void navigateToDetail(String businessId) {
    Get.toNamed(AppRoutes.businessDetail.replaceAll(':id', businessId));
  }
}
