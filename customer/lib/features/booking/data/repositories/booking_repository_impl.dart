import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/mock_booking_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final MockBookingDataSource dataSource;
  const BookingRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, BookingEntity>> createBooking({
    required String customerId,
    required LocationLatLng pickup,
    required LocationLatLng drop,
    required List<LocationLatLng> stops,
    required String vehicleTypeId,
    required String vehicleTypeName,
    required double estimatedFare,
    required String paymentType,
    bool isOnlyForFemale = false,
  }) async {
    try {
      final booking = await dataSource.createBooking(
        customerId: customerId,
        pickup: pickup,
        drop: drop,
        stops: stops,
        vehicleTypeId: vehicleTypeId,
        vehicleTypeName: vehicleTypeName,
        estimatedFare: estimatedFare,
        paymentType: paymentType,
        isOnlyForFemale: isOnlyForFemale,
      );
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBooking(String bookingId) async {
    try {
      final booking = await dataSource.getBooking(bookingId);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, BookingEntity>> watchBooking(String bookingId) {
    return dataSource.watchBooking(bookingId).map(
          (booking) => Right<Failure, BookingEntity>(booking),
        );
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookingsByStatus(
      String customerId, String status) async {
    try {
      final bookings =
          await dataSource.getBookingsByStatus(customerId, status);
      return Right(bookings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking(
      String bookingId, String reason) async {
    try {
      final booking = await dataSource.cancelBooking(bookingId, reason);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
