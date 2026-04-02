import 'package:core/core.dart';

class MockDocumentsDataSource {
  final List<DriverDocument> _documents = [
    const DriverDocument(documentId: 'license', frontImage: '', backImage: '', isVerified: false),
    const DriverDocument(documentId: 'id_card', frontImage: '', backImage: '', isVerified: false),
  ];

  Future<List<DriverDocument>> getDocuments(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_documents);
  }

  Future<DriverDocument> uploadDocument({
    required String driverId,
    required String documentId,
    required String frontImage,
    required String backImage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _documents.indexWhere((d) => d.documentId == documentId);
    if (index == -1) throw const ServerException('Document type not found');

    final updated = DriverDocument(
      documentId: documentId,
      frontImage: frontImage,
      backImage: backImage,
      isVerified: false, // Pending admin verification
    );
    _documents[index] = updated;
    return updated;
  }

  Future<bool> isFullyVerified(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _documents.every((d) => d.isVerified);
  }
}
