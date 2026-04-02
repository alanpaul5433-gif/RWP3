import 'package:core/core.dart';

class MockEmergencyDataSource {
  final List<EmergencyContactEntity> _contacts = [];

  Future<List<EmergencyContactEntity>> getContacts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_contacts);
  }

  Future<EmergencyContactEntity> addContact({
    required String userId,
    required String name,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final contact = EmergencyContactEntity(
      id: 'ec_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phoneNumber: phoneNumber,
    );
    _contacts.add(contact);
    return contact;
  }

  Future<void> deleteContact(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _contacts.removeWhere((c) => c.id == contactId);
  }
}
