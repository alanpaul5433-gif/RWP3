import 'package:core/core.dart';

class MockSubscriptionsDataSource {
  final List<SubscriptionPlanEntity> _plans = const [
    SubscriptionPlanEntity(id: 'sp_1', name: 'Basic', description: '30 day access', price: 29.99, expiryDays: 30, totalBookings: 50),
    SubscriptionPlanEntity(id: 'sp_2', name: 'Standard', description: '60 day access', price: 49.99, expiryDays: 60, totalBookings: 150),
    SubscriptionPlanEntity(id: 'sp_3', name: 'Premium', description: '90 day unlimited', price: 79.99, expiryDays: 90, totalBookings: 999),
  ];

  Future<List<SubscriptionPlanEntity>> getPlans() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _plans;
  }
}
