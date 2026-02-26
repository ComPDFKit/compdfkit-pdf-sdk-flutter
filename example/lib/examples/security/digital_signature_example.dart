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

/// Digital Signature Example
///
/// Demonstrates how to verify and manage digital signatures in PDF documents
/// for document authenticity and integrity validation.
///
/// This example shows:
/// - Verifying digital signature validity and certificate status
/// - Displaying signature verification status overlay
/// - Hiding the signature status view when not needed
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.verifyDigitalSignatureStatus]: Triggers
///   signature verification and displays the result overlay
/// - [CPDFReaderWidgetController.hideDigitalSignStatusView]: Hides the
///   signature verification status overlay
///
/// Usage:
/// 1. Open a PDF document containing digital signatures
/// 2. Tap the menu and select "Verify Digital Signature"
/// 3. The signature status overlay will appear showing validity
/// 4. Select "Hide Signature Status" to dismiss the overlay
class DigitalSignatureExample extends StatelessWidget {
  /// Constructor
  const DigitalSignatureExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Digital Signature',
      assetPath: _assetPath,
      builder: (path) => _DigitalSignaturePage(documentPath: path),
    );
  }
}

class _DigitalSignaturePage extends ExampleBase {
  const _DigitalSignaturePage({required super.documentPath});

  @override
  State<_DigitalSignaturePage> createState() => _DigitalSignaturePageState();
}

class _DigitalSignaturePageState
    extends ExampleBaseState<_DigitalSignaturePage> {
  static const List<String> _menuActions = [
    'Verify Digital Signature',
    'Hide Signature Status',
  ];

  @override
  String get pageTitle => 'Digital Signature';

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
    switch (action) {
      case 'Verify Digital Signature':
        controller.verifyDigitalSignatureStatus();
        break;
      case 'Hide Signature Status':
        controller.hideDigitalSignStatusView();
        break;
    }
  }
}
