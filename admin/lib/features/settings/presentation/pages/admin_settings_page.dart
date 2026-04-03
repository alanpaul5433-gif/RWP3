import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Settings saved successfully'), backgroundColor: const Color(0xFF2E7D32),
                behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) return const Center(child: CircularProgressIndicator());
          final s = state is SettingsLoaded ? state.settings : state is SettingsUpdated ? state.settings : <String, dynamic>{};
          if (s.isEmpty) return const Center(child: Text('No settings'));

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Settings', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(width: 12),
                    Text('Platform configuration', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                  ],
                ),
                const SizedBox(height: 28),

                // Two column layout
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(child: Column(children: [
                      _Section('General', [
                        _EditTile('App Name', s['appName']?.toString() ?? '', (v) => _save(context, 'appName', v)),
                        _EditTile('Full Name', s['appFullName']?.toString() ?? '', (v) => _save(context, 'appFullName', v)),
                        _EditTile('Country Code', s['countryCode']?.toString() ?? '', (v) => _save(context, 'countryCode', v)),
                        _EditTile('Currency', '${s['currency']} (${s['currencySymbol']})', (v) => _save(context, 'currency', v)),
                        _EditNumTile('Search Radius', s['searchRadius'] ?? 10.0, 'km', (v) => _save(context, 'searchRadius', v)),
                      ]),

                      _Section('Distance & Pricing', [
                        _DropdownTile('Default Distance Type', s['defaultDistanceType']?.toString() ?? 'km', ['km', 'miles'],
                            (v) => _save(context, 'defaultDistanceType', v)),
                        _EditNumTile('Price per KM', s['pricePerKm'] ?? 2.0, '\$/km', (v) => _save(context, 'pricePerKm', v)),
                        _EditNumTile('Price per Mile', s['pricePerMile'] ?? 1.5, '\$/mile', (v) => _save(context, 'pricePerMile', v)),
                        _InfoTile('Note', 'Each zone can override the default distance type. Vehicle types have their own per-km/per-mile rates.'),
                      ]),

                      _Section('Charges', [
                        _EditNumTile('Night Charge', s['nightChargePercent'] ?? 15.0, '%', (v) => _save(context, 'nightChargePercent', v)),
                        _EditNumTile('Night Start Hour', (s['nightChargeStartHour'] ?? 22).toDouble(), 'h (24hr)', (v) => _save(context, 'nightChargeStartHour', v.toInt())),
                        _EditNumTile('Night End Hour', (s['nightChargeEndHour'] ?? 6).toDouble(), 'h (24hr)', (v) => _save(context, 'nightChargeEndHour', v.toInt())),
                        _DropdownTile('Cancellation Type', s['cancellationChargeIsFixed'] == true ? 'Fixed' : 'Percentage', ['Fixed', 'Percentage'],
                            (v) => _save(context, 'cancellationChargeIsFixed', v == 'Fixed')),
                        _EditNumTile('Cancellation Amount', s['cancellationChargeAmount'] ?? 5.0,
                            s['cancellationChargeIsFixed'] == true ? '\$' : '%', (v) => _save(context, 'cancellationChargeAmount', v)),
                        _EditNumTile('Hold Charge', s['holdChargePerMinute'] ?? 0.5, '\$/min', (v) => _save(context, 'holdChargePerMinute', v)),
                      ]),

                      _Section('Safety', [
                        _EditTile('SOS Number', s['sosAlertNumber']?.toString() ?? '911', (v) => _save(context, 'sosAlertNumber', v)),
                        _EditNumTile('Max Emergency Contacts', (s['maxEmergencyContacts'] ?? 3).toDouble(), '', (v) => _save(context, 'maxEmergencyContacts', v.toInt())),
                      ]),
                    ])),

                    const SizedBox(width: 24),

                    // Right column
                    Expanded(child: Column(children: [
                      _Section('Financial', [
                        _DropdownTile('Commission Type', s['commissionIsFixed'] == true ? 'Fixed' : 'Percentage', ['Fixed', 'Percentage'],
                            (v) => _save(context, 'commissionIsFixed', v == 'Fixed')),
                        if (s['commissionIsFixed'] == true)
                          _EditNumTile('Commission Amount', s['commissionFixedAmount'] ?? 0.0, '\$', (v) => _save(context, 'commissionFixedAmount', v))
                        else
                          _EditNumTile('Commission', s['commissionPercent'] ?? 20.0, '%', (v) => _save(context, 'commissionPercent', v)),
                        _EditNumTile('Tax', s['taxPercent'] ?? 8.0, '%', (v) => _save(context, 'taxPercent', v)),
                        _EditNumTile('Min Deposit', s['minimumAmountToDeposit'] ?? 10.0, '\$', (v) => _save(context, 'minimumAmountToDeposit', v)),
                        _EditNumTile('Min Withdrawal', s['minimumAmountToWithdrawal'] ?? 20.0, '\$', (v) => _save(context, 'minimumAmountToWithdrawal', v)),
                        _EditNumTile('Referral Bonus', s['referralAmount'] ?? 5.0, '\$', (v) => _save(context, 'referralAmount', v)),
                        _EditNumTile('Loyalty Points/Ride', (s['loyaltyPointsPerRide'] ?? 10).toDouble(), 'pts', (v) => _save(context, 'loyaltyPointsPerRide', v.toInt())),
                        _EditNumTile('Point Value', s['loyaltyPointValue'] ?? 0.01, '\$/pt', (v) => _save(context, 'loyaltyPointValue', v)),
                      ]),

                      _Section('Payment Methods', [
                        _ToggleTile('Cash', s['isCashPaymentEnable'] == true, (v) => _save(context, 'isCashPaymentEnable', v)),
                        _ToggleTile('Wallet', s['isWalletPaymentEnable'] == true, (v) => _save(context, 'isWalletPaymentEnable', v)),
                        _ToggleTile('Card (Stripe)', s['isCardPaymentEnable'] == true, (v) => _save(context, 'isCardPaymentEnable', v)),
                      ]),

                      _Section('Feature Flags', [
                        _ToggleTile('OTP Verification', s['isOtpFeatureEnable'] == true, (v) => _save(context, 'isOtpFeatureEnable', v)),
                        _ToggleTile('Subscriptions', s['isSubscriptionEnable'] == true, (v) => _save(context, 'isSubscriptionEnable', v)),
                        _ToggleTile('Document Verification', s['isDocumentVerificationEnable'] == true, (v) => _save(context, 'isDocumentVerificationEnable', v)),
                        _ToggleTile('Auto-Approve Drivers', s['isDriverAutoApproved'] == true, (v) => _save(context, 'isDriverAutoApproved', v)),
                        _ToggleTile('Female-Only Rides', s['isFemaleOnlyRideEnable'] == true, (v) => _save(context, 'isFemaleOnlyRideEnable', v)),
                        _ToggleTile('Driver Bidding', s['isBiddingEnable'] == true, (v) => _save(context, 'isBiddingEnable', v)),
                        _ToggleTile('Demo Mode', s['isDemoMode'] == true, (v) => _save(context, 'isDemoMode', v)),
                      ]),

                      _Section('App Version', [
                        _EditTile('Min Version', s['minAppVersion']?.toString() ?? '1.0.0', (v) => _save(context, 'minAppVersion', v)),
                        _EditTile('Latest Version', s['latestAppVersion']?.toString() ?? '1.0.0', (v) => _save(context, 'latestAppVersion', v)),
                        _ToggleTile('Force Update', s['forceUpdate'] == true, (v) => _save(context, 'forceUpdate', v)),
                      ]),
                    ])),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _save(BuildContext context, String key, dynamic value) {
    context.read<SettingsBloc>().add(SettingsUpdateRequested({key: value}));
  }
}

// ==================== Section ====================
class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

// ==================== Editable Text Tile ====================
class _EditTile extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onSave;
  const _EditTile(this.label, this.value, this.onSave);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () {
        final ctrl = TextEditingController(text: value);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Edit $label'),
            content: TextField(controller: ctrl, autofocus: true, decoration: InputDecoration(labelText: label)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(onPressed: () { Navigator.pop(ctx); onSave(ctrl.text); }, child: const Text('Save')),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Icon(Icons.edit_outlined, size: 14, color: colorScheme.primary.withValues(alpha: 0.5)),
        ]),
      ),
    );
  }
}

// ==================== Editable Number Tile ====================
class _EditNumTile extends StatelessWidget {
  final String label;
  final double value;
  final String suffix;
  final ValueChanged<double> onSave;
  const _EditNumTile(this.label, this.value, this.suffix, this.onSave);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final display = value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsFixed(2);
    return InkWell(
      onTap: () {
        final ctrl = TextEditingController(text: display);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Edit $label'),
            content: TextField(controller: ctrl, autofocus: true, keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: label, suffixText: suffix)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(onPressed: () { Navigator.pop(ctx); onSave(double.tryParse(ctrl.text) ?? value); }, child: const Text('Save')),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text('$display $suffix', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Icon(Icons.edit_outlined, size: 14, color: colorScheme.primary.withValues(alpha: 0.5)),
        ]),
      ),
    );
  }
}

// ==================== Dropdown Tile ====================
class _DropdownTile extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onSave;
  const _DropdownTile(this.label, this.value, this.options, this.onSave);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8E5E0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: options.contains(value) ? value : options.first,
              items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
              onChanged: (v) { if (v != null) onSave(v); },
            ),
          ),
        ),
      ]),
    );
  }
}

// ==================== Toggle Tile ====================
class _ToggleTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleTile(this.label, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Switch(value: value, activeColor: const Color(0xFF2E7D32), onChanged: onChanged),
      ]),
    );
  }
}

// ==================== Info Tile ====================
class _InfoTile extends StatelessWidget {
  final String label;
  final String text;
  const _InfoTile(this.label, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1976D2).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          const Icon(Icons.info_outline, size: 16, color: Color(0xFF1976D2)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF1976D2)))),
        ]),
      ),
    );
  }
}
