import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../widgets/category/category_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class CategoriesPage extends GetView<CategoryController> {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    controller.searchCategories('');
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => controller.searchCategories(value),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }
        
        if (controller.filteredCategories.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.category_outlined,
            title: 'No Categories Found',
            message: controller.searchQuery.value.isEmpty
                ? 'No categories available'
                : 'Try a different search term',
            actionText: controller.searchQuery.value.isNotEmpty ? 'Clear Search' : null,
            onAction: () {
              searchController.clear();
              controller.searchCategories('');
            },
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => controller.fetchCategories(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: controller.filteredCategories.length,
            itemBuilder: (context, index) {
              final category = controller.filteredCategories[index];
              return CategoryCard(
                category: category,
                onTap: () => controller.navigateToCategoryBusinesses(category.id.toString()),
              );
            },
          ),
        );
      }),
    );
  }
}
