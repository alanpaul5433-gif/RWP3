part of 'emergency_contacts_bloc.dart';

sealed class EmergencyContactsState extends Equatable {
  const EmergencyContactsState();
  @override
  List<Object?> get props => [];
}

class EmergencyContactsInitial extends EmergencyContactsState { const EmergencyContactsInitial(); }
class EmergencyContactsLoading extends EmergencyContactsState { const EmergencyContactsLoading(); }

class EmergencyContactsLoaded extends EmergencyContactsState {
  final List<EmergencyContactEntity> contacts;
  const EmergencyContactsLoaded(this.contacts);
  @override
  List<Object?> get props => [contacts];
}

class EmergencyContactsError extends EmergencyContactsState {
  final String message;
  const EmergencyContactsError(this.message);
  @override
  List<Object?> get props => [message];
}
