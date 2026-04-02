part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();
  @override
  List<Object?> get props => [];
}

class ReviewSubmitRequested extends ReviewEvent {
  final String bookingId;
  final String reviewerId;
  final String revieweeId;
  final double rating;
  final String comment;

  const ReviewSubmitRequested({
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.comment = '',
  });

  @override
  List<Object?> get props => [bookingId, reviewerId, revieweeId, rating];
}
