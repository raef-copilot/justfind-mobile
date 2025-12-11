import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justfind_app/core/themes/app_theme.dart';
import 'package:justfind_app/presentation/controllers/auth_controller.dart';
import 'package:justfind_app/routes/app_pages.dart';
import 'package:justfind_app/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return GetMaterialApp(
      title: 'JustFind',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Routing
      initialRoute: authController.isAuthenticated.value 
          ? AppRoutes.home 
          : AppRoutes.login,
      getPages: AppPages.pages,
      
      // Localization
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      
      // Default transitions
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
