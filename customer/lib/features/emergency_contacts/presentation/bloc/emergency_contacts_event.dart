part of 'emergency_contacts_bloc.dart';

sealed class EmergencyContactsEvent extends Equatable {
  const EmergencyContactsEvent();
  @override
  List<Object?> get props => [];
}

class EmergencyContactsLoadRequested extends EmergencyContactsEvent {
  final String userId;
  const EmergencyContactsLoadRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class EmergencyContactAddRequested extends EmergencyContactsEvent {
  final String userId;
  final String name;
  final String phoneNumber;
  const EmergencyContactAddRequested({required this.userId, required this.name, required this.phoneNumber});
  @override
  List<Object?> get props => [userId, name, phoneNumber];
}

class EmergencyContactDeleteRequested extends EmergencyContactsEvent {
  final String contactId;
  final String userId;
  const EmergencyContactDeleteRequested({required this.contactId, required this.userId});
  @override
  List<Object?> get props => [contactId, userId];
}
