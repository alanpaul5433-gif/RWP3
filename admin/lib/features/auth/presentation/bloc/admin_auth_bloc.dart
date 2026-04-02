import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/repositories/admin_auth_repository.dart';

part 'admin_auth_event.dart';
part 'admin_auth_state.dart';

class AdminAuthBloc extends Bloc<AdminAuthEvent, AdminAuthState> {
  final AdminAuthRepository _repository;

  AdminAuthBloc({required AdminAuthRepository repository})
      : _repository = repository,
        super(const AdminAuthInitial()) {
    on<AdminAuthCheckRequested>(_onCheck);
    on<AdminLoginRequested>(_onLogin);
    on<AdminLogoutRequested>(_onLogout);
  }

  Future<void> _onCheck(
    AdminAuthCheckRequested event,
    Emitter<AdminAuthState> emit,
  ) async {
    emit(const AdminAuthLoading());
    final result = await _repository.getCurrentAdmin();
    result.fold(
      (_) => emit(const AdminUnauthenticated()),
      (admin) => admin != null
          ? emit(AdminAuthenticated(admin))
          : emit(const AdminUnauthenticated()),
    );
  }

  Future<void> _onLogin(
    AdminLoginRequested event,
    Emitter<AdminAuthState> emit,
  ) async {
    emit(const AdminAuthLoading());
    final result =
        await _repository.loginWithEmail(event.email, event.password);
    result.fold(
      (failure) => emit(AdminAuthError(mapFailureToMessage(failure))),
      (admin) => emit(AdminAuthenticated(admin)),
    );
  }

  Future<void> _onLogout(
    AdminLogoutRequested event,
    Emitter<AdminAuthState> emit,
  ) async {
    await _repository.logout();
    emit(const AdminUnauthenticated());
  }
}
