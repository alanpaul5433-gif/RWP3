import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/booking_repository.dart';

class CancelBooking implements UseCase<BookingEntity, CancelBookingParams> {
  final BookingRepository repository;
  const CancelBooking(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(CancelBookingParams params) {
    return repository.cancelBooking(params.bookingId, params.reason);
  }
}

class CancelBookingParams extends Equatable {
  final String bookingId;
  final String reason;

  const CancelBookingParams({
    required this.bookingId,
    required this.reason,
  });

  @override
  List<Object?> get props => [bookingId, reason];
}
