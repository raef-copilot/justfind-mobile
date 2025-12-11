import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/category/category_card.dart';
import '../../widgets/common/loading_widget.dart';

class HomePageNew extends GetView<HomeController> {
  const HomePageNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('JustFind'),
          ],
        ),
        actions: [
          // Language Toggle
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Toggle between English and Arabic
              final currentLocale = Get.locale?.languageCode ?? 'en';
              Get.updateLocale(
                currentLocale == 'en' ? const Locale('ar') : const Locale('en'),
              );
            },
            tooltip: 'Change Language',
          ),
          
          // Theme Toggle
          IconButton(
            icon: Icon(
              Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
            tooltip: 'Toggle Theme',
          ),
          
          // User Actions
          Obx(() => authController.isAuthenticated.value
              ? PopupMenuButton<String>(
                  icon: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'dashboard':
                        Get.toNamed(AppRoutes.dashboard);
                        break;
                      case 'profile':
                        Get.toNamed(AppRoutes.profile);
                        break;
                      case 'admin':
                        Get.toNamed(AppRoutes.adminDashboard);
                        break;
                      case 'logout':
                        authController.logout();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'dashboard',
                      child: ListTile(
                        leading: Icon(Icons.dashboard),
                        title: Text('My Dashboard'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'profile',
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    if (authController.isAdmin)
                      const PopupMenuItem(
                        value: 'admin',
                        child: ListTile(
                          leading: Icon(Icons.admin_panel_settings),
                          title: Text('Admin Panel'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text('Logout', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )
              : TextButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  onPressed: () => Get.toNamed(AppRoutes.login),
                )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchPopularCategories(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Banner Carousel
              _buildSearchBar(context, searchController),

              _buildBannerCarousel(context),
              
              // Search Bar

              // Quick Actions
              _buildQuickActions(context, authController),
              
              // Popular Categories
              _buildPopularCategories(context),
              
              // Featured Businesses
              _buildFeaturedBusinesses(context),
              
              // Call to Action
              _buildCallToAction(context, authController),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() => authController.isAuthenticated.value
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(AppRoutes.createBusiness),
              icon: const Icon(Icons.add_business),
              label: const Text('Add Business'),
            )
          : const SizedBox()),
    );
  }

  Widget _buildBannerCarousel(BuildContext context) {
    final banners = [
      {
        'title': 'Discover Local Services',
        'subtitle': 'Find the best businesses near you',
        'color': Colors.blue,
        'icon': Icons.search,
      },
      {
        'title': 'Top Rated Businesses',
        'subtitle': 'Trusted by thousands of customers',
        'color': Colors.purple,
        'icon': Icons.star,
      },
      {
        'title': 'List Your Business',
        'subtitle': 'Grow your business with JustFind',
        'color': Colors.orange,
        'icon': Icons.business,
      },
    ];

    return _BannerCarousel(banners: banners);
  }

  Widget _buildSearchBar(BuildContext context, TextEditingController searchController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search businesses, services, categories...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {},
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
    );
  }

  Widget _buildQuickActions(BuildContext context, AuthController authController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              context,
              icon: Icons.store,
              label: 'My Store',
              color: Colors.blue,
              onTap: () => controller.navigateToAllCategories(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              context,
              icon: Icons.favorite,
              label: 'Favorites',
              color: Colors.red,
              onTap: () => authController.isAuthenticated.value
                  ? Get.toNamed(AppRoutes.dashboard)
                  : Get.toNamed(AppRoutes.login),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              context,
              icon: Icons.local_offer,
              label: 'Offers',
              color: Colors.orange,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              context,
              icon: Icons.location_on,
              label: 'Nearby',
              color: Colors.green,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
              TextButton.icon(
                onPressed: controller.navigateToAllCategories,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('See All'),
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
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: controller.popularCategories.length > 6
                  ? 6
                  : controller.popularCategories.length,
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
    );
  }

  Widget _buildFeaturedBusinesses(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Businesses',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.business,
                            size: 48,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Featured Business ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '4.${5 - index}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToAction(BuildContext context, AuthController authController) {
    return Container(
      margin: const EdgeInsets.all(16.0),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.business_center,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Grow Your Business',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join thousands of businesses on JustFind',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton.icon(
                onPressed: () {
                  if (authController.isAuthenticated.value) {
                    Get.toNamed(AppRoutes.createBusiness);
                  } else {
                    Get.toNamed(AppRoutes.register);
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  authController.isAuthenticated.value
                      ? 'Add Your Business'
                      : 'Get Started Now',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> banners;

  const _BannerCarousel({required this.banners});

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < widget.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: widget.banners.length,
        itemBuilder: (context, index) {
          final banner = widget.banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  banner['color'] as Color,
                  (banner['color'] as Color).withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          banner['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner['subtitle'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    banner['icon'] as IconData,
                    size: 64,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
