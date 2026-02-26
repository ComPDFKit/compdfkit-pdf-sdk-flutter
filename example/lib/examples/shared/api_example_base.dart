// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter_example/widgets/app_toolbar.dart';
import 'package:flutter/material.dart';

import '../../utils/file_util.dart';
import 'log_info_page.dart';

/// Base class for API examples
///
/// Provides common functionality for document loading, log management, etc.
abstract class ApiExampleBase extends StatefulWidget {
  const ApiExampleBase({super.key});

  /// PDF asset path (e.g., 'pdfs/PDF_Document.pdf')
  String get assetPath;

  /// Example title
  String get title;

  @override
  State<ApiExampleBase> createState() => ApiExampleBaseState();
}

/// State for API example base class
class ApiExampleBaseState<T extends ApiExampleBase> extends State<T> {
  /// Log list
  List<String> logs = [];

  /// PDF document instance
  late CPDFDocument document;

  @override
  void initState() {
    super.initState();
    openDocument();
  }

  /// Open document
  Future<void> openDocument() async {
    final file = await extractAsset(
      shouldOverwrite: true,
      widget.assetPath,
    );
    applyLog('filePath: ${file.path}');

    document = await CPDFDocument.createInstance();
    final error = await document.open(file.path);
    applyLog('Open result: ${error.name}');

    onDocumentReady();
  }

  /// Called when document is ready
  ///
  /// Subclasses can override this method to perform initialization logic
  void onDocumentReady() {}

  /// Add log
  void applyLog(String msg) {
    setState(() {
      logs.add('$msg\n');
    });
  }

  /// Clear logs
  void clearLogs() {
    setState(() {
      logs.clear();
    });
  }

  /// Build example content
  ///
  /// Subclasses should override this method to add buttons and other UI elements
  List<Widget> buildExampleContent(BuildContext context) => [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: widget.title,
            onBack: () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...buildExampleContent(context),
          Expanded(child: LogInfoPage(logs: logs)),
        ],
      ),
    );
  }
}
