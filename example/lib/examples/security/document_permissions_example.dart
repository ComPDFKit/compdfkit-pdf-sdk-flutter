// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../../constants/asset_paths.dart';
import '../shared/example_document_loader.dart';

/// Document Permissions Example
///
/// Demonstrates how to inspect and display the security permissions and
/// encryption status of a PDF document.
///
/// This example shows:
/// - Checking if a document is encrypted
/// - Verifying owner password unlock status
/// - Retrieving document permission flags
/// - Identifying the encryption algorithm used
/// - Displaying security information in a dialog
///
/// Key classes/APIs used:
/// - [CPDFDocument.isEncrypted]: Checks document encryption status
/// - [CPDFDocument.checkOwnerUnlocked]: Verifies owner-level access
/// - [CPDFDocument.getPermissions]: Retrieves permission bit flags
/// - [CPDFDocument.getEncryptAlgo]: Gets the encryption algorithm type
/// - [CPDFDocument.getFileName]: Retrieves the document file name
///
/// Usage:
/// 1. Open a PDF document (encrypted or unencrypted)
/// 2. Tap the menu and select "View Permissions Info"
/// 3. A dialog will display the document's security properties
/// 4. Review encryption status, permissions, and algorithm details
class DocumentPermissionsExample extends StatelessWidget {
  /// Constructor
  const DocumentPermissionsExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Document Permissions',
      assetPath: _assetPath,
      builder: (path) => _DocumentPermissionsPage(documentPath: path),
    );
  }
}

class _DocumentPermissionsPage extends ExampleBase {
  const _DocumentPermissionsPage({required super.documentPath});

  @override
  State<_DocumentPermissionsPage> createState() =>
      _DocumentPermissionsPageState();
}

class _DocumentPermissionsPageState
    extends ExampleBaseState<_DocumentPermissionsPage> {
  static const List<String> _menuActions = ['View Permissions Info'];

  @override
  String get pageTitle => 'Document Permissions';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    if (action == 'View Permissions Info') {
      _handleDocumentInfo(controller);
    }
  }

  Future<void> _handleDocumentInfo(
    CPDFReaderWidgetController controller,
  ) async {
    final document = controller.document;
    final fileName = await document.getFileName();
    final ownerUnlocked = await document.checkOwnerUnlocked();
    final isEncrypted = await document.isEncrypted();
    final permissions = await document.getPermissions();
    final encryptAlgo = await document.getEncryptAlgo();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        final textTheme = Theme.of(dialogContext).textTheme;
        return AlertDialog(
          title: const Text('Document Permissions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('File Name', fileName, textTheme),
              _buildInfoRow(
                'Owner Unlocked',
                ownerUnlocked.toString(),
                textTheme,
              ),
              _buildInfoRow('Is Encrypted', isEncrypted.toString(), textTheme),
              _buildInfoRow('Permissions', permissions.toString(), textTheme),
              _buildInfoRow('Encrypt Algorithm', encryptAlgo.name, textTheme),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text('Close', style: textTheme.labelLarge),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
