import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/business_model.dart';

abstract class BusinessRemoteDataSource {
  Future<List<BusinessModel>> getBusinesses({
    String? category,
    String? search,
    double? latitude,
    double? longitude,
    int? radius,
  });
  Future<BusinessModel> getBusinessById(String id);
  Future<BusinessModel> createBusiness({
    required String name,
    required String description,
    required String categoryId,
    required String address,
    required double latitude,
    required double longitude,
    required String phone,
    String? email,
    String? website,
    String? imagePath,
  });
  Future<BusinessModel> updateBusiness({
    required String id,
    String? name,
    String? description,
    String? categoryId,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? website,
    String? imagePath,
  });
  Future<void> deleteBusiness(String id);
  Future<List<BusinessModel>> getFavoriteBusinesses();
  Future<void> addToFavorites(String businessId);
  Future<void> removeFromFavorites(String businessId);
}

class BusinessRemoteDataSourceImpl implements BusinessRemoteDataSource {
  final DioClient dioClient;

  BusinessRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<BusinessModel>> getBusinesses({
    String? category,
    String? search,
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (category != null) queryParameters['category'] = category;
    if (search != null) queryParameters['search'] = search;
    if (latitude != null) queryParameters['latitude'] = latitude;
    if (longitude != null) queryParameters['longitude'] = longitude;
    if (radius != null) queryParameters['radius'] = radius;

    final response = await dioClient.get(
      ApiConstants.businesses,
      queryParameters: queryParameters,
    );

    final responseData = response.data;
    final List<dynamic> data = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    return data.map((json) => BusinessModel.fromJson(json)).toList();
  }

  @override
  Future<BusinessModel> getBusinessById(String id) async {
    final response = await dioClient.get('${ApiConstants.businesses}/$id');
    final responseData = response.data;
    final data = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    
    // Store reviews separately if they exist in the response
    if (data is Map && data['reviews'] != null) {
      _cachedReviews[id] = data['reviews'];
    }
    
    return BusinessModel.fromJson(data);
  }
  
  // Cache for storing reviews from business detail response
  static final Map<String, dynamic> _cachedReviews = {};
  
  List<dynamic>? getCachedReviews(String businessId) {
    return _cachedReviews[businessId];
  }

  @override
  Future<BusinessModel> createBusiness({
    required String name,
    required String description,
    required String categoryId,
    required String address,
    required double latitude,
    required double longitude,
    required String phone,
    String? email,
    String? website,
    String? imagePath,
  }) async {
    // Backend doesn't support image upload on create, only on update
    // Send as regular JSON instead of FormData
    final Map<String, dynamic> data = {
      'name_en': name,
      'name_ar': name,
      'description_en': description,
      'description_ar': description,
      'category_id': categoryId,
      'address_en': address,
      'address_ar': address,
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'phone': phone,
      'whatsapp': phone,
      if (email != null) 'email': email,
      if (website != null) 'website': website,
    };

    final response = await dioClient.post(
      ApiConstants.businesses,
      data: data,
    );

    final responseData = response.data;
    final finalData = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    return BusinessModel.fromJson(finalData);
  }

  @override
  Future<BusinessModel> updateBusiness({
    required String id,
    String? name,
    String? description,
    String? categoryId,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? website,
    String? imagePath,
  }) async {
    final Map<String, dynamic> fields = {};
    if (name != null) {
      fields['name_en'] = name;
      fields['name_ar'] = name;
    }
    if (description != null) {
      fields['description_en'] = description;
      fields['description_ar'] = description;
    }
    if (categoryId != null) fields['category_id'] = categoryId;
    if (address != null) {
      fields['address_en'] = address;
      fields['address_ar'] = address;
    }
    if (latitude != null) fields['lat'] = latitude.toString();
    if (longitude != null) fields['lng'] = longitude.toString();
    if (phone != null) {
      fields['phone'] = phone;
      fields['whatsapp'] = phone;
    }
    if (email != null) fields['email'] = email;
    if (website != null) fields['website'] = website;

    dynamic data;
    if (imagePath != null) {
      fields['image'] = await MultipartFile.fromFile(imagePath);
      data = FormData.fromMap(fields);
    } else {
      data = fields;
    }

    final response = await dioClient.put(
      '${ApiConstants.businesses}/$id',
      data: data,
    );

    final responseData = response.data;
    final finalData = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    return BusinessModel.fromJson(finalData);
  }

  @override
  Future<void> deleteBusiness(String id) async {
    await dioClient.delete('${ApiConstants.businesses}/$id');
  }

  @override
  Future<List<BusinessModel>> getFavoriteBusinesses() async {
    final response = await dioClient.get(ApiConstants.favorites);
    final responseData = response.data;
    final List<dynamic> data = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    // Favorites API returns {id, user_id, business_id, business: {...}}
    // We need to extract the nested 'business' object
    return data.map((json) {
      final businessData = json['business'] ?? json;
      return BusinessModel.fromJson(businessData);
    }).toList();
  }

  @override
  Future<void> addToFavorites(String businessId) async {
    await dioClient.post(
      ApiConstants.favorites,
      data: {'businessId': businessId},
    );
  }

  @override
  Future<void> removeFromFavorites(String businessId) async {
    await dioClient.delete('${ApiConstants.favorites}/$businessId');
  }
}
