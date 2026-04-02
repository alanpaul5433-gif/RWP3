import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class BookingRepository {
  Future<Either<Failure, BookingEntity>> createBooking({
    required String customerId,
    required LocationLatLng pickup,
    required LocationLatLng drop,
    required List<LocationLatLng> stops,
    required String vehicleTypeId,
    required String vehicleTypeName,
    required double estimatedFare,
    required String paymentType,
    bool isOnlyForFemale,
  });
  Future<Either<Failure, BookingEntity>> getBooking(String bookingId);
  Stream<Either<Failure, BookingEntity>> watchBooking(String bookingId);
  Future<Either<Failure, List<BookingEntity>>> getBookingsByStatus(
      String customerId, String status);
  Future<Either<Failure, BookingEntity>> cancelBooking(
      String bookingId, String reason);
}
