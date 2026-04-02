import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/mock_admin_auth_datasource.dart';
import 'features/auth/data/repositories/admin_auth_repository_impl.dart';
import 'features/auth/domain/repositories/admin_auth_repository.dart';
import 'features/auth/presentation/bloc/admin_auth_bloc.dart';
import 'features/dashboard/data/datasources/mock_dashboard_datasource.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/customers/data/datasources/mock_customer_datasource.dart';
import 'features/customers/presentation/bloc/customers_bloc.dart';
import 'features/drivers/data/datasources/mock_driver_datasource.dart';
import 'features/drivers/presentation/bloc/drivers_bloc.dart';
import 'features/roles/data/datasources/mock_roles_datasource.dart';
import 'features/roles/presentation/bloc/roles_bloc.dart';
import 'features/zones/data/datasources/mock_zones_datasource.dart';
import 'features/zones/presentation/bloc/zones_bloc.dart';
import 'features/banners/data/datasources/mock_banners_datasource.dart';
import 'features/banners/presentation/bloc/banners_bloc.dart';
import 'features/subscriptions/data/datasources/mock_subscriptions_datasource.dart';
import 'features/subscriptions/presentation/bloc/subscriptions_bloc.dart';
import 'features/bookings/data/datasources/mock_admin_bookings_datasource.dart';
import 'features/bookings/presentation/bloc/admin_bookings_bloc.dart';
import 'features/settings/data/datasources/mock_settings_datasource.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth
  sl.registerFactory(() => AdminAuthBloc(repository: sl()));
  sl.registerLazySingleton<AdminAuthRepository>(
    () => AdminAuthRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockAdminAuthDataSource());

  // Dashboard
  sl.registerFactory(() => DashboardBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockDashboardDataSource());

  // Customers
  sl.registerFactory(() => CustomersBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockCustomerDataSource());

  // Drivers
  sl.registerFactory(() => DriversBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockDriverDataSource());

  // Roles (RBAC)
  sl.registerFactory(() => RolesBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockRolesDataSource());

  // Zones
  sl.registerFactory(() => ZonesBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockZonesDataSource());

  // Banners
  sl.registerFactory(() => BannersBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockBannersDataSource());

  // Subscriptions
  sl.registerFactory(() => SubscriptionsBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockSubscriptionsDataSource());

  // Bookings
  sl.registerFactory(() => AdminBookingsBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockAdminBookingsDataSource());

  // Settings
  sl.registerFactory(() => SettingsBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockSettingsDataSource());
}
