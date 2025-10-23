/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter_example/cpdf_security_example.dart';
import 'package:compdfkit_flutter_example/examples/document/log_info_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

class CPDFDocumentOpenPDFExample extends StatefulWidget {
  const CPDFDocumentOpenPDFExample({super.key});

  @override
  State<CPDFDocumentOpenPDFExample> createState() =>
      _CPDFDocumentOpenPDFExampleState();
}

class _CPDFDocumentOpenPDFExampleState
    extends State<CPDFDocumentOpenPDFExample> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _logs = [];

  CPDFDocument? _document;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  /// Adds a log message to the UI
  void _addLog(String message) {
    setState(() {
      _logs.add('$message\n');
    });
  }

  /// Clears all log messages
  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  /// Handles the document open process including password input if needed
  Future<void> _onOpenDocumentPressed() async {
    _clearLogs();

    // Step 1: Extract PDF file from assets
    final File file = await extractAsset(
      context,
      shouldOverwrite: true,
      'pdfs/Password_compdfkit_Security_Sample_File.pdf',
    );
    final String filePath = file.path;
    _addLog('Selected file: $filePath');

    // Step 2: Create CPDFDocument instance
    _document = await CPDFDocument.createInstance();

    // Step 3: Try to open without password first
    CPDFDocumentError result = await _document!.open(filePath, password: '');
    _addLog('Initial open result: ${result.name}');

    String? password = '';

    // Step 4: If the document is password-protected, prompt user
    if (result == CPDFDocumentError.errorPassword) {
      _addLog('Document is password protected.');

      // Ask user to enter password
      password = await _promptPasswordInput();

      // If no password entered, abort
      if (password == null || password.isEmpty) {
        _addLog('No password provided. Aborting.');
        return;
      }

      _addLog('Retrying open with password: $password');

      // Try opening again with user-provided password
      result = await _document!.open(filePath, password: password);
      _addLog('Second open result: ${result.name}');
    }

    // Step 5: If opened successfully, navigate to reader screen
    if (result == CPDFDocumentError.success) {
      _addLog('Document opened successfully. Navigating to reader...');
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => CPDFSecurityExample(documentPath: filePath, password: password!)));
    } else {
      // Step 6: Opening failed
      _addLog('Failed to open document: ${result.name}');
    }
  }

  /// Shows an input dialog to let the user type in the PDF password
  Future<String?> _promptPasswordInput() async {
    _textEditingController.clear();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextField(
            controller: _textEditingController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'compdfkit',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, _textEditingController.text),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Builds the main UI for the demo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Encrypted PDF Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Open PDF button
          TextButton(
            onPressed: _onOpenDocumentPressed,
            child: const Text('Open Document'),
          ),

          // Password hint
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text('Password: compdfkit'),
          ),

          const SizedBox(height: 8),

          // Log output display
          Expanded(child: LogInfoPage(logs: _logs)),
        ],
      ),
    );
  }
}
