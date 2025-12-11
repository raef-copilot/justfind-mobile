import 'package:dartz/dartz.dart';
import 'package:justfind_app/core/errors/failures.dart';
import 'package:justfind_app/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByBusinessId(String businessId);
  
  Future<Either<Failure, ReviewEntity>> createReview({
    required String businessId,
    required int rating,
    required String comment,
  });
  
  Future<Either<Failure, ReviewEntity>> updateReview({
    required String id,
    int? rating,
    String? comment,
  });
  
  Future<Either<Failure, void>> deleteReview(String id);
}
