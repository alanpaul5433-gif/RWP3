import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/review_repository.dart';

class SubmitReview implements UseCase<ReviewEntity, SubmitReviewParams> {
  final ReviewRepository repository;
  const SubmitReview(this.repository);

  @override
  Future<Either<Failure, ReviewEntity>> call(SubmitReviewParams params) {
    return repository.submitReview(
      bookingId: params.bookingId,
      reviewerId: params.reviewerId,
      revieweeId: params.revieweeId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class SubmitReviewParams extends Equatable {
  final String bookingId;
  final String reviewerId;
  final String revieweeId;
  final double rating;
  final String comment;

  const SubmitReviewParams({
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.comment = '',
  });

  @override
  List<Object?> get props => [bookingId, reviewerId, revieweeId, rating];
}
