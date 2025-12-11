import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justfind_app/presentation/controllers/auth_controller.dart';
import 'package:justfind_app/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  final bool requireAdmin;
  
  AuthMiddleware({this.requireAdmin = false});
  
  @override
  int? get priority => 1;
  
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // Check if user is authenticated
    if (!authController.isAuthenticated.value) {
      return const RouteSettings(name: AppRoutes.login);
    }
    
    // Check if admin access is required
    if (requireAdmin && !authController.isAdmin) {
      Get.snackbar(
        'Access Denied',
        'You need admin privileges to access this page',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return const RouteSettings(name: AppRoutes.home);
    }
    
    return null;
  }
}
