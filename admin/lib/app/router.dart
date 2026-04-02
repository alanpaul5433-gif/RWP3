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
        builder: (_, state) => BlocProvider.value(
          value: sl<AdminAuthBloc>(),
          child: const AdminLoginPage(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => BlocProvider.value(
          value: sl<AdminAuthBloc>(),
          child: AdminShell(child: child),
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, state) => BlocProvider(
              create: (_) => sl<DashboardBloc>()..add(const DashboardLoadRequested()),
              child: const DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/customers',
            builder: (_, state) => BlocProvider(
              create: (_) => sl<CustomersBloc>()..add(const CustomersLoadRequested()),
              child: const CustomersPage(),
            ),
          ),
          GoRoute(
            path: '/drivers',
            builder: (_, state) => BlocProvider(
              create: (_) => sl<DriversBloc>()..add(const DriversLoadRequested()),
              child: const DriversPage(),
            ),
          ),
          GoRoute(
            path: '/bookings',
            builder: (_, state) => const Center(child: Text('Bookings - Coming in Phase 3b')),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, state) => const Center(child: Text('Settings - Coming in Phase 3b')),
          ),
        ],
      ),
    ],
  );
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}
