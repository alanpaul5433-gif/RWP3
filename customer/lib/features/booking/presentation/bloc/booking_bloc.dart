import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/usecases/create_booking.dart';
import '../../domain/usecases/cancel_booking.dart';
import '../../domain/usecases/get_bookings_by_status.dart';
import '../../domain/repositories/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBooking _createBooking;
  final CancelBooking _cancelBooking;
  final GetBookingsByStatus _getBookingsByStatus;
  final BookingRepository _repository;

  StreamSubscription? _bookingSubscription;

  BookingBloc({
    required CreateBooking createBooking,
    required CancelBooking cancelBooking,
    required GetBookingsByStatus getBookingsByStatus,
    required BookingRepository repository,
  })  : _createBooking = createBooking,
        _cancelBooking = cancelBooking,
        _getBookingsByStatus = getBookingsByStatus,
        _repository = repository,
        super(const BookingInitial()) {
    on<BookingCreateRequested>(_onBookingCreateRequested);
    on<BookingWatchRequested>(_onBookingWatchRequested);
    on<BookingCancelRequested>(_onBookingCancelRequested);
    on<BookingHistoryRequested>(_onBookingHistoryRequested);
  }

  Future<void> _onBookingCreateRequested(
    BookingCreateRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingCreating());
    final result = await _createBooking(CreateBookingParams(
      customerId: event.customerId,
      pickup: event.pickup,
      drop: event.drop,
      stops: event.stops,
      vehicleTypeId: event.vehicleTypeId,
      vehicleTypeName: event.vehicleTypeName,
      estimatedFare: event.estimatedFare,
      paymentType: event.paymentType,
      isOnlyForFemale: event.isOnlyForFemale,
    ));
    result.fold(
      (failure) => emit(BookingError(mapFailureToMessage(failure))),
      (booking) {
        emit(BookingPlacedState(booking));
        // Auto-start watching for status updates
        add(BookingWatchRequested(booking.id));
      },
    );
  }

  Future<void> _onBookingWatchRequested(
    BookingWatchRequested event,
    Emitter<BookingState> emit,
  ) async {
    await _bookingSubscription?.cancel();
    await emit.forEach(
      _repository.watchBooking(event.bookingId),
      onData: (result) {
        return result.fold(
          (failure) => BookingError(mapFailureToMessage(failure)),
          (booking) => BookingUpdated(booking),
        );
      },
    );
  }

  Future<void> _onBookingCancelRequested(
    BookingCancelRequested event,
    Emitter<BookingState> emit,
  ) async {
    final result = await _cancelBooking(CancelBookingParams(
      bookingId: event.bookingId,
      reason: event.reason,
    ));
    result.fold(
      (failure) => emit(BookingError(mapFailureToMessage(failure))),
      (booking) => emit(BookingCancelledState(booking)),
    );
  }

  Future<void> _onBookingHistoryRequested(
    BookingHistoryRequested event,
    Emitter<BookingState> emit,
  ) async {
    final result = await _getBookingsByStatus(GetBookingsByStatusParams(
      customerId: event.customerId,
      status: event.status,
    ));
    result.fold(
      (failure) => emit(BookingError(mapFailureToMessage(failure))),
      (bookings) =>
          emit(BookingHistoryLoaded(bookings: bookings, status: event.status)),
    );
  }

  @override
  Future<void> close() {
    _bookingSubscription?.cancel();
    return super.close();
  }
}
