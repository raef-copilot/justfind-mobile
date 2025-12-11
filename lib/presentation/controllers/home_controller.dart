import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../core/utils/snackbar_helper.dart';

class HomeController extends GetxController {
  final CategoryRepository _categoryRepository;

  HomeController(this._categoryRepository);

  final RxList<CategoryEntity> popularCategories = <CategoryEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularCategories();
  }

  Future<void> fetchPopularCategories() async {
    try {
      isLoading.value = true;
      final result = await _categoryRepository.getCategories();
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message, StackTrace.current);
        },
        (categories) {
          // Sort by business count and take top 8
          categories.sort((a, b) => (b.businessCount ?? 0).compareTo(a.businessCount ?? 0));
          popularCategories.value = categories.take(8).toList();
        },
      );
    } catch (e, stack) {
      SnackbarHelper.showError('Error', 'Failed to load categories: $e', stack);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToSearch() {
    if (searchQuery.value.trim().isEmpty) {
      SnackbarHelper.showError('Error', 'Please enter a search term');
      return;
    }
    Get.toNamed(AppRoutes.businessList, arguments: {'query': searchQuery.value});
  }

  void navigateToCategory(String categoryId) {
    Get.toNamed(AppRoutes.businessList, arguments: {'categoryId': categoryId});
  }

  void navigateToAllCategories() {
    Get.toNamed(AppRoutes.categories);
  }
}
