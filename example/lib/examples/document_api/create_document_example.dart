// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_note_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_square_annotation.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_checkbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_text_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:compdfkit_flutter/util/cpdf_widget_util.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_toolbar.dart';
import '../shared/log_info_page.dart';

/// Create Document Example
///
/// Demonstrates how to create a new PDF document without using
/// [CPDFReaderWidget] or opening an existing PDF file.
class CreateDocumentExample extends StatefulWidget {
  /// Constructor
  const CreateDocumentExample({super.key});

  @override
  State<CreateDocumentExample> createState() => _CreateDocumentExampleState();
}

class _CreateDocumentExampleState extends State<CreateDocumentExample> {
  final List<String> _logs = [];
  bool _isRunning = false;
  String? _savedPath;

  void _appendLog(String message) {
    if (!mounted) {
      return;
    }
    setState(() {
      _logs.add('$message\n');
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  Future<void> _createInsertSaveAndVerify() async {
    if (_isRunning) {
      return;
    }
    _clearLogs();
    setState(() {
      _isRunning = true;
      _savedPath = null;
    });

    CPDFDocument? document;
    CPDFDocument? verifyDocument;
    try {
      document = await CPDFDocument.createDocument();
      _appendLog('Create document success: ${document.isValid}');

      final initialPageCount = await document.getPageCount();
      _appendLog('Initial page count: $initialPageCount');

      final insertResult = await document.insertBlankPage(
        pageIndex: 0,
        pageSize: CPDFPageSize.a4,
      );
      _appendLog('Insert blank page result: $insertResult');

      final pageCount = await document.getPageCount();
      _appendLog('Page count after insert: $pageCount');

      final addAnnotationsResult = await document.addAnnotations(
        _buildAnnotations(),
      );
      _appendLog('Add annotations result: $addAnnotationsResult');

      final addWidgetsResult = await document.addWidgets(_buildWidgets());
      _appendLog('Add form widgets result: $addWidgetsResult');

      final tempDir = await ComPDFKit.getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savePath =
          '${tempDir.path}${Platform.pathSeparator}created_document_$timestamp.pdf';
      final saveResult = await document.saveAs(savePath);
      _appendLog('Save result: $saveResult');
      _appendLog('Save path: $savePath');

      final savedFile = File(savePath);
      final exists = await savedFile.exists();
      final length = exists ? await savedFile.length() : 0;
      _appendLog('Saved file exists: $exists');
      _appendLog('Saved file size: $length bytes');

      if (saveResult && exists) {
        setState(() {
          _savedPath = savePath;
        });
      }

      verifyDocument = await CPDFDocument.createInstance();
      final openResult = await verifyDocument.open(savePath);
      _appendLog('Reopen result: ${openResult.name}');

      if (openResult == CPDFDocumentError.success) {
        final reopenedPageCount = await verifyDocument.getPageCount();
        _appendLog('Reopened page count: $reopenedPageCount');
      }
    } catch (e) {
      _appendLog('Create document error: $e');
    } finally {
      await verifyDocument?.close();
      await document?.close();
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  List<CPDFAnnotation> _buildAnnotations() {
    return [
      CPDFSquareAnnotation(
        page: 0,
        title: 'Created Square',
        content: 'Created by CPDFDocument.createDocument()',
        rect: const CPDFRectF(left: 48, top: 180, right: 260, bottom: 96),
        borderWidth: 3,
        borderColor: Colors.deepOrange,
        fillColor: Colors.amber,
        fillAlpha: 90,
      ),
      CPDFNoteAnnotation(
        page: 0,
        title: 'Created Note',
        content: 'This note was inserted before saving the new document.',
        rect: const CPDFRectF(left: 300, top: 180, right: 340, bottom: 140),
        color: Colors.green,
      ),
    ];
  }

  List<CPDFWidget> _buildWidgets() {
    return [
      CPDFTextWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.textField),
        page: 0,
        rect: const CPDFRectF(left: 48, top: 330, right: 360, bottom: 260),
        borderColor: Colors.blue,
        fillColor: Colors.white,
        borderWidth: 2,
        text: 'Text field created by Flutter API',
        fontColor: Colors.black,
        fontSize: 18,
        alignment: CPDFAlignment.left,
        familyName: 'Helvetica',
        styleName: 'Regular',
      ),
      CPDFCheckBoxWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.checkBox),
        page: 0,
        rect: const CPDFRectF(left: 48, top: 430, right: 84, bottom: 394),
        borderColor: Colors.green,
        fillColor: Colors.white,
        borderWidth: 2,
        isChecked: true,
        checkStyle: CPDFCheckStyle.check,
        checkColor: Colors.green,
      ),
    ];
  }

  void _showSavedDocumentPath() {
    final savedPath = _savedPath;
    if (savedPath == null) {
      _appendLog('No saved document path. Create and save a document first.');
      return;
    }
    _appendLog('Current saved document path: $savedPath');
  }

  void _openSavedDocument() {
    final savedPath = _savedPath;
    if (savedPath == null) {
      _appendLog('No saved document path. Create and save a document first.');
      return;
    }
    _appendLog('Open saved document: $savedPath');
    ComPDFKit.openDocument(savedPath, configuration: CPDFConfiguration());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Create Document',
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
          TextButton(
            onPressed: _isRunning ? null : _createInsertSaveAndVerify,
            child: const Text('Create Content and Save'),
          ),
          TextButton(
            onPressed: _savedPath == null ? null : _showSavedDocumentPath,
            child: const Text('Get Document Path'),
          ),
          TextButton(
            onPressed: _savedPath == null ? null : _openSavedDocument,
            child: const Text('Open Saved Document'),
          ),
          if (_isRunning) const LinearProgressIndicator(),
          Expanded(child: LogInfoPage(logs: _logs)),
        ],
      ),
    );
  }
}
