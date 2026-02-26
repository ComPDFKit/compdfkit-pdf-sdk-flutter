// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_link_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_note_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_goto_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/constants/asset_paths.dart';
import 'package:compdfkit_flutter_example/utils/preferences_service.dart';
import 'package:compdfkit_flutter_example/widgets/app_toolbar.dart';
import 'package:compdfkit_flutter_example/widgets/dialogs/link_action_dialog.dart';
import 'package:compdfkit_flutter_example/widgets/dialogs/note_dialog.dart';
import 'package:flutter/material.dart';

import '../shared/example_document_loader.dart';

/// Intercept Annotation Action Example
///
/// Demonstrates how to intercept link and note annotation actions in Flutter.
///
/// This example shows:
/// - Configuring [CPDFAnnotationsConfig.interceptLinkAction] to intercept link taps
/// - Configuring [CPDFAnnotationsConfig.interceptNoteAction] to intercept note taps
/// - Handling intercepted events via [CPDFReaderWidget.onInterceptAnnotationActionCallback]
///
/// Key classes/APIs used:
/// - [CPDFAnnotationsConfig]: Configuration for annotation interception
/// - [CPDFOnInterceptAnnotationActionCallback]: Callback for annotation actions
/// - [CPDFLinkAnnotation]: Link annotation with URI or GoTo action
/// - [CPDFNoteAnnotation]: Note annotation with content
///
/// Usage:
/// 1. Open the example
/// 2. Tap on a link annotation to see the intercepted URI or page destination
/// 3. Tap on a note annotation to see the intercepted content
class InterceptAnnotationActionExample extends StatelessWidget {
  const InterceptAnnotationActionExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Intercept Action',
      assetPath: _assetPath,
      builder: (path) => _InterceptAnnotationActionPage(documentPath: path),
    );
  }
}

class _InterceptAnnotationActionPage extends StatefulWidget {
  final String documentPath;

  const _InterceptAnnotationActionPage({required this.documentPath});

  @override
  State<_InterceptAnnotationActionPage> createState() =>
      _InterceptAnnotationActionPageState();
}

class _InterceptAnnotationActionPageState
    extends State<_InterceptAnnotationActionPage> {
  CPDFReaderWidgetController? _controller;

  CPDFConfiguration get _configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(
          initialViewMode: CPDFViewMode.viewer,
        ),
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
          // Enable interception of link annotation tap actions
          interceptLinkAction: true,
          // Enable interception of note annotation tap actions
          interceptNoteAction: true,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Intercept Action',
            onBack: () async {
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        child: CPDFReaderWidget(
          document: widget.documentPath,
          configuration: _configuration,
          onCreated: (controller) {
            _controller = controller;
          },
          // ==================== Annotation Action Interception ====================
          // This callback handles intercepted annotation actions (link and note)
          // When interceptLinkAction or interceptNoteAction is true in config,
          // tapping these annotations will trigger this callback instead of
          // the default native behavior.
          onInterceptAnnotationActionCallback: _handleAnnotationAction,
        ),
      ),
    );
  }

  /// Handle intercepted annotation actions.
  ///
  /// This method is called when:
  /// - A link annotation is tapped (when interceptLinkAction is true)
  /// - A note annotation is tapped (when interceptNoteAction is true)
  void _handleAnnotationAction(CPDFAnnotation annotation) {
    final type = annotation.type;

    switch (type) {
      case CPDFAnnotationType.link:
        final linkAnnotation = annotation as CPDFLinkAnnotation;
        _showLinkDialog(linkAnnotation);
        break;

      case CPDFAnnotationType.note:
        final noteAnnotation = annotation as CPDFNoteAnnotation;
        final content = noteAnnotation.content;
        _showNoteDialog(content);
        break;
      default:
        break;
    }
  }

  /// Show a link action dialog with different content based on action type.
  void _showLinkDialog(CPDFLinkAnnotation linkAnnotation) {
    final action = linkAnnotation.action;

    if (action is CPDFUriAction) {
      final uri = action.uri;
      if (uri.startsWith('mailto:')) {
        LinkActionDialog.showEmailLink(context: context, email: uri);
      } else {
        LinkActionDialog.showWebLink(context: context, url: uri);
      }
    } else if (action is CPDFGoToAction) {
      LinkActionDialog.showPageLink(
        context: context,
        pageIndex: action.pageIndex,
        onJump: () {
          _controller?.setDisplayPageIndex(pageIndex: action.pageIndex);
        },
      );
    } else {
      LinkActionDialog.showUnknown(
        context: context,
        message: action != null ? 'Unknown action type' : null,
      );
    }
  }

  /// Show a sticky note style dialog with the note content.
  void _showNoteDialog(String content) {
    NoteDialog.show(context: context, content: content);
  }
}
