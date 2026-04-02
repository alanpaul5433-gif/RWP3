import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/location/presentation/bloc/location_bloc.dart';
import '../features/location/presentation/pages/select_location_page.dart';
import '../features/vehicle/presentation/bloc/vehicle_bloc.dart';
import '../features/vehicle/presentation/widgets/select_vehicle_page.dart';
import '../features/booking/presentation/bloc/booking_bloc.dart';
import '../features/booking/presentation/pages/confirm_booking_page.dart';
import '../features/payment/presentation/bloc/payment_bloc.dart';
import '../features/tracking/presentation/pages/tracking_page.dart';
import '../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../features/wallet/presentation/pages/wallet_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/settings/presentation/bloc/theme_bloc.dart';
import '../features/settings/presentation/bloc/locale_bloc.dart';
import '../injection_container.dart';

GoRouter createRouter(AuthBloc authBloc) {
  // Shared BLoC instances for booking flow (persist across screens)
  LocationBloc? locationBloc;
  VehicleBloc? vehicleBloc;
  BookingBloc? bookingBloc;
  PaymentBloc? paymentBloc;

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final path = state.matchedLocation;
      final publicRoutes = {'/splash', '/onboarding', '/login', '/signup', '/forgot-password'};

      if (authState is Authenticated && publicRoutes.contains(path)) {
        return '/home';
      }

      if (authState is Unauthenticated && !publicRoutes.contains(path)) {
        return '/login';
      }

      return null;
    },
    routes: [
      // Auth routes
      // Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => BlocProvider.value(
          value: sl<AuthBloc>(),
          child: const SplashPage(),
        ),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider.value(
          value: sl<AuthBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => BlocProvider.value(
          value: sl<AuthBloc>(),
          child: const SignupPage(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => BlocProvider.value(
          value: sl<AuthBloc>(),
          child: const ForgotPasswordPage(),
        ),
      ),

      // Home
      GoRoute(
        path: '/home',
        builder: (context, state) => BlocProvider.value(
          value: sl<AuthBloc>(),
          child: const HomePage(),
        ),
      ),

      // Profile
      GoRoute(
        path: '/profile',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<AuthBloc>()),
            BlocProvider(create: (_) => sl<ProfileBloc>()),
          ],
          child: const EditProfilePage(),
        ),
      ),

      // Booking flow: Select Location
      GoRoute(
        path: '/select-location',
        builder: (context, state) {
          locationBloc = sl<LocationBloc>();
          vehicleBloc = sl<VehicleBloc>();
          bookingBloc = sl<BookingBloc>();
          paymentBloc = sl<PaymentBloc>();
          return BlocProvider.value(
            value: locationBloc!,
            child: const SelectLocationPage(),
          );
        },
      ),

      // Booking flow: Select Vehicle
      GoRoute(
        path: '/select-vehicle',
        builder: (context, state) {
          vehicleBloc!.add(const VehicleTypesRequested());
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: locationBloc!),
              BlocProvider.value(value: vehicleBloc!),
            ],
            child: const SelectVehiclePage(),
          );
        },
      ),

      // Booking flow: Confirm & Book
      GoRoute(
        path: '/confirm-booking',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<AuthBloc>()),
            BlocProvider.value(value: locationBloc!),
            BlocProvider.value(value: bookingBloc!),
            BlocProvider.value(value: paymentBloc!),
          ],
          child: const ConfirmBookingPage(),
        ),
      ),

      // Wallet
      GoRoute(
        path: '/wallet',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<WalletBloc>()..add(const WalletLoadRequested('mock_user')),
          child: const WalletPage(),
        ),
      ),

      // Tracking
      GoRoute(
        path: '/tracking/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bookingBloc!),
            ],
            child: TrackingPage(bookingId: id),
          );
        },
      ),

      // Settings
      GoRoute(
        path: '/settings',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<AuthBloc>()),
            BlocProvider.value(value: sl<ThemeBloc>()),
            BlocProvider.value(value: sl<LocaleBloc>()),
          ],
          child: const SettingsPage(),
        ),
      ),
    ],
  );
}

/// Converts a Bloc stream into a Listenable for GoRouter refresh.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}
