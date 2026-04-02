import 'package:bloc_test/bloc_test.dart';
import 'package:customer/features/review/data/datasources/mock_review_datasource.dart';
import 'package:customer/features/review/data/repositories/review_repository_impl.dart';
import 'package:customer/features/review/domain/usecases/submit_review.dart';
import 'package:customer/features/review/presentation/bloc/review_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ReviewBloc bloc;

  setUp(() {
    final ds = MockReviewDataSource();
    final repo = ReviewRepositoryImpl(dataSource: ds);
    bloc = ReviewBloc(submitReview: SubmitReview(repo));
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewSubmitting, ReviewSubmitted] on success',
    build: () => bloc,
    act: (bloc) => bloc.add(const ReviewSubmitRequested(
      bookingId: 'bk_1',
      reviewerId: 'user_1',
      revieweeId: 'driver_1',
      rating: 4.5,
      comment: 'Great ride!',
    )),
    wait: wait,
    expect: () => [
      const ReviewSubmitting(),
      isA<ReviewSubmitted>(),
    ],
    verify: (bloc) {
      final state = bloc.state as ReviewSubmitted;
      expect(state.review.rating, 4.5);
      expect(state.review.comment, 'Great ride!');
    },
  );
}
