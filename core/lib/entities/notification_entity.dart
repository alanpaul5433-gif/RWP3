import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type; // cab, intercity, parcel, rental, chat, support
  final String? userId;
  final String? bookingId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.type = '',
    this.userId,
    this.bookingId,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, isRead];
}
