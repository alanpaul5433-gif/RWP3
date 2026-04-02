import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/usecases/submit_review.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final SubmitReview _submitReview;

  ReviewBloc({required SubmitReview submitReview})
      : _submitReview = submitReview,
        super(const ReviewInitial()) {
    on<ReviewSubmitRequested>(_onReviewSubmitRequested);
  }

  Future<void> _onReviewSubmitRequested(
    ReviewSubmitRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewSubmitting());
    final result = await _submitReview(SubmitReviewParams(
      bookingId: event.bookingId,
      reviewerId: event.reviewerId,
      revieweeId: event.revieweeId,
      rating: event.rating,
      comment: event.comment,
    ));
    result.fold(
      (failure) => emit(ReviewError(mapFailureToMessage(failure))),
      (review) => emit(ReviewSubmitted(review)),
    );
  }
}
