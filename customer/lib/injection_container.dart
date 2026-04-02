import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/mock_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_with_email.dart';
import 'features/auth/domain/usecases/signup_with_email.dart';
import 'features/auth/domain/usecases/reset_password.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/data/datasources/mock_profile_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/update_profile.dart';
import 'features/profile/domain/usecases/delete_account.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/vehicle/data/datasources/mock_vehicle_datasource.dart';
import 'features/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'features/vehicle/domain/repositories/vehicle_repository.dart';
import 'features/vehicle/domain/usecases/get_vehicle_types.dart';
import 'features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'features/location/data/datasources/mock_location_datasource.dart';
import 'features/location/data/repositories/location_repository_impl.dart';
import 'features/location/domain/repositories/location_repository.dart';
import 'features/location/domain/usecases/get_current_location.dart' as loc;
import 'features/location/domain/usecases/calculate_route.dart';
import 'features/location/domain/usecases/estimate_fare.dart';
import 'features/location/presentation/bloc/location_bloc.dart';
import 'features/booking/data/datasources/mock_booking_datasource.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/create_booking.dart';
import 'features/booking/domain/usecases/cancel_booking.dart';
import 'features/booking/domain/usecases/get_bookings_by_status.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/payment/data/datasources/mock_payment_datasource.dart';
import 'features/payment/data/repositories/payment_repository_impl.dart';
import 'features/payment/domain/repositories/payment_repository.dart';
import 'features/payment/presentation/bloc/payment_bloc.dart';
import 'features/review/data/datasources/mock_review_datasource.dart';
import 'features/review/data/repositories/review_repository_impl.dart';
import 'features/review/domain/repositories/review_repository.dart';
import 'features/review/domain/usecases/submit_review.dart';
import 'features/review/presentation/bloc/review_bloc.dart';
import 'features/wallet/data/datasources/mock_wallet_datasource.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/wallet/domain/repositories/wallet_repository.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'features/intercity/data/datasources/mock_intercity_datasource.dart';
import 'features/intercity/data/repositories/intercity_repository_impl.dart';
import 'features/intercity/domain/repositories/intercity_repository.dart';
import 'features/intercity/presentation/bloc/intercity_bloc.dart';
import 'features/parcel/data/datasources/mock_parcel_datasource.dart';
import 'features/parcel/data/repositories/parcel_repository_impl.dart';
import 'features/parcel/domain/repositories/parcel_repository.dart';
import 'features/parcel/presentation/bloc/parcel_bloc.dart';
import 'features/rental/data/datasources/mock_rental_datasource.dart';
import 'features/rental/data/repositories/rental_repository_impl.dart';
import 'features/rental/domain/repositories/rental_repository.dart';
import 'features/rental/presentation/bloc/rental_bloc.dart';
import 'features/chat/data/datasources/mock_chat_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/notification/data/datasources/mock_notification_datasource.dart';
import 'features/notification/presentation/bloc/notification_bloc.dart';
import 'features/coupon/data/datasources/mock_coupon_datasource.dart';
import 'features/coupon/presentation/bloc/coupon_bloc.dart';
import 'features/loyalty/data/datasources/mock_loyalty_datasource.dart';
import 'features/loyalty/presentation/bloc/loyalty_bloc.dart';
import 'features/referral/data/datasources/mock_referral_datasource.dart';
import 'features/referral/presentation/bloc/referral_bloc.dart';
import 'features/sos/data/datasources/mock_sos_datasource.dart';
import 'features/sos/presentation/bloc/sos_bloc.dart';
import 'features/emergency_contacts/data/datasources/mock_emergency_datasource.dart';
import 'features/emergency_contacts/presentation/bloc/emergency_contacts_bloc.dart';
import 'features/support/data/datasources/mock_support_datasource.dart';
import 'features/support/presentation/bloc/support_bloc.dart';
import 'features/settings/presentation/bloc/theme_bloc.dart';
import 'features/settings/presentation/bloc/locale_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========================
  // Auth Feature
  // ========================

  // BLoC
  sl.registerFactory(() => AuthBloc(
        loginWithEmail: sl(),
        signupWithEmail: sl(),
        resetPassword: sl(),
        getCurrentUser: sl(),
        logout: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => LoginWithEmail(sl()));
  sl.registerLazySingleton(() => SignupWithEmail(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  // DataSource (Mock — swap to Firebase later)
  sl.registerLazySingleton(() => MockAuthDataSource());

  // ========================
  // Profile Feature
  // ========================

  // BLoC
  sl.registerFactory(() => ProfileBloc(
        getProfile: sl(),
        updateProfile: sl(),
        deleteAccount: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => DeleteAccount(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(dataSource: sl()),
  );

  // DataSource (Mock)
  sl.registerLazySingleton(() => MockProfileDataSource());

  // ========================
  // Vehicle Feature
  // ========================
  sl.registerFactory(() => VehicleBloc(getVehicleTypes: sl()));
  sl.registerLazySingleton(() => GetVehicleTypes(sl()));
  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockVehicleDataSource());

  // ========================
  // Location Feature
  // ========================
  sl.registerFactory(() => LocationBloc(
        getCurrentLocation: sl(),
        calculateRoute: sl(),
        estimateFare: sl(),
      ));
  sl.registerLazySingleton(() => loc.GetCurrentLocation(sl()));
  sl.registerLazySingleton(() => CalculateRoute(sl()));
  sl.registerLazySingleton(() => EstimateFare(sl()));
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockLocationDataSource());

  // ========================
  // Booking Feature
  // ========================
  sl.registerFactory(() => BookingBloc(
        createBooking: sl(),
        cancelBooking: sl(),
        getBookingsByStatus: sl(),
        repository: sl(),
      ));
  sl.registerLazySingleton(() => CreateBooking(sl()));
  sl.registerLazySingleton(() => CancelBooking(sl()));
  sl.registerLazySingleton(() => GetBookingsByStatus(sl()));
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockBookingDataSource());

  // ========================
  // Payment Feature
  // ========================
  sl.registerFactory(() => PaymentBloc(repository: sl()));
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockPaymentDataSource());

  // ========================
  // Review Feature
  // ========================
  sl.registerFactory(() => ReviewBloc(submitReview: sl()));
  sl.registerLazySingleton(() => SubmitReview(sl()));
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockReviewDataSource());

  // ========================
  // Wallet Feature
  // ========================
  sl.registerFactory(() => WalletBloc(repository: sl()));
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockWalletDataSource());

  // ========================
  // Intercity Feature
  // ========================
  sl.registerFactory(() => IntercityBloc(repository: sl()));
  sl.registerLazySingleton<IntercityRepository>(
    () => IntercityRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockIntercityDataSource());

  // ========================
  // Parcel Feature
  // ========================
  sl.registerFactory(() => ParcelBloc(repository: sl()));
  sl.registerLazySingleton<ParcelRepository>(
    () => ParcelRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockParcelDataSource());

  // ========================
  // Rental Feature
  // ========================
  sl.registerFactory(() => RentalBloc(repository: sl()));
  sl.registerLazySingleton<RentalRepository>(
    () => RentalRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockRentalDataSource());

  // ========================
  // Chat Feature
  // ========================
  sl.registerFactory(() => ChatBloc(repository: sl()));
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => MockChatDataSource());

  // ========================
  // Notification Feature
  // ========================
  sl.registerFactory(() => NotificationBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockNotificationDataSource());

  // ========================
  // Coupon Feature
  // ========================
  sl.registerFactory(() => CouponBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockCouponDataSource());

  // ========================
  // Loyalty Feature
  // ========================
  sl.registerFactory(() => LoyaltyBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockLoyaltyDataSource());

  // ========================
  // Referral Feature
  // ========================
  sl.registerFactory(() => ReferralBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockReferralDataSource());

  // ========================
  // SOS Feature
  // ========================
  sl.registerFactory(() => SosBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockSosDataSource());

  // ========================
  // Emergency Contacts Feature
  // ========================
  sl.registerFactory(() => EmergencyContactsBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockEmergencyDataSource());

  // ========================
  // Support Feature
  // ========================
  sl.registerFactory(() => SupportBloc(dataSource: sl()));
  sl.registerLazySingleton(() => MockSupportDataSource());

  // ========================
  // Settings (Theme + Locale)
  // ========================
  sl.registerLazySingleton(() => ThemeBloc());
  sl.registerLazySingleton(() => LocaleBloc());
}
