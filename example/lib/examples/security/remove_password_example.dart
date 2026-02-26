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

/// Remove Document Password Example
///
/// Demonstrates how to remove password protection from a previously encrypted
/// PDF document, making it freely accessible without authentication.
///
/// This example shows:
/// - Removing password protection from encrypted documents
/// - Handling the password removal result with user feedback
/// - Using async operations with proper mounted checks
///
/// Key classes/APIs used:
/// - [CPDFDocument.removePassword]: Removes all password protection
/// - [CPDFReaderWidgetController]: Provides access to the document instance
/// - [ScaffoldMessenger]: Displays operation result feedback
///
/// Usage:
/// 1. Open a password-protected PDF document
/// 2. Tap the menu and select "Remove Password"
/// 3. The password protection will be removed from the document
/// 4. A snackbar will confirm success or failure
class RemovePasswordExample extends StatelessWidget {
  /// Constructor
  const RemovePasswordExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Remove Password',
      assetPath: _assetPath,
      builder: (path) => _RemovePasswordPage(documentPath: path),
    );
  }
}

class _RemovePasswordPage extends ExampleBase {
  const _RemovePasswordPage({required super.documentPath});

  @override
  State<_RemovePasswordPage> createState() => _RemovePasswordPageState();
}

class _RemovePasswordPageState extends ExampleBaseState<_RemovePasswordPage> {
  static const List<String> _menuActions = ['Remove Password'];

  @override
  String get pageTitle => 'Remove Password';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        )
      );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    if (action == 'Remove Password') {
      _handleRemovePassword(controller);
    }
  }

  Future<void> _handleRemovePassword(
    CPDFReaderWidgetController controller,
  ) async {
    final result = await controller.document.removePassword();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result
              ? 'Password removed successfully'
              : 'Failed to remove password',
        ),
      ),
    );
  }
}
