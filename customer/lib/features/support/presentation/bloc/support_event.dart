part of 'support_bloc.dart';

sealed class SupportEvent extends Equatable {
  const SupportEvent();
  @override
  List<Object?> get props => [];
}

class SupportTicketsLoadRequested extends SupportEvent {
  final String userId;
  const SupportTicketsLoadRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class SupportTicketCreateRequested extends SupportEvent {
  final String userId;
  final String subject;
  final String description;
  final String reason;
  const SupportTicketCreateRequested({
    required this.userId, required this.subject,
    required this.description, required this.reason,
  });
  @override
  List<Object?> get props => [userId, subject, description];
}

class SupportTicketDetailRequested extends SupportEvent {
  final String ticketId;
  const SupportTicketDetailRequested(this.ticketId);
  @override
  List<Object?> get props => [ticketId];
}

class SupportTicketReplyRequested extends SupportEvent {
  final String ticketId;
  final String senderId;
  final String senderRole;
  final String message;
  const SupportTicketReplyRequested({
    required this.ticketId, required this.senderId,
    required this.senderRole, required this.message,
  });
  @override
  List<Object?> get props => [ticketId, senderId, message];
}
