// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/toolbar/cpdf_custom_toolbar_item.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Toolbar Customization Example
///
/// Demonstrates how to customize the PDF reader toolbar by adding, removing,
/// and replacing toolbar items with custom actions.
///
/// This example shows:
/// - Adding custom items to the left toolbar (back button, custom editor toggle)
/// - Adding custom items to the right toolbar (bookmarks, search, menu)
/// - Customizing the "more" menu with additional actions
/// - Handling custom toolbar item tap events
/// - Using custom icons for toolbar buttons
///
/// Key classes/APIs used:
/// - [CPDFToolbarConfig]: Configures toolbar layout and items
/// - [CPDFCustomToolbarItem]: Defines individual toolbar items with actions
/// - [CPDFToolbarAction]: Predefined toolbar actions (back, bota, menu, custom)
/// - [onCustomToolbarItemTapped]: Callback for handling custom item taps
///
/// Usage:
/// 1. Create [CPDFCustomToolbarItem] instances for left/right toolbar positions
/// 2. Use [CPDFToolbarAction.custom] with a unique identifier for custom actions
/// 3. Override [onCustomToolbarItemTapped] to handle custom action events
/// 4. Use the controller to perform actions (e.g., toggle editor mode, show search)
class ToolbarCustomizationExample extends StatelessWidget {
  /// Constructor
  const ToolbarCustomizationExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Toolbar Customization',
      assetPath: _assetPath,
      builder: (path) => _ToolbarCustomizationPage(documentPath: path),
    );
  }
}

class _ToolbarCustomizationPage extends ExampleBase {
  const _ToolbarCustomizationPage({required super.documentPath});

  @override
  State<_ToolbarCustomizationPage> createState() =>
      _ToolbarCustomizationPageState();
}

class _ToolbarCustomizationPageState
    extends ExampleBaseState<_ToolbarCustomizationPage> {
  @override
  String get pageTitle => 'Toolbar Customization';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
        toolbarConfig: CPDFToolbarConfig(
          customToolbarLeftItems: [
            const CPDFCustomToolbarItem.action(action: CPDFToolbarAction.back),
            const CPDFCustomToolbarItem(
              action: CPDFToolbarAction.custom,
              identifier: 'custom_editor',
              title: 'Custom Enter Editor',
              icon: 'ic_test_edit',
            ),
          ],
          customToolbarRightItems: [
            const CPDFCustomToolbarItem.action(
              icon: 'ic_test_book',
              action: CPDFToolbarAction.bota,
            ),
            const CPDFCustomToolbarItem(
              identifier: 'custom_text_search',
              title: 'Custom Text Search',
              icon: 'ic_test_search',
              action: CPDFToolbarAction.custom,
            ),
            const CPDFCustomToolbarItem.action(
              icon: 'ic_test_more',
              action: CPDFToolbarAction.menu,
            ),
          ],
          customMoreMenuItems: [
            const CPDFCustomToolbarItem.action(
              action: CPDFToolbarAction.viewSettings,
            ),
            const CPDFCustomToolbarItem(
              identifier: 'custom_share',
              title: 'Custom Share',
              icon: 'ic_test_share',
              action: CPDFToolbarAction.custom,
            ),
          ],
        ),
      );

  @override
  void onCustomToolbarItemTapped(String identifier) async {
    switch (identifier) {
      case 'custom_editor':
        final mode = await controller?.getPreviewMode();
        await controller?.setPreviewMode(
          mode == CPDFViewMode.contentEditor
              ? CPDFViewMode.viewer
              : CPDFViewMode.contentEditor,
        );
        break;
      case 'custom_text_search':
        await controller?.showTextSearchView();
        break;
      case 'custom_share':
        if (!mounted) {
          return;
        }
        final path = await controller?.document.getDocumentPath();
        if (path != null && path.isNotEmpty) {
          await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
        }
        break;
    }
  }
}
