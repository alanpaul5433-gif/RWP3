part of 'support_bloc.dart';

sealed class SupportState extends Equatable {
  const SupportState();
  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState { const SupportInitial(); }
class SupportLoading extends SupportState { const SupportLoading(); }
class SupportCreating extends SupportState { const SupportCreating(); }

class SupportTicketsLoaded extends SupportState {
  final List<SupportTicketEntity> tickets;
  const SupportTicketsLoaded(this.tickets);
  @override
  List<Object?> get props => [tickets];
}

class SupportTicketCreated extends SupportState {
  final SupportTicketEntity ticket;
  const SupportTicketCreated(this.ticket);
  @override
  List<Object?> get props => [ticket];
}

class SupportTicketDetailLoaded extends SupportState {
  final SupportTicketEntity ticket;
  const SupportTicketDetailLoaded(this.ticket);
  @override
  List<Object?> get props => [ticket];
}

class SupportError extends SupportState {
  final String message;
  const SupportError(this.message);
  @override
  List<Object?> get props => [message];
}
