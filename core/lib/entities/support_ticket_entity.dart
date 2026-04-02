import 'package:equatable/equatable.dart';

class SupportTicketEntity extends Equatable {
  final String id;
  final String userId;
  final String subject;
  final String description;
  final String status; // pending, active, complete
  final String reason;
  final List<SupportMessageEntity> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupportTicketEntity({
    required this.id,
    required this.userId,
    required this.subject,
    required this.description,
    this.status = 'pending',
    this.reason = '',
    this.messages = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, status];
}

class SupportMessageEntity extends Equatable {
  final String senderId;
  final String senderRole; // customer, admin
  final String message;
  final DateTime timestamp;

  const SupportMessageEntity({
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [senderId, message, timestamp];
}
