import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByBusinessId(
    String businessId,
  ) async {
    try {
      final reviews = await remoteDataSource.getReviewsByBusinessId(businessId);
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> createReview({
    required String businessId,
    required int rating,
    required String comment,
  }) async {
    try {
      final review = await remoteDataSource.createReview(
        businessId: businessId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> updateReview({
    required String id,
    int? rating,
    String? comment,
  }) async {
    try {
      final review = await remoteDataSource.updateReview(
        id: id,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String id) async {
    try {
      await remoteDataSource.deleteReview(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
