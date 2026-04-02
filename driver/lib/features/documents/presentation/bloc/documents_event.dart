part of 'documents_bloc.dart';

sealed class DocumentsEvent extends Equatable {
  const DocumentsEvent();
  @override
  List<Object?> get props => [];
}

class DocumentsLoadRequested extends DocumentsEvent {
  final String driverId;
  const DocumentsLoadRequested(this.driverId);
  @override
  List<Object?> get props => [driverId];
}

class DocumentUploadRequested extends DocumentsEvent {
  final String driverId;
  final String documentId;
  final String frontImage;
  final String backImage;
  const DocumentUploadRequested({required this.driverId, required this.documentId, required this.frontImage, required this.backImage});
  @override
  List<Object?> get props => [driverId, documentId];
}
