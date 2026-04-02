import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/bloc/admin_auth_bloc.dart';
import '../features/auth/presentation/pages/admin_login_page.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/dashboard/presentation/pages/admin_shell.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/customers/presentation/bloc/customers_bloc.dart';
import '../features/customers/presentation/pages/customers_page.dart';
import '../features/drivers/presentation/bloc/drivers_bloc.dart';
import '../features/drivers/presentation/pages/drivers_page.dart';
import '../features/bookings/presentation/bloc/admin_bookings_bloc.dart';
import '../features/bookings/presentation/pages/bookings_page.dart';
import '../features/settings/presentation/bloc/settings_bloc.dart';
import '../features/settings/presentation/pages/admin_settings_page.dart';
import '../features/zones/presentation/bloc/zones_bloc.dart';
import '../features/zones/presentation/pages/zones_page.dart';
import '../features/banners/presentation/bloc/banners_bloc.dart';
import '../features/banners/presentation/pages/banners_page.dart';
import '../features/subscriptions/presentation/bloc/subscriptions_bloc.dart';
import '../features/subscriptions/presentation/pages/subscriptions_page.dart';
import '../features/roles/presentation/bloc/roles_bloc.dart';
import '../features/roles/presentation/pages/roles_page.dart';
import '../injection_container.dart';

GoRouter createAdminRouter(AdminAuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLogin = state.matchedLocation == '/login';
      if (authState is AdminAuthenticated && isLogin) return '/dashboard';
      if (authState is AdminUnauthenticated && !isLogin) return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, state) => BlocProvider.value(value: sl<AdminAuthBloc>(), child: const AdminLoginPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => BlocProvider.value(
          value: sl<AdminAuthBloc>(), child: AdminShell(child: child),
        ),
        routes: [
          GoRoute(path: '/dashboard', builder: (_, state) => BlocProvider(
            create: (_) => sl<DashboardBloc>()..add(const DashboardLoadRequested()), child: const DashboardPage())),
          GoRoute(path: '/customers', builder: (_, state) => BlocProvider(
            create: (_) => sl<CustomersBloc>()..add(const CustomersLoadRequested()), child: const CustomersPage())),
          GoRoute(path: '/drivers', builder: (_, state) => BlocProvider(
            create: (_) => sl<DriversBloc>()..add(const DriversLoadRequested()), child: const DriversPage())),
          GoRoute(path: '/bookings', builder: (_, state) => BlocProvider(
            create: (_) => sl<AdminBookingsBloc>()..add(const AdminBookingsLoadRequested()), child: const BookingsPage())),
          GoRoute(path: '/settings', builder: (_, state) => BlocProvider(
            create: (_) => sl<SettingsBloc>()..add(const SettingsLoadRequested()), child: const AdminSettingsPage())),
          GoRoute(path: '/zones', builder: (_, state) => BlocProvider(
            create: (_) => sl<ZonesBloc>()..add(const ZonesLoadRequested()), child: const ZonesPage())),
          GoRoute(path: '/banners', builder: (_, state) => BlocProvider(
            create: (_) => sl<BannersBloc>()..add(const BannersLoadRequested()), child: const BannersPage())),
          GoRoute(path: '/subscriptions', builder: (_, state) => BlocProvider(
            create: (_) => sl<SubscriptionsBloc>()..add(const SubscriptionsLoadRequested()), child: const SubscriptionsPage())),
          GoRoute(path: '/roles', builder: (_, state) => BlocProvider(
            create: (_) => sl<RolesBloc>()..add(const RolesLoadRequested()), child: const RolesPage())),
        ],
      ),
    ],
  );
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) { stream.listen((_) => notifyListeners()); }
}
