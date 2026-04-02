import 'package:core/core.dart';

class MockBannersDataSource {
  final List<BannerEntity> _banners = List.generate(
    3,
    (i) => BannerEntity(
      id: 'bn_$i',
      image: 'https://example.com/banner_$i.jpg',
      isActive: true,
      createdAt: DateTime.now().subtract(Duration(days: i * 5)),
    ),
  );

  Future<List<BannerEntity>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_banners);
  }

  Future<BannerEntity> createBanner({required String image}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final banner = BannerEntity(
      id: 'bn_${DateTime.now().millisecondsSinceEpoch}',
      image: image,
      createdAt: DateTime.now(),
    );
    _banners.add(banner);
    return banner;
  }

  Future<void> deleteBanner(String bannerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _banners.removeWhere((b) => b.id == bannerId);
  }
}
