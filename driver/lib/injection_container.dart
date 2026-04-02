import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/mock_driver_auth_datasource.dart';
import 'features/auth/presentation/bloc/driver_auth_bloc.dart';
import 'features/home/data/datasources/mock_driver_home_datasource.dart';
import 'features/home/presentation/bloc/driver_home_bloc.dart';
import 'features/booking/data/datasources/mock_driver_booking_datasource.dart';
import 'features/booking/presentation/bloc/driver_booking_bloc.dart';
import 'features/documents/data/datasources/mock_documents_datasource.dart';
import 'features/documents/presentation/bloc/documents_bloc.dart';
import 'features/bank/data/datasources/mock_bank_datasource.dart';
import 'features/bank/presentation/bloc/bank_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth
  sl.registerFactory(() => DriverAuthBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockDriverAuthDataSource());

  // Home
  sl.registerFactory(() => DriverHomeBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockDriverHomeDataSource());

  // Booking (driver-side)
  sl.registerFactory(() => DriverBookingBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockDriverBookingDataSource());

  // Documents
  sl.registerFactory(() => DocumentsBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockDocumentsDataSource());

  // Bank + Withdrawals
  sl.registerFactory(() => BankBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockBankDataSource());
}
