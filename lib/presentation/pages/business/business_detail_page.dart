import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/business_detail_controller.dart';
import '../../widgets/business/rating_stars.dart';
import '../../widgets/business/review_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class BusinessDetailPage extends GetView<BusinessDetailController> {
  const BusinessDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.business.value == null) {
          return const LoadingWidget();
        }
        
        final business = controller.business.value;
        if (business == null) {
          return const Center(child: Text('Business not found'));
        }
        
        return CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: business.images.isNotEmpty
                    ? PageView.builder(
                        itemCount: business.images.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: business.images[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.business, size: 80),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.business, size: 80),
                      ),
              ),
              actions: [
                Obx(() => IconButton(
                      icon: Icon(
                        controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: controller.isTogglingFavorite.value
                          ? null
                          : controller.toggleFavorite,
                    )),
              ],
            ),
            
            // Business Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            business.name,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: business.status == 'approved'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            business.status.toUpperCase(),
                            style: TextStyle(
                              color: business.status == 'approved' ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Rating
                    Row(
                      children: [
                        RatingStars(rating: business.averageRating ?? business.rating),
                        const SizedBox(width: 8),
                        Text(
                          '${(business.averageRating ?? business.rating).toStringAsFixed(1)} (${business.totalReviews ?? business.reviewCount} reviews)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      business.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    
                    // Contact Information
                    _buildInfoSection(
                      context,
                      'Contact Information',
                      [
                        _buildInfoRow(Icons.phone, business.phone),
                        if (business.email != null)
                          _buildInfoRow(Icons.email, business.email!),
                        if (business.website != null && business.website!.isNotEmpty)
                          _buildInfoRow(Icons.language, business.website!),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Address
                    _buildInfoSection(
                      context,
                      'Address',
                      [
                        _buildInfoRow(Icons.location_on, business.address),
                        if (business.city != null)
                          _buildInfoRow(Icons.location_city, business.city!),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Opening Hours
                    if (business.openingHours != null && business.openingHours!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'Opening Hours',
                        [_buildInfoRow(Icons.access_time, business.openingHours!)],
                      ),
                    const SizedBox(height: 24),
                    
                    // Reviews Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reviews',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.rate_review),
                          label: const Text('Write Review'),
                          onPressed: controller.showReviewDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            
            // Reviews List
            Obx(() {
              if (controller.isLoadingReviews.value && controller.reviews.isEmpty) {
                return const SliverToBoxAdapter(child: LoadingWidget());
              }
              
              if (controller.reviews.isEmpty) {
                return SliverToBoxAdapter(
                  child: EmptyStateWidget(
                    icon: Icons.rate_review,
                    title: 'No Reviews Yet',
                    message: 'Be the first to review this business',
                    actionText: 'Write Review',
                    onAction: controller.showReviewDialog,
                  ),
                );
              }
              
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final review = controller.reviews[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ReviewCard(review: review),
                    );
                  },
                  childCount: controller.reviews.length,
                ),
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
