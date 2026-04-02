import 'package:core/core.dart';

class MockReviewDataSource {
  Future<ReviewEntity> submitReview({
    required String bookingId,
    required String reviewerId,
    required String revieweeId,
    required double rating,
    String comment = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ReviewEntity(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      reviewerId: reviewerId,
      revieweeId: revieweeId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
  }
}
