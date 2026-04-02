part of 'admin_bookings_bloc.dart';

sealed class AdminBookingsEvent extends Equatable {
  const AdminBookingsEvent();
  @override
  List<Object?> get props => [];
}

class AdminBookingsLoadRequested extends AdminBookingsEvent {
  final int page;
  final int pageSize;
  const AdminBookingsLoadRequested({this.page = 0, this.pageSize = 10});
  @override
  List<Object?> get props => [page, pageSize];
}

class AdminBookingsFilterChanged extends AdminBookingsEvent {
  final String? status;
  const AdminBookingsFilterChanged(this.status);
  @override
  List<Object?> get props => [status];
}
