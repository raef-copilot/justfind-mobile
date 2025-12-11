import 'package:flutter/material.dart';
import '../../../domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(category.name),
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              
              // Name
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // Business Count
              Text(
                '${category.businessCount}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    
    if (name.contains('restaurant') || name.contains('food')) {
      return Icons.restaurant;
    } else if (name.contains('hotel') || name.contains('accommodation')) {
      return Icons.hotel;
    } else if (name.contains('hospital') || name.contains('health') || name.contains('medical')) {
      return Icons.local_hospital;
    } else if (name.contains('shop') || name.contains('store') || name.contains('retail')) {
      return Icons.shopping_bag;
    } else if (name.contains('education') || name.contains('school') || name.contains('college')) {
      return Icons.school;
    } else if (name.contains('beauty') || name.contains('salon') || name.contains('spa')) {
      return Icons.spa;
    } else if (name.contains('gym') || name.contains('fitness')) {
      return Icons.fitness_center;
    } else if (name.contains('cafe') || name.contains('coffee')) {
      return Icons.local_cafe;
    } else if (name.contains('auto') || name.contains('car') || name.contains('vehicle')) {
      return Icons.directions_car;
    } else if (name.contains('real estate') || name.contains('property')) {
      return Icons.home;
    } else if (name.contains('bank') || name.contains('finance')) {
      return Icons.account_balance;
    } else if (name.contains('entertainment') || name.contains('movie') || name.contains('cinema')) {
      return Icons.movie;
    } else if (name.contains('travel') || name.contains('tourism')) {
      return Icons.flight;
    } else if (name.contains('pet')) {
      return Icons.pets;
    } else if (name.contains('service')) {
      return Icons.build;
    } else {
      return Icons.category;
    }
  }
}
