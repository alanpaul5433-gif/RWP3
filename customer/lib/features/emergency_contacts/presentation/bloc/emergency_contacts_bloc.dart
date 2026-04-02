import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_emergency_datasource.dart';

part 'emergency_contacts_event.dart';
part 'emergency_contacts_state.dart';

class EmergencyContactsBloc extends Bloc<EmergencyContactsEvent, EmergencyContactsState> {
  final MockEmergencyDataSource _dataSource;

  EmergencyContactsBloc({required MockEmergencyDataSource dataSource})
      : _dataSource = dataSource,
        super(const EmergencyContactsInitial()) {
    on<EmergencyContactsLoadRequested>(_onLoad);
    on<EmergencyContactAddRequested>(_onAdd);
    on<EmergencyContactDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(EmergencyContactsLoadRequested event, Emitter<EmergencyContactsState> emit) async {
    emit(const EmergencyContactsLoading());
    try {
      final contacts = await _dataSource.getContacts(event.userId);
      emit(EmergencyContactsLoaded(contacts));
    } catch (e) {
      emit(EmergencyContactsError(e.toString()));
    }
  }

  Future<void> _onAdd(EmergencyContactAddRequested event, Emitter<EmergencyContactsState> emit) async {
    try {
      await _dataSource.addContact(
        userId: event.userId, name: event.name, phoneNumber: event.phoneNumber,
      );
      add(EmergencyContactsLoadRequested(event.userId));
    } catch (e) {
      emit(EmergencyContactsError(e.toString()));
    }
  }

  Future<void> _onDelete(EmergencyContactDeleteRequested event, Emitter<EmergencyContactsState> emit) async {
    try {
      await _dataSource.deleteContact(event.contactId);
      add(EmergencyContactsLoadRequested(event.userId));
    } catch (e) {
      emit(EmergencyContactsError(e.toString()));
    }
  }
}
