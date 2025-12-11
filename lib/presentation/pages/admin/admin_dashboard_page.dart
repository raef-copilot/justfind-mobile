import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../widgets/business/business_card.dart';
import '../../widgets/business/review_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class AdminDashboardPage extends GetView<AdminController> {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.refreshAll,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending Businesses'),
              Tab(text: 'Pending Reviews'),
              Tab(text: 'Stats'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPendingBusinessesTab(context),
            _buildPendingReviewsTab(context),
            _buildStatsTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBusinessesTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingBusinesses.value && controller.pendingBusinesses.isEmpty) {
        return const LoadingWidget();
      }
      
      if (controller.pendingBusinesses.isEmpty) {
        return const EmptyStateWidget(
          icon: Icons.business,
          title: 'No Pending Businesses',
          message: 'All businesses have been reviewed',
        );
      }
      
      return RefreshIndicator(
        onRefresh: () => controller.fetchPendingBusinesses(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.pendingBusinesses.length,
          itemBuilder: (context, index) {
            final business = controller.pendingBusinesses[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                child: Column(
                  children: [
                    BusinessCard(
                      business: business,
                      onTap: () => controller.navigateToBusinessDetail(business.id.toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.approveBusiness(business.id.toString()),
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.rejectBusiness(business.id.toString()),
                              icon: const Icon(Icons.close),
                              label: const Text('Reject'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ),
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

  Widget _buildPendingReviewsTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingReviews.value && controller.pendingReviews.isEmpty) {
        return const LoadingWidget();
      }
      
      if (controller.pendingReviews.isEmpty) {
        return const EmptyStateWidget(
          icon: Icons.rate_review,
          title: 'No Pending Reviews',
          message: 'All reviews have been reviewed',
        );
      }
      
      return RefreshIndicator(
        onRefresh: () => controller.fetchPendingReviews(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.pendingReviews.length,
          itemBuilder: (context, index) {
            final review = controller.pendingReviews[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                child: Column(
                  children: [
                    ReviewCard(review: review),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.approveReview(review.id.toString()),
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => controller.rejectReview(review.id.toString()),
                              icon: const Icon(Icons.close),
                              label: const Text('Reject'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ),
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

  Widget _buildStatsTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingStats.value && controller.stats.isEmpty) {
        return const LoadingWidget();
      }
      
      return RefreshIndicator(
        onRefresh: () => controller.fetchStats(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Platform Statistics',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(
                  context,
                  'Total Businesses',
                  controller.stats['totalBusinesses']?.toString() ?? '0',
                  Icons.business,
                  Colors.blue,
                ),
                _buildStatCard(
                  context,
                  'Total Users',
                  controller.stats['totalUsers']?.toString() ?? '0',
                  Icons.people,
                  Colors.green,
                ),
                _buildStatCard(
                  context,
                  'Total Reviews',
                  controller.stats['totalReviews']?.toString() ?? '0',
                  Icons.rate_review,
                  Colors.orange,
                ),
                _buildStatCard(
                  context,
                  'Pending Approvals',
                  ((controller.stats['pendingBusinesses'] ?? 0) + 
                   (controller.stats['pendingReviews'] ?? 0)).toString(),
                  Icons.pending_actions,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
