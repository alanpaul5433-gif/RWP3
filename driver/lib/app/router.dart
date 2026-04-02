import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/bloc/driver_auth_bloc.dart';
import '../features/auth/presentation/pages/driver_login_page.dart';
import '../features/home/presentation/bloc/driver_home_bloc.dart';
import '../features/home/presentation/pages/driver_home_page.dart';
import '../injection_container.dart';

GoRouter createDriverRouter(DriverAuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _RefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLogin = state.matchedLocation == '/login';

      if (authState is DriverAuthenticated && isLogin) return '/home';
      if (authState is DriverUnauthenticated && !isLogin) return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider.value(
          value: sl<DriverAuthBloc>(),
          child: const DriverLoginPage(),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final authState = authBloc.state;
          final driverId = authState is DriverAuthenticated ? authState.driver.id : '';
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<DriverAuthBloc>()),
              BlocProvider(create: (_) => sl<DriverHomeBloc>()..add(DriverHomeDashboardRequested(driverId))),
            ],
            child: const DriverHomePage(),
          );
        },
      ),
    ],
  );
}

class _RefreshStream extends ChangeNotifier {
  _RefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}
