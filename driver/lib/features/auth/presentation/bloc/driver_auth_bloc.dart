import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/driver_auth_datasource.dart';

part 'driver_auth_event.dart';
part 'driver_auth_state.dart';

class DriverAuthBloc extends Bloc<DriverAuthEvent, DriverAuthState> {
  final DriverAuthDataSource _dataSource;

  DriverAuthBloc({required DriverAuthDataSource dataSource})
      : _dataSource = dataSource,
        super(const DriverAuthInitial()) {
    on<DriverAuthCheckRequested>(_onCheck);
    on<DriverEmailLoginRequested>(_onLogin);
    on<DriverEmailSignupRequested>(_onSignup);
    on<DriverPasswordResetRequested>(_onReset);
    on<DriverLogoutRequested>(_onLogout);
  }

  Future<void> _onCheck(DriverAuthCheckRequested event, Emitter<DriverAuthState> emit) async {
    emit(const DriverAuthLoading());
    try {
      final driver = await _dataSource.getCurrentDriver();
      driver != null ? emit(DriverAuthenticated(driver)) : emit(const DriverUnauthenticated());
    } catch (_) {
      emit(const DriverUnauthenticated());
    }
  }

  Future<void> _onLogin(DriverEmailLoginRequested event, Emitter<DriverAuthState> emit) async {
    emit(const DriverAuthLoading());
    try {
      final driver = await _dataSource.loginWithEmail(event.email, event.password);
      emit(DriverAuthenticated(driver));
    } on AuthException catch (e) {
      emit(DriverAuthError(mapFailureToMessage(AuthFailure(e.message))));
    } catch (e) {
      emit(DriverAuthError(e.toString()));
    }
  }

  Future<void> _onSignup(DriverEmailSignupRequested event, Emitter<DriverAuthState> emit) async {
    emit(const DriverAuthLoading());
    try {
      final driver = await _dataSource.signupWithEmail(
        email: event.email, password: event.password,
        fullName: event.fullName, gender: event.gender,
      );
      emit(DriverAuthenticated(driver));
    } on AuthException catch (e) {
      emit(DriverAuthError(mapFailureToMessage(AuthFailure(e.message))));
    } catch (e) {
      emit(DriverAuthError(e.toString()));
    }
  }

  Future<void> _onReset(DriverPasswordResetRequested event, Emitter<DriverAuthState> emit) async {
    emit(const DriverAuthLoading());
    try {
      await _dataSource.resetPassword(event.email);
      emit(const DriverPasswordResetSent());
    } catch (e) {
      emit(DriverAuthError(e.toString()));
    }
  }

  Future<void> _onLogout(DriverLogoutRequested event, Emitter<DriverAuthState> emit) async {
    await _dataSource.logout();
    emit(const DriverUnauthenticated());
  }
}
