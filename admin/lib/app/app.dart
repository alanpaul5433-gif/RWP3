import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/admin_auth_bloc.dart';
import '../injection_container.dart';
import 'router.dart';
import 'theme.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AdminAuthBloc>();

    return BlocProvider<AdminAuthBloc>(
      create: (_) => authBloc..add(const AdminAuthCheckRequested()),
      child: MaterialApp.router(
        title: 'RWP3 Admin',
        debugShowCheckedModeBanner: false,
        theme: AdminTheme.light,
        routerConfig: createAdminRouter(authBloc),
      ),
    );
  }
}
