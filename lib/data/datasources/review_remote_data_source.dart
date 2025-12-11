import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getReviewsByBusinessId(String businessId);
  Future<ReviewModel> createReview({
    required String businessId,
    required int rating,
    required String comment,
  });
  Future<ReviewModel> updateReview({
    required String id,
    int? rating,
    String? comment,
  });
  Future<void> deleteReview(String id);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final DioClient dioClient;

  ReviewRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ReviewModel>> getReviewsByBusinessId(String businessId) async {
    final response = await dioClient.get(
      ApiConstants.reviews,
      queryParameters: {'businessId': businessId},
    );
    final responseData = response.data;
    final List<dynamic> data = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    return data.map((json) => ReviewModel.fromJson(json)).toList();
  }

  @override
  Future<ReviewModel> createReview({
    required String businessId,
    required int rating,
    required String comment,
  }) async {
    final response = await dioClient.post(
      ApiConstants.reviews,
      data: {
        'business': businessId,
        'rating': rating,
        'comment': comment,
      },
    );
    final responseData = response.data;
    final data = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    return ReviewModel.fromJson(data);
  }

  @override
  Future<ReviewModel> updateReview({
    required String id,
    int? rating,
    String? comment,
  }) async {
    final Map<String, dynamic> data = {};
    if (rating != null) data['rating'] = rating;
    if (comment != null) data['comment'] = comment;

    final response = await dioClient.put(
      '${ApiConstants.reviews}/$id',
      data: data,
    );
    final responseData = response.data;
    final finalData = responseData is Map ? (responseData['data'] ?? responseData) : responseData;
    return ReviewModel.fromJson(finalData);
  }

  @override
  Future<void> deleteReview(String id) async {
    await dioClient.delete('${ApiConstants.reviews}/$id');
  }
}
