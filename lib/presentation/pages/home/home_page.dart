import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/category/category_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_text_field.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('JustFind'),
        actions: [
          Obx(() => authController.isAuthenticated.value
              ? IconButton(
                  icon: const Icon(Icons.dashboard),
                  onPressed: () => Get.toNamed(AppRoutes.dashboard),
                )
              : IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () => Get.toNamed(AppRoutes.login),
                )),
          Obx(() => authController.isAdmin
              ? IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () => Get.toNamed(AppRoutes.adminDashboard),
                )
              : const SizedBox()),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Get.toNamed(AppRoutes.profile);
                  break;
                case 'logout':
                  authController.logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              if (authController.isAuthenticated.value) ...[
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchPopularCategories(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Find Local Businesses',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover the best services near you',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for businesses...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              controller.searchQuery.value = searchController.text;
                              controller.navigateToSearch();
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onSubmitted: (value) {
                          controller.searchQuery.value = value;
                          controller.navigateToSearch();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Popular Categories Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Categories',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextButton(
                          onPressed: controller.navigateToAllCategories,
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const LoadingWidget();
                      }
                      
                      if (controller.popularCategories.isEmpty) {
                        return const Center(
                          child: Text('No categories available'),
                        );
                      }
                      
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: controller.popularCategories.length,
                        itemBuilder: (context, index) {
                          final category = controller.popularCategories[index];
                          return CategoryCard(
                            category: category,
                            onTap: () => controller.navigateToCategory(category.id.toString()),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
              
              // Call to Action
              Container(
                margin: const EdgeInsets.all(24.0),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.business,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Own a Business?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'List your business on JustFind and reach more customers',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (authController.isAuthenticated.value) {
                          Get.toNamed(AppRoutes.createBusiness);
                        } else {
                          Get.toNamed(AppRoutes.register);
                        }
                      },
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
