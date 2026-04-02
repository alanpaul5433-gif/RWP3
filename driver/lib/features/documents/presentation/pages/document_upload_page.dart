import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/documents_bloc.dart';

class DocumentUploadPage extends StatelessWidget {
  const DocumentUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: BlocConsumer<DocumentsBloc, DocumentsState>(
        listener: (context, state) {
          if (state is DocumentsLoaded && state.isFullyVerified) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All documents verified!')));
          }
        },
        builder: (context, state) {
          if (state is DocumentsLoading || state is DocumentUploading) return const Center(child: CircularProgressIndicator());
          final docs = state is DocumentsLoaded ? state.documents : <DriverDocument>[];
          final isVerified = state is DocumentsLoaded ? state.isFullyVerified : false;

          return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Status banner
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isVerified ? const Color(0xFF27C041).withValues(alpha: 0.1) : const Color(0xFFD19D00).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(isVerified ? Icons.verified : Icons.pending, color: isVerified ? const Color(0xFF27C041) : const Color(0xFFD19D00)),
                const SizedBox(width: 12),
                Text(isVerified ? 'All documents verified' : 'Documents pending verification',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: 24),

            Text('Required Documents', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            Expanded(child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: doc.isVerified ? const Color(0xFF27C041).withValues(alpha: 0.1) : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(doc.documentId == 'license' ? Icons.badge : Icons.credit_card,
                          color: doc.isVerified ? const Color(0xFF27C041) : colorScheme.outline),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(doc.documentId == 'license' ? 'Driver License' : 'ID Card',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text(doc.isVerified ? 'Verified' : doc.frontImage.isNotEmpty ? 'Uploaded - Pending' : 'Not uploaded',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: doc.isVerified ? const Color(0xFF27C041) : doc.frontImage.isNotEmpty ? const Color(0xFFD19D00) : colorScheme.outline)),
                    ])),
                    if (!doc.isVerified)
                      FilledButton.tonal(
                        onPressed: () {
                          // In production: use image_picker
                          context.read<DocumentsBloc>().add(DocumentUploadRequested(
                                driverId: 'mock_driver', documentId: doc.documentId,
                                frontImage: 'mock_front_url', backImage: 'mock_back_url'));
                        },
                        child: Text(doc.frontImage.isNotEmpty ? 'Re-upload' : 'Upload'),
                      ),
                    if (doc.isVerified) Icon(Icons.check_circle, color: const Color(0xFF27C041)),
                  ])),
                );
              },
            )),
          ]));
        },
      ),
    );
  }
}
