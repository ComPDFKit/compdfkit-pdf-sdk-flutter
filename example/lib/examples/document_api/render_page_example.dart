// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:typed_data';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../shared/api_example_base.dart';

/// Render Page Example
///
/// Demonstrates how to render PDF pages to images using the [CPDFDocument] API.
///
/// This example shows:
/// - Rendering a PDF page to an image byte array
/// - Configuring render dimensions and scaling
/// - Including annotations and form fields in the rendered output
/// - Specifying image compression format (PNG/JPEG)
/// - Navigating through pages and rendering each one
///
/// Key classes/APIs used:
/// - [CPDFDocument.renderPage]: Renders a page to image bytes
/// - [CPDFDocument.getPageSize]: Gets page dimensions for scaling
/// - [CPDFDocument.getPageCount]: Gets total pages for navigation
/// - [CPDFPageCompression]: Enum for output format (PNG, JPEG)
///
/// Usage:
/// 1. Open a PDF document
/// 2. Get page dimensions with [getPageSize] for proper scaling
/// 3. Call [renderPage] with page index, dimensions, and options
/// 4. Set [drawAnnot] and [drawForm] to include overlays
/// 5. Display the returned [Uint8List] as an image
class RenderPageExample extends ApiExampleBase {
  /// Constructor
  const RenderPageExample({super.key});

  @override
  String get assetPath => AppAssets.pdfDocument;

  @override
  String get title => 'Render Page';

  @override
  State<RenderPageExample> createState() => _RenderPageExampleState();
}

class _RenderPageExampleState extends ApiExampleBaseState<RenderPageExample> {
  int _currentPageIndex = 0;
  int _pageCount = 0;
  Uint8List? _pageImage;
  bool _isRendering = false;

  @override
  void onDocumentReady() {
    _loadPageCount();
    _renderPage();
  }

  @override
  List<Widget> buildExampleContent(BuildContext context) {
    return [
      TextButton(
        onPressed: _isRendering ? null : _renderNextPage,
        child: const Text('Render Next Page'),
      ),
      if (_isRendering) const LinearProgressIndicator(),
      if (_pageImage != null)
        Padding(
          padding: const EdgeInsets.all(8),
          child: Image.memory(_pageImage!),
        ),
    ];
  }

  Future<void> _loadPageCount() async {
    _pageCount = await document.getPageCount();
  }

  Future<void> _renderNextPage() async {
    if (_pageCount == 0) {
      await _loadPageCount();
    }
    if (_pageCount == 0) {
      return;
    }
    _currentPageIndex = (_currentPageIndex + 1) % _pageCount;
    await _renderPage();
  }

  Future<void> _renderPage() async {
    setState(() {
      _isRendering = true;
    });
    try {
      final size = await document.getPageSize(_currentPageIndex);
      final width = (size.width * 2).toInt();
      final height = (size.height * 2).toInt();

      final imageData = await document.renderPage(
        pageIndex: _currentPageIndex,
        width: width,
        height: height,
        backgroundColor: Colors.white,
        drawAnnot: true,
        drawForm: true,
        compression: CPDFPageCompression.png,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _pageImage = imageData;
        _isRendering = false;
      });

      applyLog('Rendered page: ${_currentPageIndex + 1}/$_pageCount');
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isRendering = false;
      });
      applyLog('Render failed: $e');
    }
  }
}
