import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/driver_auth_bloc.dart';

class DriverSettingsPage extends StatelessWidget {
  const DriverSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: [
        const SizedBox(height: 8),
        // Profile section
        BlocBuilder<DriverAuthBloc, DriverAuthState>(
          builder: (context, state) {
            final driver = state is DriverAuthenticated ? state.driver : null;
            return ListTile(
              leading: CircleAvatar(radius: 24, backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.person, color: colorScheme.onPrimaryContainer)),
              title: Text(driver?.fullName ?? 'Driver', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(driver?.email ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            );
          },
        ),
        const Divider(),

        ListTile(leading: const Icon(Icons.directions_car), title: const Text('Vehicle Details'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(leading: const Icon(Icons.description), title: const Text('Documents'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(leading: const Icon(Icons.account_balance), title: const Text('Bank Details'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(leading: const Icon(Icons.subscriptions_outlined), title: const Text('Subscription'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        const Divider(),

        ListTile(leading: const Icon(Icons.language), title: const Text('Language'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(leading: const Icon(Icons.dark_mode_outlined), title: const Text('Theme'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        const Divider(),

        ListTile(leading: const Icon(Icons.description_outlined), title: const Text('Terms of Service'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('Privacy Policy'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(leading: const Icon(Icons.info_outlined), title: const Text('About'), subtitle: const Text('RWP Driver v1.0.0'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        const Divider(),

        ListTile(
          leading: Icon(Icons.logout, color: colorScheme.error),
          title: Text('Logout', style: TextStyle(color: colorScheme.error)),
          onTap: () {
            context.read<DriverAuthBloc>().add(const DriverLogoutRequested());
            context.go('/login');
          },
        ),
        const SizedBox(height: 32),
      ]),
    );
  }
}
