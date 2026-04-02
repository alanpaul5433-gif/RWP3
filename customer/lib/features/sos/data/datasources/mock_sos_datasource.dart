import 'package:core/core.dart';

class MockSosDataSource {
  final List<SosAlertEntity> _alerts = [];

  Future<SosAlertEntity> triggerSos({
    required String userId,
    required String bookingId,
    required LocationLatLng location,
    required String contactNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final alert = SosAlertEntity(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      bookingId: bookingId,
      location: location,
      contactNumber: contactNumber,
      createdAt: DateTime.now(),
    );
    _alerts.add(alert);
    return alert;
  }

  Future<List<SosAlertEntity>> getAlerts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _alerts.where((a) => a.userId == userId).toList();
  }
}
