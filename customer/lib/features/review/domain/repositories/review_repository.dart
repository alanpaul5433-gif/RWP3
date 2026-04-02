import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class ReviewRepository {
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String bookingId,
    required String reviewerId,
    required String revieweeId,
    required double rating,
    String comment,
  });
}
