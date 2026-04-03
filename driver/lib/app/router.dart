import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/bloc/driver_auth_bloc.dart';
import '../features/auth/presentation/pages/driver_login_page.dart';
import '../features/home/presentation/bloc/driver_home_bloc.dart';
import '../features/home/presentation/pages/driver_home_page.dart';
// Booking bloc used for active rides, not history
import '../features/documents/presentation/bloc/documents_bloc.dart';
import '../features/bank/presentation/bloc/bank_bloc.dart';
import '../injection_container.dart';

GoRouter createDriverRouter(DriverAuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _RefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final path = state.matchedLocation;
      final isPublic = path == '/login' || path == '/';

      if (authState is DriverAuthenticated && isPublic) return '/home';
      if (authState is DriverUnauthenticated && !isPublic) return '/login';
      return null;
    },
    routes: [
      // Root redirect
      GoRoute(path: '/', redirect: (_, __) => '/home'),

      // Login
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider.value(
          value: sl<DriverAuthBloc>(),
          child: const DriverLoginPage(),
        ),
      ),

      // Home (dashboard with bottom nav)
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

      // Rides
      GoRoute(
        path: '/rides',
        builder: (context, state) => const _RidesPage(),
      ),

      // Earnings
      GoRoute(path: '/earnings', builder: (_, __) => const _EarningsPage()),

      // Documents
      GoRoute(
        path: '/documents',
        builder: (context, state) {
          final authState = authBloc.state;
          final driverId = authState is DriverAuthenticated ? authState.driver.id : '';
          return BlocProvider(
            create: (_) => sl<DocumentsBloc>()..add(DocumentsLoadRequested(driverId)),
            child: const _DocumentsPage(),
          );
        },
      ),

      // Bank & Withdrawals
      GoRoute(
        path: '/bank',
        builder: (context, state) {
          final authState = authBloc.state;
          final driverId = authState is DriverAuthenticated ? authState.driver.id : '';
          return BlocProvider(
            create: (_) => sl<BankBloc>()..add(BankAccountsLoadRequested(driverId)),
            child: const _BankPage(),
          );
        },
      ),

      // Profile
      GoRoute(path: '/profile', builder: (_, __) => const _ProfilePage()),

      // Vehicle
      GoRoute(path: '/vehicle', builder: (_, __) => const _VehiclePage()),

      // Statements
      GoRoute(path: '/statements', builder: (_, __) => const _StatementsPage()),

      // Subscription
      GoRoute(path: '/subscription', builder: (_, __) => const _SubscriptionPage()),

      // Settings
      GoRoute(
        path: '/settings',
        builder: (context, state) => BlocProvider.value(
          value: sl<DriverAuthBloc>(),
          child: const _SettingsPage(),
        ),
      ),
    ],
  );
}

// ==================== Rides Page ====================
class _RidesPage extends StatelessWidget {
  const _RidesPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    return Scaffold(
      appBar: AppBar(title: const Text('My Rides')),
      body: Builder(
        builder: (context) {
          // Mock ride history
          final rides = [
            {'name': 'Sarah J.', 'from': 'Downtown Mall', 'to': 'Airport Terminal 2', 'fare': '\$28.50', 'status': 'Completed', 'time': '2h ago'},
            {'name': 'Marcus W.', 'from': 'Grand Hyatt', 'to': 'City Airport', 'fare': '\$34.50', 'status': 'Completed', 'time': '5h ago'},
            {'name': 'Emily R.', 'from': 'Central Park', 'to': 'Brooklyn Heights', 'fare': '\$18.75', 'status': 'Cancelled', 'time': 'Yesterday'},
            {'name': 'James K.', 'from': 'Penn Station', 'to': 'Times Square', 'fare': '\$12.00', 'status': 'Completed', 'time': 'Yesterday'},
            {'name': 'Olivia P.', 'from': 'SoHo', 'to': 'Upper East Side', 'fare': '\$22.30', 'status': 'Completed', 'time': '2 days ago'},
          ];

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: rides.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final r = rides[i];
              final isCancelled = r['status'] == 'Cancelled';
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    CircleAvatar(radius: 18, backgroundColor: cs.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.person, size: 18, color: cs.primary)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(r['name']!, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
                    Text(r['fare']!, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.circle, size: 8, color: const Color(0xFF2E7D32)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(r['from']!, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.6)))),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Container(width: 2, height: 16, color: cs.outline),
                  ),
                  Row(children: [
                    Icon(Icons.circle, size: 8, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(r['to']!, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.6)))),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCancelled ? cs.error.withValues(alpha: 0.1) : const Color(0xFF2E7D32).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(r['status']!, style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600, color: isCancelled ? cs.error : const Color(0xFF2E7D32))),
                    ),
                    const Spacer(),
                    Text(r['time']!, style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.4))),
                  ]),
                ]),
              );
            },
          );
        },
      ),
    );
  }
}

// ==================== Earnings Page ====================
class _EarningsPage extends StatelessWidget {
  const _EarningsPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Total balance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Total Balance', style: theme.textTheme.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.6))),
              const SizedBox(height: 8),
              Text('\$2,847.50', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _BankPage())),
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: cs.primary, minimumSize: const Size(0, 44)),
                child: const Text('Withdraw Funds'),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // Weekly breakdown
          Text('This Week', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].asMap().entries.map((e) {
            final amounts = [82.50, 125.00, 68.75, 142.30, 95.00, 180.25, 0.0];
            final rides = [6, 9, 5, 10, 7, 12, 0];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                SizedBox(width: 40, child: Text(e.value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
                const SizedBox(width: 12),
                Expanded(child: LinearProgressIndicator(
                  value: amounts[e.key] / 200,
                  backgroundColor: cs.outline,
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(4),
                )),
                const SizedBox(width: 16),
                SizedBox(width: 70, child: Text('\$${amounts[e.key].toStringAsFixed(2)}',
                  textAlign: TextAlign.right, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700))),
                const SizedBox(width: 12),
                SizedBox(width: 50, child: Text('${rides[e.key]} rides',
                  textAlign: TextAlign.right, style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.4)))),
              ]),
            );
          }),
        ]),
      ),
    );
  }
}

// ==================== Documents Page ====================
class _DocumentsPage extends StatelessWidget {
  const _DocumentsPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    final docs = [
      {'name': 'Driver License (Front)', 'status': 'Verified', 'icon': Icons.badge},
      {'name': 'Driver License (Back)', 'status': 'Verified', 'icon': Icons.badge},
      {'name': 'National ID (Front)', 'status': 'Pending', 'icon': Icons.credit_card},
      {'name': 'National ID (Back)', 'status': 'Not Uploaded', 'icon': Icons.credit_card},
      {'name': 'Vehicle Registration', 'status': 'Verified', 'icon': Icons.directions_car},
      {'name': 'Insurance Certificate', 'status': 'Not Uploaded', 'icon': Icons.shield},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: docs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final d = docs[i];
          final isVerified = d['status'] == 'Verified';
          final isPending = d['status'] == 'Pending';
          final statusColor = isVerified ? const Color(0xFF2E7D32) : isPending ? const Color(0xFFFF8F00) : cs.onSurface.withValues(alpha: 0.4);

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: cs.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                child: Icon(d['icon'] as IconData, size: 22, color: cs.primary),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d['name'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(isVerified ? Icons.check_circle : isPending ? Icons.schedule : Icons.upload, size: 14, color: statusColor),
                  const SizedBox(width: 4),
                  Text(d['status'] as String, style: theme.textTheme.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.w600)),
                ]),
              ])),
              if (!isVerified)
                FilledButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Upload ${d['name']} — camera/gallery picker will open on mobile')),
                  ),
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 16)),
                  child: Text(isPending ? 'Re-upload' : 'Upload'),
                ),
              if (isVerified)
                Icon(Icons.check_circle, color: statusColor, size: 24),
            ]),
          );
        },
      ),
    );
  }
}

// ==================== Bank & Withdrawal Page ====================
class _BankPage extends StatefulWidget {
  const _BankPage();

  @override
  State<_BankPage> createState() => _BankPageState();
}

class _BankPageState extends State<_BankPage> {
  final _amountCtrl = TextEditingController();
  String _selectedBank = 'Chase Checking ****4521';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    final banks = [
      {'name': 'Chase Checking ****4521', 'type': 'Checking', 'icon': Icons.account_balance},
      {'name': 'Wells Fargo Savings ****8832', 'type': 'Savings', 'icon': Icons.account_balance},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Bank & Withdrawals')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Available balance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Available for Withdrawal', style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface.withValues(alpha: 0.5))),
              const SizedBox(height: 8),
              Text('\$2,847.50', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Min withdrawal: \$20.00', style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.4))),
            ]),
          ),

          const SizedBox(height: 24),

          // Bank accounts
          Text('Bank Accounts', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...banks.map((b) => GestureDetector(
            onTap: () => setState(() => _selectedBank = b['name'] as String),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: _selectedBank == b['name'] ? Border.all(color: cs.primary, width: 2) : Border.all(color: cs.outline),
              ),
              child: Row(children: [
                Icon(b['icon'] as IconData, size: 22, color: cs.primary),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b['name'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  Text(b['type'] as String, style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.4))),
                ])),
                if (_selectedBank == b['name'])
                  Icon(Icons.check_circle, color: cs.primary, size: 22),
              ]),
            ),
          )),
          TextButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add bank form — will connect to Stripe Connect'))),
            icon: const Icon(Icons.add),
            label: const Text('Add Bank Account'),
          ),

          const SizedBox(height: 24),

          // Withdraw
          Text('Withdraw Funds', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$ ', hintText: '0.00'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(_amountCtrl.text) ?? 0;
              if (amount < 20) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Minimum withdrawal is \$20.00')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Withdrawal of \$${amount.toStringAsFixed(2)} to $_selectedBank requested')));
                _amountCtrl.clear();
              }
            },
            child: const Text('Request Withdrawal'),
          ),

          const SizedBox(height: 24),

          // Recent withdrawals
          Text('Recent Withdrawals', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...[
            {'amount': '\$500.00', 'bank': 'Chase ****4521', 'date': 'Mar 28', 'status': 'Completed'},
            {'amount': '\$250.00', 'bank': 'Chase ****4521', 'date': 'Mar 21', 'status': 'Completed'},
            {'amount': '\$100.00', 'bank': 'Wells Fargo ****8832', 'date': 'Mar 15', 'status': 'Pending'},
          ].map((w) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Text(w['amount']!, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 12),
              Expanded(child: Text(w['bank']!, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.5)))),
              Text(w['date']!, style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.4))),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: w['status'] == 'Completed' ? const Color(0xFF2E7D32).withValues(alpha: 0.1) : const Color(0xFFFF8F00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(w['status']!, style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600, color: w['status'] == 'Completed' ? const Color(0xFF2E7D32) : const Color(0xFFFF8F00))),
              ),
            ]),
          )),
        ]),
      ),
    );
  }
}

// ==================== Settings Page ====================
class _SettingsPage extends StatelessWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    final sections = [
      {'title': 'Account', 'items': [
        {'icon': Icons.person_outline, 'label': 'Edit Profile', 'route': '/profile'},
        {'icon': Icons.badge_outlined, 'label': 'Documents', 'route': '/documents'},
        {'icon': Icons.directions_car_outlined, 'label': 'Vehicle Details', 'route': '/vehicle'},
      ]},
      {'title': 'Financial', 'items': [
        {'icon': Icons.account_balance_outlined, 'label': 'Bank Accounts', 'route': '/bank'},
        {'icon': Icons.receipt_long_outlined, 'label': 'Statements', 'route': '/statements'},
        {'icon': Icons.card_membership_outlined, 'label': 'Subscription', 'route': '/subscription'},
      ]},
      {'title': 'App', 'items': [
        {'icon': Icons.notifications_outlined, 'label': 'Notifications', 'route': ''},
        {'icon': Icons.dark_mode_outlined, 'label': 'Dark Mode', 'route': ''},
        {'icon': Icons.language_outlined, 'label': 'Language', 'route': ''},
        {'icon': Icons.help_outline, 'label': 'Support', 'route': ''},
      ]},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...sections.map((section) {
            final items = section['items'] as List<Map<String, dynamic>>;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(section['title'] as String, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                child: Column(children: items.asMap().entries.map((e) {
                  final item = e.value;
                  return Column(children: [
                    ListTile(
                      leading: Icon(item['icon'] as IconData, color: cs.primary, size: 22),
                      title: Text(item['label'] as String, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.chevron_right, size: 20, color: cs.onSurface.withValues(alpha: 0.3)),
                      onTap: () {
                        final route = item['route'] as String;
                        if (route.isNotEmpty) context.push(route);
                      },
                    ),
                    if (e.key < items.length - 1) Divider(height: 1, indent: 56, color: cs.outline),
                  ]);
                }).toList()),
              ),
              const SizedBox(height: 24),
            ]);
          }),

          // Logout
          FilledButton(
            onPressed: () => context.read<DriverAuthBloc>().add(const DriverLogoutRequested()),
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            child: const Text('Log Out'),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }
}

// ==================== Profile Page ====================
class _ProfilePage extends StatefulWidget {
  const _ProfilePage();
  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  final _nameCtrl = TextEditingController(text: 'John Driver');
  final _emailCtrl = TextEditingController(text: 'john.driver@email.com');
  final _phoneCtrl = TextEditingController(text: '+1 555-0192');
  String _gender = 'Male';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Avatar
          Center(child: Stack(children: [
            CircleAvatar(radius: 50, backgroundColor: cs.primary.withValues(alpha: 0.1),
              child: Icon(Icons.person, size: 50, color: cs.primary)),
            Positioned(bottom: 0, right: 0, child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
            )),
          ])),
          const SizedBox(height: 28),

          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 16),
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
          const SizedBox(height: 16),
          TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined))),
          const SizedBox(height: 16),

          // Gender
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: cs.outline)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              value: _gender,
              isExpanded: true,
              items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => _gender = v!),
            )),
          ),
          const SizedBox(height: 28),

          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
              Navigator.pop(context);
            },
            child: const Text('Save Changes'),
          ),
        ]),
      ),
    );
  }
}

// ==================== Vehicle Details Page ====================
class _VehiclePage extends StatefulWidget {
  const _VehiclePage();
  @override
  State<_VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<_VehiclePage> {
  String _vehicleType = 'Sedan';
  String _brand = 'Toyota';
  String _model = 'Camry';
  final _plateCtrl = TextEditingController(text: 'ABC-1234');
  final _yearCtrl = TextEditingController(text: '2022');
  final _colorCtrl = TextEditingController(text: 'Black');
  List<String> _selectedZones = ['Downtown', 'Airport'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;
    final allZones = ['Downtown', 'Airport', 'Suburbs', 'Highway', 'University', 'Beach'];

    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Vehicle type
          Text('Vehicle Type', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: cs.outline)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              value: _vehicleType, isExpanded: true,
              items: ['Sedan', 'SUV', 'Hatchback', 'Van', 'Luxury'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _vehicleType = v!),
            )),
          ),
          const SizedBox(height: 16),

          // Brand
          Text('Brand', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: cs.outline)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              value: _brand, isExpanded: true,
              items: ['Toyota', 'Honda', 'BMW', 'Mercedes', 'Ford', 'Hyundai'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (v) => setState(() => _brand = v!),
            )),
          ),
          const SizedBox(height: 16),

          // Model
          Text('Model', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: cs.outline)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              value: _model, isExpanded: true,
              items: ['Camry', 'Corolla', 'Civic', 'Accord', '3 Series', 'C-Class', 'Mustang', 'Sonata'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (v) => setState(() => _model = v!),
            )),
          ),
          const SizedBox(height: 16),

          TextField(controller: _plateCtrl, decoration: const InputDecoration(labelText: 'License Plate', prefixIcon: Icon(Icons.pin_outlined))),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: TextField(controller: _yearCtrl, decoration: const InputDecoration(labelText: 'Year'), keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: TextField(controller: _colorCtrl, decoration: const InputDecoration(labelText: 'Color'))),
          ]),
          const SizedBox(height: 24),

          // Service Zones
          Text('Service Zones', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: allZones.map((z) {
            final selected = _selectedZones.contains(z);
            return FilterChip(
              label: Text(z),
              selected: selected,
              selectedColor: cs.primary.withValues(alpha: 0.15),
              checkmarkColor: cs.primary,
              onSelected: (v) => setState(() => v ? _selectedZones.add(z) : _selectedZones.remove(z)),
            );
          }).toList()),
          const SizedBox(height: 28),

          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle details updated')));
              Navigator.pop(context);
            },
            child: const Text('Save Vehicle Details'),
          ),
        ]),
      ),
    );
  }
}

// ==================== Statements Page ====================
class _StatementsPage extends StatefulWidget {
  const _StatementsPage();
  @override
  State<_StatementsPage> createState() => _StatementsPageState();
}

class _StatementsPageState extends State<_StatementsPage> {
  String _selectedType = 'All';
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    final statements = [
      {'date': 'Mar 28', 'type': 'Cab', 'rides': '8', 'gross': '\$245.50', 'commission': '\$49.10', 'net': '\$196.40'},
      {'date': 'Mar 27', 'type': 'Cab', 'rides': '12', 'gross': '\$380.00', 'commission': '\$76.00', 'net': '\$304.00'},
      {'date': 'Mar 26', 'type': 'Intercity', 'rides': '2', 'gross': '\$420.00', 'commission': '\$84.00', 'net': '\$336.00'},
      {'date': 'Mar 25', 'type': 'Parcel', 'rides': '5', 'gross': '\$125.75', 'commission': '\$25.15', 'net': '\$100.60'},
      {'date': 'Mar 24', 'type': 'Cab', 'rides': '10', 'gross': '\$312.00', 'commission': '\$62.40', 'net': '\$249.60'},
      {'date': 'Mar 23', 'type': 'Cab', 'rides': '6', 'gross': '\$185.25', 'commission': '\$37.05', 'net': '\$148.20'},
    ];

    final filtered = _selectedType == 'All' ? statements : statements.where((s) => s['type'] == _selectedType).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Statements'), actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exporting statement as Excel... (will work on mobile)'))),
        ),
      ]),
      body: Column(children: [
        // Filters
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            // Type filter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outline)),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                value: _selectedType,
                items: ['All', 'Cab', 'Intercity', 'Parcel', 'Rental'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              )),
            ),
            const SizedBox(width: 12),
            // Period filter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outline)),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                value: _selectedPeriod,
                items: ['This Week', 'This Month', 'Last Month', 'This Year'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _selectedPeriod = v!),
              )),
            ),
          ]),
        ),

        // Summary card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(16)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Column(children: [
                Text('Gross', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.6))),
                const SizedBox(height: 4),
                Text('\$1,668.50', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
              ]),
              Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.2)),
              Column(children: [
                Text('Commission', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.6))),
                const SizedBox(height: 4),
                Text('\$333.70', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
              ]),
              Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.2)),
              Column(children: [
                Text('Net', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.6))),
                const SizedBox(height: 4),
                Text('\$1,334.80', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: 12),

        // Statement list
        Expanded(child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final s = filtered[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                SizedBox(width: 55, child: Text(s['date']!, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: cs.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                  child: Text(s['type']!, style: theme.textTheme.labelSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                Text('${s['rides']} rides', style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.4))),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(s['net']!, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  Text('${s['commission']} fee', style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.4), fontSize: 10)),
                ]),
              ]),
            );
          },
        )),
      ]),
    );
  }
}

// ==================== Subscription Page ====================
class _SubscriptionPage extends StatelessWidget {
  const _SubscriptionPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    final plans = [
      {'name': 'Basic', 'price': '\$9.99/mo', 'commission': '20%', 'features': ['Standard ride requests', 'Basic support', 'Weekly payouts'], 'current': false, 'color': cs.onSurface},
      {'name': 'Pro', 'price': '\$24.99/mo', 'commission': '15%', 'features': ['Priority ride requests', 'Priority support', 'Daily payouts', 'Surge zone alerts'], 'current': true, 'color': cs.primary},
      {'name': 'Elite', 'price': '\$49.99/mo', 'commission': '10%', 'features': ['First access to rides', '24/7 dedicated support', 'Instant payouts', 'Surge zone alerts', 'Featured driver badge'], 'current': false, 'color': const Color(0xFFDAA520)},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Plans')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Current plan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Current Plan', style: theme.textTheme.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.6))),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text('ACTIVE', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ]),
              const SizedBox(height: 8),
              Text('Pro Plan', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
              Text('Renews Apr 15, 2026', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.6))),
            ]),
          ),
          const SizedBox(height: 28),

          Text('Available Plans', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),

          ...plans.map((p) {
            final isCurrent = p['current'] as bool;
            final planColor = p['color'] as Color;
            final features = p['features'] as List<String>;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: isCurrent ? Border.all(color: cs.primary, width: 2) : Border.all(color: cs.outline),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(p['name'] as String, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: planColor)),
                  const Spacer(),
                  if (isCurrent) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: cs.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('CURRENT', style: theme.textTheme.labelSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  Text(p['price'] as String, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 12),
                  Text('${p['commission']} commission', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.5))),
                ]),
                const SizedBox(height: 14),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Icon(Icons.check_circle, size: 16, color: planColor),
                    const SizedBox(width: 8),
                    Text(f, style: theme.textTheme.bodySmall),
                  ]),
                )),
                if (!isCurrent) ...[
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Upgrading to ${p['name']} plan — Stripe payment will open on mobile'))),
                    style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                    child: Text('Switch to ${p['name']}'),
                  ),
                ],
              ]),
            );
          }),
        ]),
      ),
    );
  }
}

class _RefreshStream extends ChangeNotifier {
  _RefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}
