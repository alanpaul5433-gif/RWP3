import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_documents_datasource.dart';

part 'documents_event.dart';
part 'documents_state.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  final MockDocumentsDataSource _dataSource;

  DocumentsBloc({required MockDocumentsDataSource dataSource})
      : _dataSource = dataSource,
        super(const DocumentsInitial()) {
    on<DocumentsLoadRequested>(_onLoad);
    on<DocumentUploadRequested>(_onUpload);
  }

  Future<void> _onLoad(DocumentsLoadRequested event, Emitter<DocumentsState> emit) async {
    emit(const DocumentsLoading());
    try {
      final docs = await _dataSource.getDocuments(event.driverId);
      final verified = await _dataSource.isFullyVerified(event.driverId);
      emit(DocumentsLoaded(documents: docs, isFullyVerified: verified));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onUpload(DocumentUploadRequested event, Emitter<DocumentsState> emit) async {
    emit(const DocumentUploading());
    try {
      await _dataSource.uploadDocument(
        driverId: event.driverId, documentId: event.documentId,
        frontImage: event.frontImage, backImage: event.backImage,
      );
      add(DocumentsLoadRequested(event.driverId));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
}
