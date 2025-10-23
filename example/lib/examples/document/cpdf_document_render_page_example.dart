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
import 'dart:typed_data';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

class CPDFDocumentRenderPageExample extends StatefulWidget {
  const CPDFDocumentRenderPageExample({super.key});

  @override
  State<CPDFDocumentRenderPageExample> createState() =>
      _CPDFDocumentRenderPageExampleState();
}

class _CPDFDocumentRenderPageExampleState
    extends State<CPDFDocumentRenderPageExample> {
  final List<String> logs = [];
  CPDFDocument? document;
  int currentPageIndex = 0;
  int pageCount = 0;

  @override
  void initState() {
    super.initState();
    openDocument();
  }

  Future<void> openDocument() async {
    File pdfFile = await extractAsset(
        context, shouldOverwrite: true, 'pdfs/PDF_Document.pdf');
    applyLog('filePath: ${pdfFile.path}');

    final doc = await CPDFDocument.createInstance();
    final error = await doc.open(pdfFile.path);
    applyLog('open result: ${error.name}');

    final count = await doc.getPageCount();

    setState(() {
      document = doc;
      pageCount = count;
    });
  }

  void _renderNextPage() {
    if (document == null) return;

    setState(() {
      currentPageIndex = (currentPageIndex + 1) % pageCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final doc = document;
    return Scaffold(
      backgroundColor: const Color(0xFFefefef),
      appBar: AppBar(
        title: const Text('RenderPage Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: _renderNextPage,
            child: const Text('Render Next Page'),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: doc == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<Uint8List>(
                      future: renderPage(currentPageIndex),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Image.memory(snapshot.data!);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> renderPage(int pageIndex) async {
    Size size = await document!.getPageSize(pageIndex);
    int width = size.width.toInt() * 3;
    int height = size.height.toInt() * 3;
    return document!.renderPage(
        pageIndex: currentPageIndex,
        width: width,
        height: height,
        backgroundColor: Colors.white,
        drawAnnot: true,
        drawForm: true,
      compression: CPDFPageCompression.png);
  }

  void applyLog(String msg) {
    logs.add(msg);
    debugPrint(msg);
  }
}
