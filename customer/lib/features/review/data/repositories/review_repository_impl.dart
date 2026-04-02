import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/mock_review_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final MockReviewDataSource dataSource;
  const ReviewRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String bookingId,
    required String reviewerId,
    required String revieweeId,
    required double rating,
    String comment = '',
  }) async {
    try {
      final review = await dataSource.submitReview(
        bookingId: bookingId,
        reviewerId: reviewerId,
        revieweeId: revieweeId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
