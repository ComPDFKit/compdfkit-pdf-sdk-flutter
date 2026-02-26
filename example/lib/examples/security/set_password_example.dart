// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../../constants/asset_paths.dart';
import '../shared/example_document_loader.dart';

/// Set Document Password Example
///
/// Demonstrates how to protect a PDF document by setting open and owner
/// passwords with configurable encryption and permission settings.
///
/// This example shows:
/// - Setting user (open) password for document access control
/// - Setting owner password for permission management
/// - Configuring document permissions (printing, copying)
/// - Selecting encryption algorithm (AES-256)
///
/// Key classes/APIs used:
/// - [CPDFDocument.setPassword]: Sets encryption with user/owner passwords
/// - [CPDFDocumentEncryptAlgo]: Encryption algorithm options (RC4, AES-128, AES-256)
/// - [CPDFReaderWidgetController]: Provides access to the document instance
///
/// Usage:
/// 1. Open a PDF document in the reader
/// 2. Tap the menu and select "Set Password"
/// 3. Enter the desired password in the dialog
/// 4. The document will be encrypted with AES-256 and restricted permissions
class SetPasswordExample extends StatelessWidget {
  /// Constructor
  const SetPasswordExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Set Password',
      assetPath: _assetPath,
      builder: (path) => _SetPasswordPage(documentPath: path),
    );
  }
}

class _SetPasswordPage extends ExampleBase {
  const _SetPasswordPage({required super.documentPath});

  @override
  State<_SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends ExampleBaseState<_SetPasswordPage> {
  static const List<String> _menuActions = ['Set Password'];

  @override
  String get pageTitle => 'Set Password';

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
    if (action == 'Set Password') {
      _handleSetPassword(controller);
    }
  }

  Future<void> _handleSetPassword(CPDFReaderWidgetController controller) async {
    final password = await _showPasswordDialog();
    if (password == null || password.isEmpty) {
      debugPrint('Password not set');
      return;
    }

    final result = await controller.document.setPassword(
      userPassword: password,
      ownerPassword: password,
      allowsPrinting: false,
      allowsCopying: false,
      encryptAlgo: CPDFDocumentEncryptAlgo.aes256,
    );
    debugPrint(result ? 'Password set successfully' : 'Failed to set password');
  }

  Future<String?> _showPasswordDialog() {
    final controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        final textTheme = Theme.of(dialogContext).textTheme;
        return AlertDialog(
          title: const Text('Set Password'),
          content: TextField(
            controller: controller,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
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
              child: Text('Cancel', style: textTheme.labelLarge),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Confirm',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
