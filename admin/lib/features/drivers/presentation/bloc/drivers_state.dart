part of 'drivers_bloc.dart';

sealed class DriversState extends Equatable {
  const DriversState();
  @override
  List<Object?> get props => [];
}

class DriversInitial extends DriversState {
  const DriversInitial();
}

class DriversLoading extends DriversState {
  const DriversLoading();
}

class DriversLoaded extends DriversState {
  final List<DriverEntity> drivers;
  final String? filter;
  const DriversLoaded({required this.drivers, this.filter});
  @override
  List<Object?> get props => [drivers, filter];
}

class DriverDetailLoaded extends DriversState {
  final DriverEntity driver;
  const DriverDetailLoaded(this.driver);
  @override
  List<Object?> get props => [driver];
}

class DriverVerified extends DriversState {
  final DriverEntity driver;
  const DriverVerified(this.driver);
  @override
  List<Object?> get props => [driver];
}

class DriversError extends DriversState {
  final String message;
  const DriversError(this.message);
  @override
  List<Object?> get props => [message];
}
