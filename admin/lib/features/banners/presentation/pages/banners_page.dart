import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/banners_bloc.dart';

class BannersPage extends StatelessWidget {
  const BannersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Banners', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        FilledButton.icon(onPressed: () {
          context.read<BannersBloc>().add(const BannerCreateRequested('https://example.com/new_banner.jpg'));
        }, icon: const Icon(Icons.add), label: const Text('Add Banner')),
      ]),
      const SizedBox(height: 24),

      Expanded(child: BlocBuilder<BannersBloc, BannersState>(
        builder: (context, state) {
          if (state is BannersLoading) return const Center(child: CircularProgressIndicator());
          final banners = state is BannersLoaded ? state.banners : <BannerEntity>[];

          if (banners.isEmpty) return Center(child: Text('No banners', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)));

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 2),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Card(clipBehavior: Clip.antiAlias, child: Stack(children: [
                Container(color: colorScheme.surfaceContainerHighest, child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.image, size: 40, color: colorScheme.outline),
                      const SizedBox(height: 4),
                      Text('Banner ${index + 1}', style: theme.textTheme.bodySmall),
                    ]))),
                Positioned(top: 8, right: 8, child: IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: colorScheme.error),
                    icon: Icon(Icons.delete, color: colorScheme.onError, size: 18),
                    onPressed: () => context.read<BannersBloc>().add(BannerDeleteRequested(banner.id)))),
                Positioned(bottom: 8, left: 8, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: banner.isActive ? const Color(0xFF27C041).withValues(alpha: 0.9) : colorScheme.outline.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                    child: Text(banner.isActive ? 'Active' : 'Inactive', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)))),
              ]));
            },
          );
        },
      )),
    ]));
  }
}
