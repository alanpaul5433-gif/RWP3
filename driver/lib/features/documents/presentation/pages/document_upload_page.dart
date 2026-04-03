import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../bloc/documents_bloc.dart';

class DocumentUploadPage extends StatelessWidget {
  const DocumentUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<DocumentsBloc, DocumentsState>(
          listener: (context, state) {
            if (state is DocumentsLoaded && state.isFullyVerified) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All documents verified!')));
            }
          },
          builder: (context, state) {
            if (state is DocumentsLoading || state is DocumentUploading) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = state is DocumentsLoaded ? state.documents : <DriverDocument>[];
            final isVerified = state is DocumentsLoaded ? state.isFullyVerified : false;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.arrow_back, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('RWP', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.primary, letterSpacing: 1)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Document\nCenter', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: 1.1)),
                        const SizedBox(height: 8),
                        Text(
                          'Verify your identity and vehicle credentials to get on the road.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quality Standards tip
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quality Standards', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.primary)),
                          const SizedBox(height: 4),
                          Text(
                            'Ensure all text is legible and edges are clearly visible. Use a neutral background with natural lighting.',
                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Document cards
                  ...docs.map((doc) => _DocumentCard(doc: doc)),

                  // Upload Insurance Policy
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8E5E0), style: BorderStyle.solid),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 32, color: colorScheme.primary),
                          const SizedBox(height: 8),
                          Text('Upload Insurance Policy', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            'PDF or image, max 10MB',
                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FilledButton(
                      onPressed: isVerified ? null : () {},
                      child: Text(isVerified ? 'All Verified' : 'Submit for Review'),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final DriverDocument doc;
  const _DocumentCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUploaded = doc.frontImage.isNotEmpty;
    final statusColor = doc.isVerified ? const Color(0xFF2E7D32) : isUploaded ? const Color(0xFFDAA520) : colorScheme.primary;
    final statusLabel = doc.isVerified ? 'VERIFIED' : isUploaded ? 'PENDING REVIEW' : 'ACTION REQUIRED';
    final docName = doc.documentId == 'license' ? "Driver's License" : 'ID Proof';
    final docIcon = doc.documentId == 'license' ? Icons.badge_outlined : Icons.credit_card_outlined;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Preview placeholder
            Container(
              width: 64, height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F2ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(docIcon, color: colorScheme.onSurface.withValues(alpha: 0.3)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(docName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor, letterSpacing: 0.3),
                    ),
                  ),
                ],
              ),
            ),
            if (doc.isVerified)
              const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 22)
            else
              GestureDetector(
                onTap: () {
                  context.read<DocumentsBloc>().add(DocumentUploadRequested(
                    driverId: 'mock_driver', documentId: doc.documentId,
                    frontImage: 'mock_front_url', backImage: 'mock_back_url',
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.upload_outlined, size: 18, color: colorScheme.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
