import 'package:get/get.dart';
import 'package:justfind_app/domain/repositories/business_repository.dart';
import 'package:justfind_app/domain/repositories/category_repository.dart';
import 'package:justfind_app/domain/repositories/review_repository.dart';
import 'package:justfind_app/presentation/controllers/admin_controller.dart';
import 'package:justfind_app/presentation/controllers/auth_controller.dart';
import 'package:justfind_app/presentation/controllers/business_controller.dart';
import 'package:justfind_app/presentation/controllers/business_detail_controller.dart';
import 'package:justfind_app/presentation/controllers/category_controller.dart';
import 'package:justfind_app/presentation/controllers/dashboard_controller.dart';
import 'package:justfind_app/presentation/controllers/home_controller.dart';
import 'package:justfind_app/presentation/pages/admin/admin_dashboard_page.dart';
import 'package:justfind_app/presentation/pages/auth/login_page.dart';
import 'package:justfind_app/presentation/pages/auth/register_page.dart';
import 'package:justfind_app/presentation/pages/business/business_detail_page.dart';
import 'package:justfind_app/presentation/pages/business/business_list_page.dart';
import 'package:justfind_app/presentation/pages/category/categories_page.dart';
import 'package:justfind_app/presentation/pages/dashboard/create_business_page.dart';
import 'package:justfind_app/presentation/pages/dashboard/dashboard_page.dart';
import 'package:justfind_app/presentation/pages/dashboard/edit_business_page.dart';
import 'package:justfind_app/presentation/pages/home/home_page_new.dart';
import 'package:justfind_app/presentation/pages/profile/profile_page.dart';
import 'package:justfind_app/routes/app_routes.dart';
import 'package:justfind_app/routes/auth_middleware.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
    ),
    
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
    ),
    
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePageNew(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController(Get.find<CategoryRepository>()));
      }),
    ),
    
    GetPage(
      name: AppRoutes.businessList,
      page: () => BusinessListPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => BusinessController(Get.find<BusinessRepository>()));
        Get.lazyPut(() => CategoryController(Get.find<CategoryRepository>()));
      }),
    ),
    
    // Important: Specific routes MUST come before parameterized routes
    GetPage(
      name: AppRoutes.createBusiness,
      page: () => CreateBusinessPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CategoryController(Get.find<CategoryRepository>()));
      }),
      middlewares: [AuthMiddleware()],
    ),
    
    GetPage(
      name: AppRoutes.editBusiness,
      page: () => EditBusinessPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CategoryController(Get.find<CategoryRepository>()));
      }),
      middlewares: [AuthMiddleware()],
    ),
    
    // Parameterized route comes AFTER specific routes
    GetPage(
      name: AppRoutes.businessDetail,
      page: () => BusinessDetailPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => BusinessDetailController(
          Get.find<BusinessRepository>(),
          Get.find<ReviewRepository>(),
        ));
      }),
    ),
    
    GetPage(
      name: AppRoutes.categories,
      page: () => CategoriesPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CategoryController(Get.find<CategoryRepository>()));
      }),
    ),
    
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashboardController(Get.find<BusinessRepository>()));
      }),
      middlewares: [AuthMiddleware()],
    ),
    
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      middlewares: [AuthMiddleware()],
    ),
    
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => AdminDashboardPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AdminController(
          Get.find<BusinessRepository>(),
          Get.find<ReviewRepository>(),
        ));
      }),
      middlewares: [AuthMiddleware(requireAdmin: true)],
    ),
  ];
}
