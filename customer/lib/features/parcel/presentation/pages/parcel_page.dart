import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../bloc/parcel_bloc.dart';

class ParcelPage extends StatefulWidget {
  const ParcelPage({super.key});

  @override
  State<ParcelPage> createState() => _ParcelPageState();
}

class _ParcelPageState extends State<ParcelPage> {
  double _weight = 5.0;
  String _priority = 'standard';
  final _lengthController = TextEditingController(text: '0');
  final _widthController = TextEditingController(text: '0');
  final _heightController = TextEditingController(text: '0');

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('RWP', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.primary, letterSpacing: 1)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Parcel', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: 1.1)),
                    Text('Details', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.onSurface.withValues(alpha: 0.4), height: 1.1)),
                    const SizedBox(height: 8),
                    Text('Specify dimensions for accurate logistics.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),

                    const SizedBox(height: 24),

                    // Pickup / Drop
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Row(children: [
                            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF2E7D32), shape: BoxShape.circle)),
                            const SizedBox(width: 14),
                            Expanded(child: Text('742 Evergreen Terrace', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
                          ]),
                          Padding(padding: const EdgeInsets.only(left: 4), child: Align(alignment: Alignment.centerLeft, child: Container(width: 2, height: 20, color: const Color(0xFFE8E5E0)))),
                          Row(children: [
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle)),
                            const SizedBox(width: 14),
                            Expanded(child: Text('Springfield Business Park, Dock 4', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
                          ]),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Weight slider
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Weight', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                              Text('${_weight.toStringAsFixed(1)} kg', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.primary)),
                            ],
                          ),
                          Slider(
                            value: _weight,
                            min: 0.5,
                            max: 50,
                            divisions: 99,
                            activeColor: colorScheme.primary,
                            onChanged: (v) => setState(() => _weight = v),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Light', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                              Text('Medium (5kg)', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                              Text('Heavy', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dimensions
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dimensions (cm)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _DimField(label: 'L', controller: _lengthController)),
                              const SizedBox(width: 12),
                              Expanded(child: _DimField(label: 'W', controller: _widthController)),
                              const SizedBox(width: 12),
                              Expanded(child: _DimField(label: 'H', controller: _heightController)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Upload Photo
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8E5E0)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 28, color: colorScheme.primary),
                          const SizedBox(height: 8),
                          Text('Upload Photo', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.primary)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Priority toggle
                    Text('SHIPPING LEVEL', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4), letterSpacing: 1, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          _PriorityChip('Priority', _priority == 'priority', () => setState(() => _priority = 'priority'), colorScheme.primary),
                          _PriorityChip('Standard', _priority == 'standard', () => setState(() => _priority = 'standard'), colorScheme.onSurface),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                      Text('\$24.50', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Parcel booked successfully! Finding a driver...')));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Confirm Parcel'), SizedBox(width: 8), Icon(Icons.check, size: 18)],
                      ),
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

class _DimField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _DimField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;
  const _PriorityChip(this.label, this.active, this.onTap, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: active ? Colors.white : color.withValues(alpha: 0.5)))),
        ),
      ),
    );
  }
}
