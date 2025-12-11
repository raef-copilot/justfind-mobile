import 'package:get/get.dart';
import 'package:justfind_app/routes/app_routes.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../core/utils/snackbar_helper.dart';

class CategoryController extends GetxController {
  final CategoryRepository _categoryRepository;

  CategoryController(this._categoryRepository);

  final RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  final RxList<CategoryEntity> filteredCategories = <CategoryEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final result = await _categoryRepository.getCategories();
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message, StackTrace.current);
        },
        (categoryList) {
          categories.value = categoryList;
          filteredCategories.value = categoryList;
        },
      );
    } catch (e, stack) {
      SnackbarHelper.showError('Error', 'Failed to load categories: $e', stack);
    } finally {
      isLoading.value = false;
    }
  }

  void searchCategories(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories
          .where((category) =>
              category.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void navigateToCategoryBusinesses(String categoryId) {
    Get.toNamed(AppRoutes.businessList, arguments: {'categoryId': categoryId});
  }
}
