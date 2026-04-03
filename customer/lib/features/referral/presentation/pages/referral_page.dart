import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/referral_bloc.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Referral')),
      body: BlocBuilder<ReferralBloc, ReferralState>(
        builder: (context, state) {
          if (state is ReferralLoading) return const Center(child: CircularProgressIndicator());

          final code = state is ReferralCodeLoaded ? state.code : '------';

          return Padding(padding: const EdgeInsets.all(24), child: Column(children: [
            const SizedBox(height: 32),
            Icon(Icons.card_giftcard, size: 64, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text('Invite Friends', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Share your code and earn rewards when they sign up and take their first ride.',
                style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)), textAlign: TextAlign.center),
            const SizedBox(height: 32),

            // Code card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3), width: 2, strokeAlign: BorderSide.strokeAlignInside),
              ),
              child: Column(children: [
                Text('Your Referral Code', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7))),
                const SizedBox(height: 8),
                Text(code, style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 6, color: colorScheme.onPrimaryContainer)),
              ]),
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () {
                // In production: Share.share('Join RWP with my code: $code')
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share functionality requires native share plugin')));
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Code'),
            ),
          ]));
        },
      ),
    );
  }
}
