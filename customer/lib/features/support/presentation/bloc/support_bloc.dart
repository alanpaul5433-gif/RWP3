import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_support_datasource.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final MockSupportDataSource _dataSource;

  SupportBloc({required MockSupportDataSource dataSource})
      : _dataSource = dataSource,
        super(const SupportInitial()) {
    on<SupportTicketsLoadRequested>(_onLoad);
    on<SupportTicketCreateRequested>(_onCreate);
    on<SupportTicketDetailRequested>(_onDetail);
    on<SupportTicketReplyRequested>(_onReply);
  }

  Future<void> _onLoad(SupportTicketsLoadRequested event, Emitter<SupportState> emit) async {
    emit(const SupportLoading());
    try {
      final tickets = await _dataSource.getTickets(event.userId);
      emit(SupportTicketsLoaded(tickets));
    } catch (e) {
      emit(SupportError(e.toString()));
    }
  }

  Future<void> _onCreate(SupportTicketCreateRequested event, Emitter<SupportState> emit) async {
    emit(const SupportCreating());
    try {
      final ticket = await _dataSource.createTicket(
        userId: event.userId, subject: event.subject,
        description: event.description, reason: event.reason,
      );
      emit(SupportTicketCreated(ticket));
    } catch (e) {
      emit(SupportError(e.toString()));
    }
  }

  Future<void> _onDetail(SupportTicketDetailRequested event, Emitter<SupportState> emit) async {
    try {
      final ticket = await _dataSource.getTicket(event.ticketId);
      emit(SupportTicketDetailLoaded(ticket));
    } catch (e) {
      emit(SupportError(e.toString()));
    }
  }

  Future<void> _onReply(SupportTicketReplyRequested event, Emitter<SupportState> emit) async {
    try {
      final ticket = await _dataSource.addReply(
        ticketId: event.ticketId, senderId: event.senderId,
        senderRole: event.senderRole, message: event.message,
      );
      emit(SupportTicketDetailLoaded(ticket));
    } catch (e) {
      emit(SupportError(e.toString()));
    }
  }
}
