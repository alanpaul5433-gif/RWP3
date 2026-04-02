import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/driver_auth_bloc.dart';
import '../injection_container.dart';
import 'router.dart';
import 'theme.dart';

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<DriverAuthBloc>();

    return BlocProvider<DriverAuthBloc>(
      create: (_) => authBloc..add(const DriverAuthCheckRequested()),
      child: MaterialApp.router(
        title: 'RWP3 Driver',
        debugShowCheckedModeBanner: false,
        theme: DriverTheme.light,
        darkTheme: DriverTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: createDriverRouter(authBloc),
      ),
    );
  }
}
