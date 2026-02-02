// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/toolbar/cpdf_custom_toolbar_item.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:flutter/material.dart';

class CpdfToolbarCustomExample extends CPDFExampleBase {
  const CpdfToolbarCustomExample({super.key, required super.documentPath});

  @override
  State<CpdfToolbarCustomExample> createState() =>
      _CPDFToolbarCustomExampleState();
}

class _CPDFToolbarCustomExampleState
    extends CPDFExampleBaseState<CpdfToolbarCustomExample> {
  static const List<String> _menuActions = [];

  @override
  String get pageTitle => 'ToolBar Custom Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
          toolbarConfig: CPDFToolbarConfig(
        customToolbarLeftItems: [
          const CPDFCustomToolbarItem.action(
              action: CPDFToolbarAction.back),
          const CPDFCustomToolbarItem(
              action: CPDFToolbarAction.custom,
              identifier: 'custom_editor',
              title: 'Custom Enter Editor',
              icon: 'ic_test_edit'),
        ],
        customToolbarRightItems: [
          const CPDFCustomToolbarItem.action(
              icon: 'ic_test_book',
              action: CPDFToolbarAction.bota),
          const CPDFCustomToolbarItem(
              identifier: 'custom_text_search',
              title: 'Custom Text Search',
              icon: 'ic_test_search',
              action: CPDFToolbarAction.custom),
          const CPDFCustomToolbarItem.action(
              icon: 'ic_test_more',
              action: CPDFToolbarAction.menu),
        ],
        customMoreMenuItems: [
          const CPDFCustomToolbarItem.action(action: CPDFToolbarAction.viewSettings),
          const CPDFCustomToolbarItem(
              identifier: 'custom_share',
              title: 'Custom Share',
              icon: 'ic_test_share',
              action: CPDFToolbarAction.custom)
        ],
      ));

  @override
  List<String> get menuActions => _menuActions;

  @override
  void onCustomToolbarItemTapped(String identifier) async {
    debugPrint('ComPDFKit: onCustomToolbarItemTapped: $identifier');
    switch (identifier) {
      case 'custom_editor':
        final mode = await controller?.getPreviewMode();
        debugPrint('ComPDFKit: Current Preview Mode: $mode');
        await controller?.setPreviewMode(mode == CPDFViewMode.contentEditor
            ? CPDFViewMode.viewer
            : CPDFViewMode.contentEditor);
        break;
      case 'custom_text_search':
        await controller?.showTextSearchView();
        break;
      case 'custom_share':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Custom Share action tapped'),
          ),
        );
        break;
    }
  }

  @override
  Widget buildContent() {
    return Column(
      children: [
        Expanded(child: super.buildContent()),
      ],
    );
  }
}
