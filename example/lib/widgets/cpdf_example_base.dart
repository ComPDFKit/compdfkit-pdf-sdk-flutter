/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
// base/cpdf_example_base.dart
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:flutter/material.dart';

abstract class CPDFExampleBase extends StatefulWidget {
  final String documentPath;
  final String? title;
  final String? password;

  const CPDFExampleBase({
    super.key,
    required this.documentPath,
    this.title,
    this.password
  });
}

abstract class CPDFExampleBaseState<T extends CPDFExampleBase> extends State<T> {
  CPDFReaderWidgetController? _controller;

  CPDFReaderWidgetController? get controller => _controller;

  String get pageTitle;
  CPDFConfiguration get configuration;
  List<Widget> Function(CPDFReaderWidgetController)? get appBarActions => null;
  List<String>? get menuActions => null;

  void onControllerCreated(CPDFReaderWidgetController controller) {}
  void onPageChanged(int pageIndex) => debugPrint('Page changed: $pageIndex');
  void onSaveCallback() => debugPrint('Save successful');
  void onFillScreenChanged(bool isFillScreen) => debugPrint('Full screen: $isFillScreen');
  void onTapMainDocArea() => debugPrint('Tap main doc area');
  void onIOSClickBackPressed() => Navigator.pop(context);

  void handleMenuAction(String action, CPDFReaderWidgetController controller) {}

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  Widget buildContent() {
    return CPDFReaderPage(
      title: widget.title ?? pageTitle,
      documentPath: widget.documentPath,
      configuration: configuration,
      password: widget.password ?? '',
      onCreated: (controller) {
        setState(() {
          _controller = controller;
        });
        onControllerCreated(controller);
      },
      onPageChanged: onPageChanged,
      onSaveCallback: onSaveCallback,
      onFillScreenChanged: onFillScreenChanged,
      onTapMainDocAreaCallback: onTapMainDocArea,
      onIOSClickBackPressed: onIOSClickBackPressed,
      appBarActions: _buildAppBarActions,
    );
  }

  List<Widget> _buildAppBarActions(CPDFReaderWidgetController controller) {
    final actions = <Widget>[];

    if (appBarActions != null) {
      actions.addAll(appBarActions!(controller));
    }

    if (menuActions != null && menuActions!.isNotEmpty) {
      actions.add(_buildPopupMenu(controller));
    }

    return actions;
  }

  Widget _buildPopupMenu(CPDFReaderWidgetController controller) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => handleMenuAction(value, controller),
      itemBuilder: (context) => menuActions!
          .map((action) => PopupMenuItem<String>(
        value: action,
        child: Text(action),
      ))
          .toList(),
    );
  }
}
