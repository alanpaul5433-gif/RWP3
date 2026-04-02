import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:customer/features/booking/data/datasources/mock_booking_datasource.dart';
import 'package:customer/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:customer/features/booking/domain/usecases/create_booking.dart';
import 'package:customer/features/booking/domain/usecases/cancel_booking.dart';
import 'package:customer/features/booking/domain/usecases/get_bookings_by_status.dart';
import 'package:customer/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BookingBloc bloc;
  late MockBookingDataSource dataSource;
  late BookingRepositoryImpl repo;

  const pickup = LocationLatLng(
    latitude: 37.7749,
    longitude: -122.4194,
    address: '123 Market St',
  );
  const drop = LocationLatLng(
    latitude: 37.7849,
    longitude: -122.4094,
    address: '456 Mission St',
  );

  setUp(() {
    dataSource = MockBookingDataSource();
    repo = BookingRepositoryImpl(dataSource: dataSource);
    bloc = BookingBloc(
      createBooking: CreateBooking(repo),
      cancelBooking: CancelBooking(repo),
      getBookingsByStatus: GetBookingsByStatus(repo),
      repository: repo,
    );
  });

  tearDown(() {
    bloc.close();
    dataSource.dispose();
  });

  const wait = Duration(seconds: 2);

  group('BookingCreateRequested', () {
    blocTest<BookingBloc, BookingState>(
      'emits BookingCreating then BookingPlacedState on success',
      build: () => bloc,
      act: (bloc) => bloc.add(const BookingCreateRequested(
        customerId: 'user_1',
        pickup: pickup,
        drop: drop,
        vehicleTypeId: 'vt_1',
        vehicleTypeName: 'Economy',
        estimatedFare: 150.0,
        paymentType: 'cash',
      )),
      wait: wait,
      verify: (bloc) {
        // Verify at least BookingPlacedState or BookingUpdated was emitted
        expect(
          bloc.state,
          anyOf(isA<BookingPlacedState>(), isA<BookingUpdated>()),
        );
      },
    );
  });

  group('BookingHistoryRequested', () {
    blocTest<BookingBloc, BookingState>(
      'emits [BookingHistoryLoaded] with empty list',
      build: () => bloc,
      act: (bloc) => bloc.add(const BookingHistoryRequested(
        customerId: 'user_1',
        status: BookingStatus.completed,
      )),
      wait: wait,
      expect: () => [
        isA<BookingHistoryLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as BookingHistoryLoaded;
        expect(state.bookings, isEmpty);
      },
    );
  });
}
