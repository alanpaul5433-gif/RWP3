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
import '../features/booking/presentation/pages/ride_history_page.dart';
import '../features/payment/presentation/bloc/payment_bloc.dart';
import '../features/tracking/presentation/pages/tracking_page.dart';
import '../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../features/wallet/presentation/pages/wallet_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/settings/presentation/bloc/theme_bloc.dart';
import '../features/settings/presentation/bloc/locale_bloc.dart';
import '../features/coupon/presentation/bloc/coupon_bloc.dart';
import '../features/coupon/presentation/pages/coupon_list_page.dart';
import '../features/loyalty/presentation/bloc/loyalty_bloc.dart';
import '../features/loyalty/presentation/pages/loyalty_page.dart';
import '../features/referral/presentation/bloc/referral_bloc.dart';
import '../features/referral/presentation/pages/referral_page.dart';
import '../features/emergency_contacts/presentation/bloc/emergency_contacts_bloc.dart';
import '../features/emergency_contacts/presentation/pages/emergency_contacts_page.dart';
import '../features/sos/presentation/bloc/sos_bloc.dart';
import '../features/sos/presentation/pages/sos_page.dart';
import '../features/support/presentation/bloc/support_bloc.dart';
import '../features/support/presentation/pages/support_page.dart';
import '../features/notification/presentation/bloc/notification_bloc.dart';
import '../features/notification/presentation/pages/notification_page.dart';
import '../features/chat/presentation/bloc/chat_bloc.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/chat/presentation/pages/inbox_page.dart';
import '../features/intercity/presentation/bloc/intercity_bloc.dart';
import '../features/intercity/presentation/pages/intercity_page.dart';
import '../features/parcel/presentation/bloc/parcel_bloc.dart';
import '../features/parcel/presentation/pages/parcel_page.dart';
import '../features/rental/presentation/bloc/rental_bloc.dart';
import '../features/rental/presentation/pages/rental_page.dart';
import '../injection_container.dart';

GoRouter createRouter(AuthBloc authBloc) {
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

      if (authState is Authenticated && publicRoutes.contains(path)) return '/home';
      if (authState is Unauthenticated && !publicRoutes.contains(path)) return '/login';
      return null;
    },
    routes: [
      // ==================== PUBLIC ====================
      GoRoute(path: '/splash', builder: (context, state) => BlocProvider.value(value: authBloc, child: const SplashPage())),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (context, state) => BlocProvider.value(value: authBloc, child: const LoginPage())),
      GoRoute(path: '/signup', builder: (context, state) => BlocProvider.value(value: authBloc, child: const SignupPage())),
      GoRoute(path: '/forgot-password', builder: (context, state) => BlocProvider.value(value: authBloc, child: const ForgotPasswordPage())),

      // ==================== HOME ====================
      GoRoute(path: '/home', builder: (context, state) => BlocProvider.value(value: authBloc, child: const HomePage())),

      // ==================== PROFILE ====================
      GoRoute(path: '/profile', builder: (context, state) => MultiBlocProvider(
        providers: [BlocProvider.value(value: authBloc), BlocProvider(create: (_) => sl<ProfileBloc>())],
        child: const EditProfilePage(),
      )),

      // ==================== BOOKING FLOW (Cab) ====================
      GoRoute(path: '/select-location', builder: (context, state) {
        locationBloc = sl<LocationBloc>(); vehicleBloc = sl<VehicleBloc>();
        bookingBloc = sl<BookingBloc>(); paymentBloc = sl<PaymentBloc>();
        return BlocProvider.value(value: locationBloc!, child: const SelectLocationPage());
      }),
      GoRoute(path: '/select-vehicle', builder: (context, state) {
        vehicleBloc!.add(const VehicleTypesRequested());
        return MultiBlocProvider(
          providers: [BlocProvider.value(value: locationBloc!), BlocProvider.value(value: vehicleBloc!)],
          child: const SelectVehiclePage(),
        );
      }),
      GoRoute(path: '/confirm-booking', builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authBloc), BlocProvider.value(value: locationBloc!),
          BlocProvider.value(value: bookingBloc!), BlocProvider.value(value: paymentBloc!),
        ],
        child: const ConfirmBookingPage(),
      )),
      GoRoute(path: '/tracking/:id', builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider.value(value: bookingBloc!, child: TrackingPage(bookingId: id));
      }),

      // ==================== RIDE HISTORY ====================
      GoRoute(path: '/ride-history', builder: (context, state) => BlocProvider(
        create: (_) => sl<BookingBloc>(), child: const RideHistoryPage(),
      )),

      // ==================== WALLET ====================
      GoRoute(path: '/wallet', builder: (context, state) => BlocProvider(
        create: (_) => sl<WalletBloc>()..add(const WalletLoadRequested('mock_user')),
        child: const WalletPage(),
      )),

      // ==================== INTERCITY ====================
      GoRoute(path: '/intercity', builder: (context, state) => BlocProvider(
        create: (_) => sl<IntercityBloc>(), child: const IntercityPage(),
      )),

      // ==================== PARCEL ====================
      GoRoute(path: '/parcel', builder: (context, state) => BlocProvider(
        create: (_) => sl<ParcelBloc>(), child: const ParcelPage(),
      )),

      // ==================== RENTAL ====================
      GoRoute(path: '/rental', builder: (context, state) => BlocProvider(
        create: (_) => sl<RentalBloc>(), child: const RentalPage(),
      )),

      // ==================== COUPONS ====================
      GoRoute(path: '/coupons', builder: (context, state) => BlocProvider(
        create: (_) => sl<CouponBloc>()..add(const CouponsLoadRequested()), child: const CouponListPage(),
      )),

      // ==================== LOYALTY ====================
      GoRoute(path: '/loyalty', builder: (context, state) => BlocProvider(
        create: (_) => sl<LoyaltyBloc>()..add(const LoyaltyLoadRequested('mock_user')), child: const LoyaltyPage(),
      )),

      // ==================== REFERRAL ====================
      GoRoute(path: '/referral', builder: (context, state) => BlocProvider(
        create: (_) => sl<ReferralBloc>()..add(const ReferralCodeRequested('mock_user')), child: const ReferralPage(),
      )),

      // ==================== EMERGENCY CONTACTS ====================
      GoRoute(path: '/emergency-contacts', builder: (context, state) => BlocProvider(
        create: (_) => sl<EmergencyContactsBloc>()..add(const EmergencyContactsLoadRequested('mock_user')),
        child: const EmergencyContactsPage(),
      )),

      // ==================== SOS ====================
      GoRoute(path: '/sos', builder: (context, state) => BlocProvider(
        create: (_) => sl<SosBloc>()..add(const SosHistoryRequested('mock_user')), child: const SosPage(),
      )),

      // ==================== SUPPORT ====================
      GoRoute(path: '/support', builder: (context, state) => BlocProvider(
        create: (_) => sl<SupportBloc>()..add(const SupportTicketsLoadRequested('mock_user')), child: const SupportPage(),
      )),

      // ==================== NOTIFICATIONS ====================
      GoRoute(path: '/notifications', builder: (context, state) => BlocProvider(
        create: (_) => sl<NotificationBloc>()..add(const NotificationsLoadRequested('mock_user')),
        child: const NotificationPage(),
      )),

      // ==================== CHAT ====================
      GoRoute(path: '/inbox', builder: (context, state) => BlocProvider(
        create: (_) => sl<ChatBloc>()..add(const ChatInboxRequested('mock_user')), child: const InboxPage(),
      )),
      GoRoute(path: '/chat/:userId', builder: (context, state) {
        final otherUserId = state.pathParameters['userId']!;
        return BlocProvider(
          create: (_) => sl<ChatBloc>()..add(ChatStreamStarted(userId: 'mock_user', otherUserId: otherUserId)),
          child: ChatPage(userId: 'mock_user', otherUserId: otherUserId),
        );
      }),

      // ==================== SETTINGS ====================
      GoRoute(path: '/settings', builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authBloc),
          BlocProvider.value(value: sl<ThemeBloc>()),
          BlocProvider.value(value: sl<LocaleBloc>()),
        ],
        child: const SettingsPage(),
      )),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}
