import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingData(
      icon: Icons.local_taxi_rounded,
      title: 'Book a ride',
      titleHighlight: 'Anywhere.',
      description: 'From daily commutes to intercity travel and parcel deliveries.',
      features: [
        _FeatureChip(Icons.schedule, 'Daily/Local'),
        _FeatureChip(Icons.location_on, 'Intercity'),
      ],
    ),
    _OnboardingData(
      icon: Icons.map_rounded,
      title: 'Track in',
      titleHighlight: 'Real-Time.',
      description: 'Watch your driver on a live map with accurate arrival times.',
      features: [
        _FeatureChip(Icons.gps_fixed, 'Live GPS'),
        _FeatureChip(Icons.timer, 'ETA Updates'),
      ],
    ),
    _OnboardingData(
      icon: Icons.payment_rounded,
      title: 'Pay Your',
      titleHighlight: 'Way.',
      description: 'Card, wallet, or cash. Simple, secure, and hassle-free payments.',
      features: [
        _FeatureChip(Icons.credit_card, 'Card/Wallet'),
        _FeatureChip(Icons.money, 'Cash'),
      ],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: brand + skip
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Skip',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Illustration card
                        Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  page.icon,
                                  size: 120,
                                  color: colorScheme.primary.withValues(alpha: 0.15),
                                ),
                              ),
                              // Badge overlay
                              Positioned(
                                right: 16,
                                bottom: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(Icons.directions_car, size: 16, color: colorScheme.primary),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'NEAREST RIDE',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: colorScheme.onSurface.withValues(alpha: 0.4),
                                              fontSize: 9,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            '2 mins away',
                                            style: theme.textTheme.labelMedium?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Title
                        Text(
                          page.title,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          page.titleHighlight,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          page.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Feature chips
                        Row(
                          children: page.features.map((f) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(f.icon, color: colorScheme.primary, size: 22),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    f.label,
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom: dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  // Dots
                  Row(
                    children: List.generate(_pages.length, (i) {
                      return Container(
                        width: _currentPage == i ? 28 : 8,
                        height: 4,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // Next button
                  FilledButton(
                    onPressed: _onNext,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String titleHighlight;
  final String description;
  final List<_FeatureChip> features;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.titleHighlight,
    required this.description,
    required this.features,
  });
}

class _FeatureChip {
  final IconData icon;
  final String label;
  const _FeatureChip(this.icon, this.label);
}
