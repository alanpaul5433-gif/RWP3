import 'package:equatable/equatable.dart';

class SubscriptionPlanEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final int expiryDays;
  final int totalBookings;
  final bool isActive;

  const SubscriptionPlanEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.expiryDays,
    this.totalBookings = 0,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, price];
}
