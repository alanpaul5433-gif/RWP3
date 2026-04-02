import 'package:core/core.dart';

class MockCustomerDataSource {
  final List<UserEntity> _customers = List.generate(
    25,
    (i) => UserEntity(
      id: 'user_$i',
      fullName: 'Customer ${i + 1}',
      email: 'customer${i + 1}@example.com',
      phoneNumber: '+1234567${i.toString().padLeft(4, '0')}',
      gender: i % 2 == 0 ? 'Male' : 'Female',
      walletAmount: (i + 1) * 10.0,
      totalRide: i * 3,
      isActive: i != 5, // customer 6 is inactive
      createdAt: DateTime(2024, 1, 1).add(Duration(days: i)),
      updatedAt: DateTime.now(),
    ),
  );

  Future<List<UserEntity>> getCustomers({
    int page = 0,
    int pageSize = 10,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var filtered = _customers.toList();
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered = filtered
          .where((c) =>
              c.fullName.toLowerCase().contains(q) ||
              c.email.toLowerCase().contains(q) ||
              c.phoneNumber.contains(q))
          .toList();
    }
    final start = page * pageSize;
    if (start >= filtered.length) return [];
    final end =
        (start + pageSize) > filtered.length ? filtered.length : start + pageSize;
    return filtered.sublist(start, end);
  }

  Future<int> getTotalCount() async => _customers.length;

  Future<UserEntity> getCustomer(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _customers.firstWhere(
      (c) => c.id == id,
      orElse: () => throw const ServerException('Customer not found'),
    );
  }
}
