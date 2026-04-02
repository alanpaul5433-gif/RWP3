part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingCreating extends BookingState {
  const BookingCreating();
}

class BookingPlacedState extends BookingState {
  final BookingEntity booking;
  const BookingPlacedState(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingUpdated extends BookingState {
  final BookingEntity booking;
  const BookingUpdated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingCancelledState extends BookingState {
  final BookingEntity booking;
  const BookingCancelledState(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingHistoryLoaded extends BookingState {
  final List<BookingEntity> bookings;
  final String status;
  const BookingHistoryLoaded({required this.bookings, required this.status});

  @override
  List<Object?> get props => [bookings, status];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
