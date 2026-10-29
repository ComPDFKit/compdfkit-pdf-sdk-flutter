// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/document/cpdf_bates.dart';
import 'package:compdfkit_flutter/document/cpdf_header_footer.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Demonstrates Bates numbering CRUD in the Security examples.
class BatesExample extends StatelessWidget {
  const BatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Bates Numbering',
      assetPath: AppAssets.pdfDocument,
      builder: (path) => _BatesPage(documentPath: path),
    );
  }
}

class _BatesPage extends ExampleBase {
  const _BatesPage({required super.documentPath});

  @override
  State<_BatesPage> createState() => _BatesPageState();
}

class _BatesPageState extends ExampleBaseState<_BatesPage> {
  static const _actions = <String>[
    'Apply Bates',
    'Read Bates',
    'Update Bates',
    'Clear Bates',
  ];

  @override
  String get pageTitle => 'Bates Numbering';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
      );

  @override
  List<String> get menuActions => _actions;

  @override
  void handleMenuAction(
    String action,
    CPDFReaderWidgetController controller,
  ) {
    switch (action) {
      case 'Apply Bates':
        _update(controller, prefix: 'CASE-');
        break;
      case 'Read Bates':
        _read(controller);
        break;
      case 'Update Bates':
        _update(controller, prefix: 'UPDATED-');
        break;
      case 'Clear Bates':
        _clear(controller);
        break;
    }
  }

  Future<void> _update(
    CPDFReaderWidgetController controller, {
    required String prefix,
  }) async {
    final count = await controller.document.getPageCount();
    final list = List<int>.generate(count, (index) => index);
    debugPrint(list.toString());
    // TODO(Android): 修复添加 Bates 码时发生的原生崩溃问题（#31558）。
    // TODO(iOS): 修复添加或修改 Bates 码后第一页不刷新的问题（#31550）。
    final success = await controller.document.updateBates(
      CPDFBates(
        pages: List<int>.generate(count, (index) => index),
        margin: const EdgeInsets.fromLTRB(36, 24, 36, 24),
        pageOffset: 1,
        slots: <CPDFHeaderFooterSlot>[
          CPDFHeaderFooterSlot(
            position: CPDFHeaderFooterPosition.footerRight,
            text: '$prefix<<#5#1#>>',
            fontSize: 20,
            textColor: Colors.cyan,
          ),
        ],
      ),
    );
    _showMessage(success ? 'Bates updated' : 'Failed to update Bates');
  }

  Future<void> _read(CPDFReaderWidgetController controller) async {
    final value = await controller.document.getBates();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bates Numbering'),
        content: value == null
            ? const Text('No Bates numbering applied')
            : SingleChildScrollView(
                child: Text(
                  'Pages: ${value.pages.map((page) => page + 1).join(', ')}\n'
                  'Offset: ${value.pageOffset}\n'
                  'Rule: ${value.rule.name}\n'
                  'Slots:\n${value.slots.map((slot) => '${slot.position.name}: ${slot.text}').join('\n')}',
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _clear(CPDFReaderWidgetController controller) async {
    final success = await controller.document.clearBates();
    _showMessage(success ? 'Bates cleared' : 'Failed to clear Bates');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
