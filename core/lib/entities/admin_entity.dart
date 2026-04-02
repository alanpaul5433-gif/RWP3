import 'package:equatable/equatable.dart';

class AdminEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profilePic;
  final String role;
  final String fcmToken;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber = '',
    this.profilePic = '',
    this.role = 'admin',
    this.fcmToken = '',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, email, role];
}

class DashboardStatsEntity extends Equatable {
  final int totalCustomers;
  final int totalDrivers;
  final int totalBookings;
  final int activeBookings;
  final int completedBookings;
  final int cancelledBookings;
  final double todayEarnings;
  final double monthlyEarnings;

  const DashboardStatsEntity({
    this.totalCustomers = 0,
    this.totalDrivers = 0,
    this.totalBookings = 0,
    this.activeBookings = 0,
    this.completedBookings = 0,
    this.cancelledBookings = 0,
    this.todayEarnings = 0,
    this.monthlyEarnings = 0,
  });

  @override
  List<Object?> get props => [
        totalCustomers,
        totalDrivers,
        totalBookings,
        todayEarnings,
      ];
}
