part of 'documents_bloc.dart';

sealed class DocumentsState extends Equatable {
  const DocumentsState();
  @override
  List<Object?> get props => [];
}

class DocumentsInitial extends DocumentsState { const DocumentsInitial(); }
class DocumentsLoading extends DocumentsState { const DocumentsLoading(); }
class DocumentUploading extends DocumentsState { const DocumentUploading(); }

class DocumentsLoaded extends DocumentsState {
  final List<DriverDocument> documents;
  final bool isFullyVerified;
  const DocumentsLoaded({required this.documents, required this.isFullyVerified});
  @override
  List<Object?> get props => [documents, isFullyVerified];
}

class DocumentsError extends DocumentsState {
  final String message;
  const DocumentsError(this.message);
  @override
  List<Object?> get props => [message];
}
