import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/business_controller.dart';
import '../../widgets/business/business_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class BusinessListPage extends GetView<BusinessController> {
  const BusinessListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController(text: controller.searchQuery.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Businesses'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search businesses...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    controller.updateSearchQuery('');
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => controller.updateSearchQuery(value),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters Section
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Filter Chips
                  Obx(() => FilterChip(
                        label: Text(controller.selectedCategoryId.value.isEmpty
                            ? 'All Categories'
                            : 'Category Selected'),
                        selected: controller.selectedCategoryId.value.isNotEmpty,
                        onSelected: (selected) {
                          if (!selected) {
                            controller.updateCategory('');
                          }
                          // TODO: Show category picker dialog
                        },
                      )),
                  const SizedBox(width: 8),
                  Obx(() => FilterChip(
                        label: Text(controller.selectedCity.value.isEmpty
                            ? 'All Cities'
                            : controller.selectedCity.value),
                        selected: controller.selectedCity.value.isNotEmpty,
                        onSelected: (selected) {
                          if (!selected) {
                            controller.updateCity('');
                          }
                          // TODO: Show city picker dialog
                        },
                      )),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear Filters'),
                    onPressed: controller.clearFilters,
                  ),
                ],
              ),
            ),
          ),
          
          // Results List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.businesses.isEmpty) {
                return const LoadingWidget();
              }
              
              if (controller.businesses.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.search_off,
                  title: 'No Businesses Found',
                  message: 'Try adjusting your search or filters',
                  actionText: 'Clear Filters',
                  onAction: controller.clearFilters,
                );
              }
              
              return RefreshIndicator(
                onRefresh: () => controller.searchBusinesses(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.businesses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.businesses.length) {
                      // Load more indicator
                      if (controller.hasMore.value) {
                        if (!controller.isLoading.value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.loadMoreBusinesses();
                          });
                        }
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox();
                    }
                    
                    final business = controller.businesses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: BusinessCard(
                        business: business,
                        onTap: () => controller.navigateToDetail(business.id.toString()),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
