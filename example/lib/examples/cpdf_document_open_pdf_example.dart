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
import 'package:compdfkit_flutter_example/examples.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

class CPDFDocumentOpenPDFExample extends StatefulWidget {
  const CPDFDocumentOpenPDFExample({super.key});

  @override
  State<CPDFDocumentOpenPDFExample> createState() =>
      _CPDFDocumentExampleState();
}

class _CPDFDocumentExampleState extends State<CPDFDocumentOpenPDFExample> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> logs = List.empty(growable: true);
  late CPDFDocument document;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Encrypt PDF Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () async {
                clearLogs();
                File encryptPDF = await extractAsset(
                    context,
                    shouldOverwrite: true,
                    'pdfs/Password_compdfkit_Security_Sample_File.pdf');

                applyLog('filePath:${encryptPDF.path}\n');
                document = await CPDFDocument.createInstance();
                var error = await document.open(encryptPDF.path, password: '');

                applyLog('open result:${error.name}\n');
                String? password = '';
                if (error == CPDFDocumentError.errorPassword) {
                  applyLog('show input password dialog\n');
                  password = await _showInputPasswordDialog();
                  if (password == null) {
                    applyLog('input password is empty;\n');
                    return;
                  }
                  applyLog('password:$password\n');
                  error = await document.open(encryptPDF.path, password: password);
                }
                applyLog('open result:$error\n');
                if (error == CPDFDocumentError.success) {
                  applyLog('go to CPDFReaderWidgetSecurityExample\n');
                  if (context.mounted) {
                    goTo(
                        CPDFSecurityExample(
                            documentPath: encryptPDF.path, password: password),
                        context);
                  }
                }
              },
              child: const Text('Open Document')),
          const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text('Password: compdfkit')),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Text(
              logs.join(),
              style: const TextStyle(fontSize: 12),
            ),
          ))
        ],
      ),
    );
  }

  Future<String?> _showInputPasswordDialog() async {
    _textEditingController.clear();
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Input Password'),
            content: TextField(
              controller: _textEditingController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                  hintText: 'compdfkit',
                  hintStyle: TextStyle(color: Colors.black12)),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, _textEditingController.text);
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  void applyLog(String msg) {
    setState(() {
      logs.add(msg);
    });
  }

  void clearLogs() {
    setState(() {
      logs.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
