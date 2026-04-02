import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    

    return Padding(padding: const EdgeInsets.all(24), child: BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsUpdated) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
      },
      builder: (context, state) {
        if (state is SettingsLoading) return const Center(child: CircularProgressIndicator());
        final settings = state is SettingsLoaded ? state.settings : state is SettingsUpdated ? state.settings : <String, dynamic>{};
        if (settings.isEmpty) return const Center(child: Text('No settings'));

        return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Settings', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          _SectionCard('General', [
            _SettingTile('App Name', settings['appName']?.toString() ?? ''),
            _SettingTile('Country Code', settings['countryCode']?.toString() ?? ''),
            _SettingTile('Distance Type', settings['distanceType']?.toString() ?? ''),
            _SettingTile('Search Radius', '${settings['radius']} km'),
          ]),

          _SectionCard('Financial', [
            _SettingTile('Commission', '${settings['commissionPercent']}%'),
            _SettingTile('Tax', '${settings['taxPercent']}%'),
            _SettingTile('Min Deposit', '\$${settings['minimumAmountToDeposit']}'),
            _SettingTile('Min Withdrawal', '\$${settings['minimumAmountToWithdrawal']}'),
            _SettingTile('Referral Amount', '\$${settings['referralAmount']}'),
          ]),

          _SectionCard('Charges', [
            _SettingTile('Night Charge', '${settings['nightChargePercent']}%'),
            _SettingTile('Cancellation', settings['cancellationChargeIsFixed'] == true
                ? '\$${settings['cancellationChargeAmount']}' : '${settings['cancellationChargeAmount']}%'),
          ]),

          _SectionCard('Feature Flags', [
            _ToggleTile('OTP Verification', settings['isOtpFeatureEnable'] == true, (v) =>
                context.read<SettingsBloc>().add(SettingsUpdateRequested({'isOtpFeatureEnable': v}))),
            _ToggleTile('Subscriptions', settings['isSubscriptionEnable'] == true, (v) =>
                context.read<SettingsBloc>().add(SettingsUpdateRequested({'isSubscriptionEnable': v}))),
            _ToggleTile('Document Verification', settings['isDocumentVerificationEnable'] == true, (v) =>
                context.read<SettingsBloc>().add(SettingsUpdateRequested({'isDocumentVerificationEnable': v}))),
            _ToggleTile('Auto-Approve Drivers', settings['isDriverAutoApproved'] == true, (v) =>
                context.read<SettingsBloc>().add(SettingsUpdateRequested({'isDriverAutoApproved': v}))),
          ]),

          _SectionCard('Safety', [
            _SettingTile('SOS Number', settings['sosAlertNumber']?.toString() ?? '112'),
          ]),
        ]));
      },
    ));
  }
}

class _SectionCard extends StatelessWidget {
  final String title; final List<Widget> children;
  const _SectionCard(this.title, this.children);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))),
        Card(child: Column(children: children)),
      ]);
}

class _SettingTile extends StatelessWidget {
  final String label; final String value;
  const _SettingTile(this.label, this.value);
  @override
  Widget build(BuildContext context) => ListTile(title: Text(label), trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)));
}

class _ToggleTile extends StatelessWidget {
  final String label; final bool value; final ValueChanged<bool> onChanged;
  const _ToggleTile(this.label, this.value, this.onChanged);
  @override
  Widget build(BuildContext context) => SwitchListTile(title: Text(label), value: value, onChanged: onChanged);
}
