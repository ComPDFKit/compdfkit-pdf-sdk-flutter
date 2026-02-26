/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
// base/example_base.dart
import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:flutter/material.dart';

abstract class ExampleBase extends StatefulWidget {
  final String documentPath;
  final String? title;
  final String? password;

  const ExampleBase(
      {super.key, required this.documentPath, this.title, this.password});
}

abstract class ExampleBaseState<T extends ExampleBase> extends State<T> {
  CPDFReaderWidgetController? _controller;

  CPDFReaderWidgetController? get controller => _controller;

  String get pageTitle;

  CPDFConfiguration get configuration;

  List<Widget> Function(CPDFReaderWidgetController)? get appBarActions => null;

  List<String>? get menuActions => null;

  void onControllerCreated(CPDFReaderWidgetController controller) {}

  void onPageChanged(int pageIndex) => debugPrint('Page changed: $pageIndex');

  void onSaveCallback() => debugPrint('Save successful');

  void onFillScreenChanged(bool isFillScreen) =>
      debugPrint('Full screen: $isFillScreen');

  void onTapMainDocArea() => debugPrint('Tap main doc area');

  void onIOSClickBackPressed() => Navigator.pop(context);

  void handleMenuAction(String action, CPDFReaderWidgetController controller) {}

  void onCustomToolbarItemTapped(String identifier) {}

  void onEventsCallback(Object? data) {}

  void onAnnotationCreationPrepared(
      CPDFAnnotationType type, CPDFAnnotation? annotation) {}

  void onCustomContextMenuItemTapped(String identifier, dynamic event) {}

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
      onCustomToolbarItemTappedCallback: onCustomToolbarItemTapped,
      onAnnotationCreationPreparedCallback: onAnnotationCreationPrepared,
      onCustomContextMenuItemTappedCallback: onCustomContextMenuItemTapped,
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.black.withValues(alpha: 0.01),
          width: 0.5,
        ),
      ),
      offset: const Offset(0, 40),
      itemBuilder: (context) {
        return menuActions!
            .map((action) => PopupMenuItem<String>(
                  value: action,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    action,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ))
            .toList();
      },
    );
  }
}
