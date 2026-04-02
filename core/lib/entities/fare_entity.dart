import 'package:equatable/equatable.dart';

class FareEntity extends Equatable {
  final double baseFare;
  final double distanceCharge;
  final double timeCharge;
  final double subTotal;
  final double nightCharge;
  final double holdCharge;
  final double grossTotal;
  final double discount;
  final double taxAmount;
  final double totalAmount;
  final double adminCommission;
  final double driverEarning;

  const FareEntity({
    required this.baseFare,
    required this.distanceCharge,
    required this.timeCharge,
    required this.subTotal,
    this.nightCharge = 0,
    this.holdCharge = 0,
    required this.grossTotal,
    this.discount = 0,
    required this.taxAmount,
    required this.totalAmount,
    required this.adminCommission,
    required this.driverEarning,
  });

  @override
  List<Object?> get props => [totalAmount];
}
