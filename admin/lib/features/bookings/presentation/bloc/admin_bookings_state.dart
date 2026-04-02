part of 'admin_bookings_bloc.dart';

sealed class AdminBookingsState extends Equatable {
  const AdminBookingsState();
  @override
  List<Object?> get props => [];
}

class AdminBookingsInitial extends AdminBookingsState { const AdminBookingsInitial(); }
class AdminBookingsLoading extends AdminBookingsState { const AdminBookingsLoading(); }

class AdminBookingsLoaded extends AdminBookingsState {
  final List<BookingEntity> bookings;
  final int totalCount;
  final int currentPage;
  final String? filterStatus;
  const AdminBookingsLoaded({required this.bookings, required this.totalCount, this.currentPage = 0, this.filterStatus});
  @override
  List<Object?> get props => [bookings, totalCount, currentPage, filterStatus];
}

class AdminBookingsError extends AdminBookingsState {
  final String message;
  const AdminBookingsError(this.message);
  @override
  List<Object?> get props => [message];
}
