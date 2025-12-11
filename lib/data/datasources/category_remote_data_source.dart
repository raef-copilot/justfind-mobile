import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioClient dioClient;

  CategoryRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await dioClient.get(ApiConstants.categories);
    final responseData = response.data;
    final List<dynamic> data = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    final response = await dioClient.get('${ApiConstants.categories}/$id');
    final responseData = response.data;
    final data = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    return CategoryModel.fromJson(data);
  }
}
