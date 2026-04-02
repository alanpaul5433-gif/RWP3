import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:driver/features/booking/data/datasources/mock_driver_booking_datasource.dart';
import 'package:driver/features/booking/presentation/bloc/driver_booking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DriverBookingBloc bloc;
  late MockDriverBookingDataSource ds;

  final testBooking = BookingEntity(
    id: 'bk_test',
    customerId: 'user_1',
    driverId: 'driver_1',
    bookingStatus: BookingStatus.driverAssigned,
    pickupLocation: const LocationLatLng(latitude: 37.77, longitude: -122.41, address: 'SF'),
    dropLocation: const LocationLatLng(latitude: 37.78, longitude: -122.40, address: 'Mission'),
    vehicleTypeId: 'vt_1',
    otp: '1234',
    estimatedFare: 85.0,
    paymentType: 'cash',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    ds = MockDriverBookingDataSource();
    ds.seedBooking(testBooking);
    bloc = DriverBookingBloc(dataSource: ds);
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  blocTest<DriverBookingBloc, DriverBookingState>(
    'accepts booking',
    build: () => bloc,
    act: (bloc) => bloc.add(const DriverBookingAccepted('bk_test')),
    wait: wait,
    expect: () => [const DriverBookingProcessing(), isA<DriverBookingAcceptedState>()],
    verify: (bloc) {
      final state = bloc.state as DriverBookingAcceptedState;
      expect(state.booking.bookingStatus, BookingStatus.accepted);
    },
  );

  blocTest<DriverBookingBloc, DriverBookingState>(
    'verifies correct OTP',
    build: () => bloc,
    act: (bloc) => bloc.add(const DriverOtpVerified(bookingId: 'bk_test', otp: '1234')),
    wait: wait,
    expect: () => [isA<DriverOtpVerifiedState>()],
  );

  blocTest<DriverBookingBloc, DriverBookingState>(
    'rejects wrong OTP',
    build: () => bloc,
    act: (bloc) => bloc.add(const DriverOtpVerified(bookingId: 'bk_test', otp: '0000')),
    wait: wait,
    expect: () => [isA<DriverBookingError>()],
  );
}
