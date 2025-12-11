import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:justfind_app/core/network/dio_client.dart';
import 'package:justfind_app/data/datasources/auth_local_data_source.dart';
import 'package:justfind_app/data/datasources/auth_remote_data_source.dart';
import 'package:justfind_app/data/datasources/business_remote_data_source.dart';
import 'package:justfind_app/data/datasources/category_remote_data_source.dart';
import 'package:justfind_app/data/datasources/review_remote_data_source.dart';
import 'package:justfind_app/data/repositories/auth_repository_impl.dart';
import 'package:justfind_app/data/repositories/business_repository_impl.dart';
import 'package:justfind_app/data/repositories/category_repository_impl.dart';
import 'package:justfind_app/data/repositories/review_repository_impl.dart';
import 'package:justfind_app/domain/repositories/auth_repository.dart';
import 'package:justfind_app/domain/repositories/business_repository.dart';
import 'package:justfind_app/domain/repositories/category_repository.dart';
import 'package:justfind_app/domain/repositories/review_repository.dart';
import 'package:justfind_app/presentation/controllers/auth_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Initialize GetStorage
    await GetStorage.init();
    
    // Core
    Get.lazyPut(() => GetStorage(), fenix: true);
    Get.lazyPut(() => DioClient(), fenix: true);
    
    // Data Sources
    Get.lazyPut(() => AuthLocalDataSource(Get.find()), fenix: true);
    Get.lazyPut(() => AuthRemoteDataSource(Get.find()), fenix: true);
    Get.lazyPut<BusinessRemoteDataSource>(
      () => BusinessRemoteDataSourceImpl(dioClient: Get.find()),
      fenix: true,
    );
    Get.lazyPut<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(dioClient: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ReviewRemoteDataSource>(
      () => ReviewRemoteDataSourceImpl(dioClient: Get.find()),
      fenix: true,
    );
    
    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
      fenix: true,
    );
    
    Get.lazyPut<BusinessRepository>(
      () => BusinessRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    
    Get.lazyPut<ReviewRepository>(
      () => ReviewRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    
    // Controllers (Permanent)
    Get.put(
      AuthController(Get.find<AuthRepository>(), Get.find<AuthLocalDataSource>()),
      permanent: true,
    );
  }
}
