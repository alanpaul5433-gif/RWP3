import 'package:core/core.dart';

class MockSupportDataSource {
  final List<SupportTicketEntity> _tickets = [];

  Future<SupportTicketEntity> createTicket({
    required String userId,
    required String subject,
    required String description,
    required String reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    final ticket = SupportTicketEntity(
      id: 'tk_${now.millisecondsSinceEpoch}',
      userId: userId,
      subject: subject,
      description: description,
      reason: reason,
      status: AppConstants.ticketPending,
      createdAt: now,
      updatedAt: now,
    );
    _tickets.add(ticket);
    return ticket;
  }

  Future<List<SupportTicketEntity>> getTickets(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _tickets.where((t) => t.userId == userId).toList();
  }

  Future<SupportTicketEntity> getTicket(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets.firstWhere(
      (t) => t.id == ticketId,
      orElse: () => throw const ServerException('Ticket not found'),
    );
  }

  Future<SupportTicketEntity> addReply({
    required String ticketId,
    required String senderId,
    required String senderRole,
    required String message,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index == -1) throw const ServerException('Ticket not found');

    final existing = _tickets[index];
    final newMessage = SupportMessageEntity(
      senderId: senderId,
      senderRole: senderRole,
      message: message,
      timestamp: DateTime.now(),
    );
    final updated = SupportTicketEntity(
      id: existing.id,
      userId: existing.userId,
      subject: existing.subject,
      description: existing.description,
      status: AppConstants.ticketActive,
      reason: existing.reason,
      messages: [...existing.messages, newMessage],
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    _tickets[index] = updated;
    return updated;
  }
}
