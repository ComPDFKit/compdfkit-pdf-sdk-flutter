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

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Editor History Example
///
/// Demonstrates how to implement undo/redo functionality for content editing operations.
///
/// This example shows:
/// - Listening to content editor history state changes
/// - Tracking undo/redo availability in real-time
/// - Performing undo and redo operations programmatically
/// - Building a responsive UI that reflects history state
///
/// Key classes/APIs used:
/// - [CPDFEditHistoryManager]: Manages undo/redo history for content edits
/// - [CPDFEditHistoryManager.setOnHistoryChangedListener]: Callback for history changes
/// - [CPDFEditHistoryManager.undo]: Reverts the last editing operation
/// - [CPDFEditHistoryManager.redo]: Reapplies a previously undone operation
///
/// Usage:
/// 1. Open the example to view the PDF in content editor mode
/// 2. Make content edits (text or image modifications)
/// 3. Use the Undo button to revert changes when available
/// 4. Use the Redo button to reapply undone changes when available
class EditorHistoryExample extends StatelessWidget {
  /// Constructor
  const EditorHistoryExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Editor History',
      assetPath: _assetPath,
      builder: (path) => _EditorHistoryPage(documentPath: path),
    );
  }
}

class _EditorHistoryPage extends ExampleBase {
  const _EditorHistoryPage({required super.documentPath});

  @override
  State<_EditorHistoryPage> createState() => _EditorHistoryPageState();
}

class _EditorHistoryPageState extends ExampleBaseState<_EditorHistoryPage> {
  bool _canUndo = false;
  bool _canRedo = false;

  @override
  String get pageTitle => 'Editor History';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(
          initialViewMode: CPDFViewMode.contentEditor,
          availableViewModes: [CPDFViewMode.viewer, CPDFViewMode.contentEditor],
        ),
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  void onControllerCreated(CPDFReaderWidgetController controller) {
    super.onControllerCreated(controller);
    _setupHistoryListener(controller);
  }

  void _setupHistoryListener(CPDFReaderWidgetController controller) {
    controller.editManager.historyManager.setOnHistoryChangedListener((
      pageIndex,
      canUndo,
      canRedo,
    ) {
      debugPrint(
        'History changed - Page: $pageIndex, CanUndo: $canUndo, CanRedo: $canRedo',
      );
      setState(() {
        _canUndo = canUndo;
        _canRedo = canRedo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: super.build(context)),
        _buildUndoRedoBar(context),
      ],
    );
  }

  Widget _buildUndoRedoBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(77),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            icon: Icons.undo,
            label: 'Undo',
            enabled: _canUndo,
            onPressed: _performUndo,
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            icon: Icons.redo,
            label: 'Redo',
            enabled: _canRedo,
            onPressed: _performRedo,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
  }) {
    return FilledButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor:
            enabled ? colorScheme.primary : colorScheme.surfaceContainerHighest,
        foregroundColor:
            enabled ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurfaceVariant.withAlpha(102),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _performUndo() async {
    if (controller == null) return;
    await controller!.editManager.historyManager.undo();
  }

  Future<void> _performRedo() async {
    if (controller == null) return;
    await controller!.editManager.historyManager.redo();
  }
}
