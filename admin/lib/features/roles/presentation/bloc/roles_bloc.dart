import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_roles_datasource.dart';

part 'roles_event.dart';
part 'roles_state.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final MockRolesDataSource _dataSource;

  RolesBloc({required MockRolesDataSource dataSource})
      : _dataSource = dataSource,
        super(const RolesInitial()) {
    on<RolesLoadRequested>(_onLoad);
    on<RoleCreateRequested>(_onCreate);
    on<RoleDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(RolesLoadRequested event, Emitter<RolesState> emit) async {
    emit(const RolesLoading());
    try {
      final roles = await _dataSource.getRoles();
      emit(RolesLoaded(roles));
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }

  Future<void> _onCreate(RoleCreateRequested event, Emitter<RolesState> emit) async {
    try {
      await _dataSource.createRole(event.role);
      add(const RolesLoadRequested());
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }

  Future<void> _onDelete(RoleDeleteRequested event, Emitter<RolesState> emit) async {
    try {
      await _dataSource.deleteRole(event.roleId);
      add(const RolesLoadRequested());
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }
}
