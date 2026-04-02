import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/booking_repository.dart';

class GetBookingsByStatus
    implements UseCase<List<BookingEntity>, GetBookingsByStatusParams> {
  final BookingRepository repository;
  const GetBookingsByStatus(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(
      GetBookingsByStatusParams params) {
    return repository.getBookingsByStatus(params.customerId, params.status);
  }
}

class GetBookingsByStatusParams extends Equatable {
  final String customerId;
  final String status;

  const GetBookingsByStatusParams({
    required this.customerId,
    required this.status,
  });

  @override
  List<Object?> get props => [customerId, status];
}
