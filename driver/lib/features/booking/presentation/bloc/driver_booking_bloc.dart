import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_driver_booking_datasource.dart';

part 'driver_booking_event.dart';
part 'driver_booking_state.dart';

class DriverBookingBloc extends Bloc<DriverBookingEvent, DriverBookingState> {
  final MockDriverBookingDataSource _dataSource;

  DriverBookingBloc({required MockDriverBookingDataSource dataSource})
      : _dataSource = dataSource,
        super(const DriverBookingInitial()) {
    on<DriverBookingAccepted>(_onAccept);
    on<DriverBookingRejected>(_onReject);
    on<DriverOtpVerified>(_onOtpVerify);
    on<DriverRideStarted>(_onStart);
    on<DriverRideCompleted>(_onComplete);
  }

  Future<void> _onAccept(DriverBookingAccepted event, Emitter<DriverBookingState> emit) async {
    emit(const DriverBookingProcessing());
    try {
      final booking = await _dataSource.acceptBooking(event.bookingId);
      emit(DriverBookingAcceptedState(booking));
    } on ServerException catch (e) {
      emit(DriverBookingError(e.message));
    }
  }

  Future<void> _onReject(DriverBookingRejected event, Emitter<DriverBookingState> emit) async {
    try {
      final booking = await _dataSource.rejectBooking(event.bookingId);
      emit(DriverBookingRejectedState(booking));
    } on ServerException catch (e) {
      emit(DriverBookingError(e.message));
    }
  }

  Future<void> _onOtpVerify(DriverOtpVerified event, Emitter<DriverBookingState> emit) async {
    try {
      final valid = await _dataSource.verifyOtp(event.bookingId, event.otp);
      valid ? emit(DriverOtpVerifiedState(event.bookingId)) : emit(const DriverBookingError('Invalid OTP'));
    } on ServerException catch (e) {
      emit(DriverBookingError(e.message));
    }
  }

  Future<void> _onStart(DriverRideStarted event, Emitter<DriverBookingState> emit) async {
    emit(const DriverBookingProcessing());
    try {
      final booking = await _dataSource.startRide(event.bookingId);
      emit(DriverRideOngoing(booking));
    } on ServerException catch (e) {
      emit(DriverBookingError(e.message));
    }
  }

  Future<void> _onComplete(DriverRideCompleted event, Emitter<DriverBookingState> emit) async {
    emit(const DriverBookingProcessing());
    try {
      final booking = await _dataSource.completeRide(event.bookingId);
      emit(DriverRideCompletedState(booking));
    } on ServerException catch (e) {
      emit(DriverBookingError(e.message));
    }
  }
}
