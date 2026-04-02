part of 'drivers_bloc.dart';

sealed class DriversEvent extends Equatable {
  const DriversEvent();
  @override
  List<Object?> get props => [];
}

class DriversLoadRequested extends DriversEvent {
  final int page;
  final int pageSize;
  final String? searchQuery;
  const DriversLoadRequested({this.page = 0, this.pageSize = 10, this.searchQuery});
  @override
  List<Object?> get props => [page, pageSize, searchQuery];
}

class UnverifiedDriversRequested extends DriversEvent {
  const UnverifiedDriversRequested();
}

class OnlineDriversRequested extends DriversEvent {
  const OnlineDriversRequested();
}

class DriverDetailRequested extends DriversEvent {
  final String driverId;
  const DriverDetailRequested(this.driverId);
  @override
  List<Object?> get props => [driverId];
}

class DriverVerifyRequested extends DriversEvent {
  final String driverId;
  const DriverVerifyRequested(this.driverId);
  @override
  List<Object?> get props => [driverId];
}
