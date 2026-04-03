import 'package:core/core.dart';

class MockSubscriptionsDataSource {
  final List<SubscriptionPlanEntity> _plans = [
    const SubscriptionPlanEntity(id: 'sp_1', name: 'Bronze', description: 'Basic monthly access with standard features', price: 49.00, expiryDays: 30, totalBookings: 50),
    const SubscriptionPlanEntity(id: 'sp_2', name: 'Silver', description: 'Enhanced access with priority dispatch', price: 129.00, expiryDays: 30, totalBookings: 150),
    const SubscriptionPlanEntity(id: 'sp_3', name: 'Gold', description: 'Unlimited bookings with premium perks', price: 299.00, expiryDays: 30, totalBookings: 999),
  ];

  Future<List<SubscriptionPlanEntity>> getPlans() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_plans);
  }

  Future<SubscriptionPlanEntity> createPlan(SubscriptionPlanEntity plan) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newPlan = SubscriptionPlanEntity(
      id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
      name: plan.name, description: plan.description,
      price: plan.price, expiryDays: plan.expiryDays,
      totalBookings: plan.totalBookings, isActive: plan.isActive,
    );
    _plans.add(newPlan);
    return newPlan;
  }

  Future<SubscriptionPlanEntity> updatePlan(SubscriptionPlanEntity plan) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _plans.indexWhere((p) => p.id == plan.id);
    if (idx >= 0) _plans[idx] = plan;
    return plan;
  }

  Future<void> deletePlan(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _plans.removeWhere((p) => p.id == id);
  }
}
