import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/booking_repository.dart';

class CreateBooking implements UseCase<BookingEntity, CreateBookingParams> {
  final BookingRepository repository;
  const CreateBooking(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(CreateBookingParams params) {
    return repository.createBooking(
      customerId: params.customerId,
      pickup: params.pickup,
      drop: params.drop,
      stops: params.stops,
      vehicleTypeId: params.vehicleTypeId,
      vehicleTypeName: params.vehicleTypeName,
      estimatedFare: params.estimatedFare,
      paymentType: params.paymentType,
      isOnlyForFemale: params.isOnlyForFemale,
    );
  }
}

class CreateBookingParams extends Equatable {
  final String customerId;
  final LocationLatLng pickup;
  final LocationLatLng drop;
  final List<LocationLatLng> stops;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final double estimatedFare;
  final String paymentType;
  final bool isOnlyForFemale;

  const CreateBookingParams({
    required this.customerId,
    required this.pickup,
    required this.drop,
    this.stops = const [],
    required this.vehicleTypeId,
    this.vehicleTypeName = '',
    required this.estimatedFare,
    required this.paymentType,
    this.isOnlyForFemale = false,
  });

  @override
  List<Object?> get props =>
      [customerId, pickup, drop, vehicleTypeId, paymentType];
}
