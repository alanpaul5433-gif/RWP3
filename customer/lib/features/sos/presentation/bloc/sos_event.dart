part of 'sos_bloc.dart';

sealed class SosEvent extends Equatable {
  const SosEvent();
  @override
  List<Object?> get props => [];
}

class SosTriggered extends SosEvent {
  final String userId;
  final String bookingId;
  final LocationLatLng location;
  final String contactNumber;

  const SosTriggered({
    required this.userId,
    required this.bookingId,
    required this.location,
    this.contactNumber = '',
  });

  @override
  List<Object?> get props => [userId, bookingId, location];
}

class SosHistoryRequested extends SosEvent {
  final String userId;
  const SosHistoryRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
