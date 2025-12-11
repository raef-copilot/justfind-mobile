import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/business/business_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Obx(() {
            final isBusinessOwner = authController.currentUser.value?.isBusinessOwner ?? false;
            
            if (!isBusinessOwner) {
              return const SizedBox.shrink();
            }
            
            return Container(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.changeTab(0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.selectedTabIndex.value == 0
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        foregroundColor: controller.selectedTabIndex.value == 0
                            ? Colors.white
                            : Colors.black87,
                      ),
                      child: const Text('My Businesses'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.changeTab(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.selectedTabIndex.value == 1
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        foregroundColor: controller.selectedTabIndex.value == 1
                            ? Colors.white
                            : Colors.black87,
                      ),
                      child: const Text('Favorites'),
                    ),
                  ),
                ],
              ),
            );
          }),
          
          // Content
          Expanded(
            child: Obx(() {
              final isBusinessOwner = authController.currentUser.value?.isBusinessOwner ?? false;
              
              if (isBusinessOwner && controller.selectedTabIndex.value == 0) {
                return _buildMyBusinessesTab(context);
              } else {
                return _buildFavoritesTab(context);
              }
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final isBusinessOwner = authController.currentUser.value?.isBusinessOwner ?? false;
        
        if (isBusinessOwner && controller.selectedTabIndex.value == 0) {
          return FloatingActionButton.extended(
            onPressed: controller.navigateToCreateBusiness,
            icon: const Icon(Icons.add),
            label: const Text('Add Business'),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildMyBusinessesTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingBusinesses.value && controller.myBusinesses.isEmpty) {
        return const LoadingWidget();
      }
      
      if (controller.myBusinesses.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.business,
          title: 'No Businesses Yet',
          message: 'Start by adding your first business',
          actionText: 'Add Business',
          onAction: controller.navigateToCreateBusiness,
        );
      }
      
      return RefreshIndicator(
        onRefresh: () => controller.fetchMyBusinesses(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.myBusinesses.length,
          itemBuilder: (context, index) {
            final business = controller.myBusinesses[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: BusinessCard(
                business: business,
                onTap: () => controller.navigateToBusinessDetail(business.id.toString()),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        controller.navigateToEditBusiness(business.id.toString());
                        break;
                      case 'delete':
                        controller.deleteBusiness(business.id.toString());
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildFavoritesTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingFavorites.value && controller.myFavorites.isEmpty) {
        return const LoadingWidget();
      }
      
      if (controller.myFavorites.isEmpty) {
        return const EmptyStateWidget(
          icon: Icons.favorite_border,
          title: 'No Favorites Yet',
          message: 'Save your favorite businesses to see them here',
        );
      }
      
      return RefreshIndicator(
        onRefresh: () => controller.fetchMyFavorites(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.myFavorites.length,
          itemBuilder: (context, index) {
            final business = controller.myFavorites[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: BusinessCard(
                business: business,
                onTap: () => controller.navigateToBusinessDetail(business.id.toString()),
              ),
            );
          },
        ),
      );
    });
  }
}
