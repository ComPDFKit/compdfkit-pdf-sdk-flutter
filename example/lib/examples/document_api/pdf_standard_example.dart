// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../cpdf_reader_page.dart';
import '../shared/api_example_base.dart';

/// PDF Standard Example
///
/// Demonstrates how to read the PDF standard a document conforms to and how to
/// convert it into another standard (PDF/A, PDF/X, PDF/E, PDF/UA, PDF/VT).
///
/// This example shows:
/// - Reading the current standard via [CPDFDocument.getPdfStandardType]
/// - Converting to any of the 17 supported standards via
///   [CPDFDocument.convertToPdfStandard]
/// - Reopening the converted output to verify the resulting standard, both
///   head-less and inside a [CPDFReaderWidget] via "Open output"
/// - Surfacing the raw [CPDFPdfStandardException] code returned by the platform
///
/// The conversion is written to a new file and leaves the opened document
/// unchanged: Android converts in place and reloads the document from its
/// original source, iOS converts a copy. "Refresh" re-reads the standard of the
/// *opened* document, so after a conversion it still reports the original
/// standard — that is how this is verified.
///
/// Platform note: iOS cannot convert to `pdf` or `pdf_e_2`. Those entries are
/// marked in the list but stay selectable, so the `UNSUPPORTED_PDF_STANDARD`
/// error code is visible.
class PdfStandardExample extends ApiExampleBase {
  /// Constructor
  const PdfStandardExample({super.key});

  @override
  String get assetPath => AppAssets.pdfDocument;

  @override
  String get title => 'PDF Standard';

  @override
  State<PdfStandardExample> createState() => _PdfStandardExampleState();
}

class _PdfStandardExampleState extends ApiExampleBaseState<PdfStandardExample> {
  CPDFPdfStandardType _targetType = CPDFPdfStandardType.pdfA1b;
  bool _fontSubset = true;

  String _currentStandard = '-';
  String? _convertedPath;
  bool _busy = false;

  /// The actions touch the base class's `late document`, so they stay disabled
  /// until the sample document has actually been opened.
  bool get _canRun => !_busy && isDocumentReady;

  @override
  void onDocumentReady() {
    _refreshCurrentStandard();
  }

  @override
  List<Widget> buildExampleContent(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return [
      Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentStandardRow(colors),
            const SizedBox(height: 12),
            _buildTargetTypeField(colors),
            const SizedBox(height: 4),
            _buildFontSubsetRow(colors),
            const SizedBox(height: 10),
            _buildActionsRow(colors),
          ],
        ),
      ),
    ];
  }

  Widget _buildCurrentStandardRow(ColorScheme colors) {
    return Row(
      children: [
        Text(
          'Opened document',
          style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _currentStandard,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 28,
          child: TextButton.icon(
            onPressed: _canRun ? _refreshCurrentStandard : null,
            icon: const Icon(Icons.refresh, size: 15),
            label: const Text('Refresh', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetTypeField(ColorScheme colors) {
    return DropdownButtonFormField<CPDFPdfStandardType>(
      initialValue: _targetType,
      isDense: true,
      menuMaxHeight: 320,
      borderRadius: BorderRadius.circular(10),
      icon: Icon(Icons.expand_more, size: 18, color: colors.onSurfaceVariant),
      style: TextStyle(fontSize: 12, color: colors.onSurface),
      decoration: InputDecoration(
        labelText: 'Target standard',
        labelStyle: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
      items: CPDFPdfStandardType.values
          .map((type) => DropdownMenuItem<CPDFPdfStandardType>(
                value: type,
                child: Text(
                  _isUnsupportedOnPlatform(type)
                      ? '${type.value} (not supported on iOS)'
                      : type.value,
                  style: TextStyle(fontSize: 12, color: colors.onSurface),
                ),
              ))
          .toList(),
      onChanged: _canRun
          ? (value) {
              if (value != null) setState(() => _targetType = value);
            }
          : null,
    );
  }

  /// Conversion targets the iOS SDK rejects with `UNSUPPORTED_PDF_STANDARD`.
  bool _isUnsupportedOnPlatform(CPDFPdfStandardType type) {
    return Platform.isIOS &&
        (type == CPDFPdfStandardType.pdf || type == CPDFPdfStandardType.pdfE2);
  }

  Widget _buildFontSubsetRow(ColorScheme colors) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Save font subset',
            style: TextStyle(fontSize: 12, color: colors.onSurface),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: _fontSubset,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged:
                _canRun ? (value) => setState(() => _fontSubset = value) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsRow(ColorScheme colors) {
    final canOpenOutput = _canRun && _convertedPath != null;
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: _canRun ? _convert : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Convert', style: TextStyle(fontSize: 13)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: canOpenOutput ? _openConvertedDocument : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(
                color: canOpenOutput ? colors.primary : colors.outlineVariant,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Open output', style: TextStyle(fontSize: 13)),
          ),
        ),
      ],
    );
  }

  /// Reads the standard of the *opened* document, logs it under [label] and
  /// updates the card. Does not touch [_busy] so it can be reused inside
  /// [_convert].
  Future<void> _logOpenedStandard(String label) async {
    try {
      final type = await document.getPdfStandardType();
      if (mounted) setState(() => _currentStandard = type.value);
      applyLog('$label: ${type.value}');
    } on CPDFPdfStandardException catch (e) {
      if (mounted) setState(() => _currentStandard = 'unavailable');
      applyLog('$label failed: ${e.code} - ${e.message}');
    }
  }

  Future<void> _refreshCurrentStandard() async {
    setState(() => _busy = true);
    await _logOpenedStandard('getPdfStandardType()');
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _convert() async {
    setState(() {
      _busy = true;
      _convertedPath = null;
    });
    clearLogs();
    try {
      await _logOpenedStandard('Source standard');

      final directory = await ComPDFKit.getTemporaryDirectory();
      final outputPath = '${directory.path}/pdf_standard_${_targetType.value}'
          '.pdf';

      applyLog('convertToPdfStandard()');
      applyLog('  target: ${_targetType.value}');
      applyLog('  output: $outputPath');

      final success = await document.convertToPdfStandard(
        outputPath,
        _targetType,
        fontSubset: _fontSubset,
      );
      applyLog('  result: $success');

      if (success) {
        setState(() => _convertedPath = outputPath);
        await _inspectOutput(outputPath);
        // The opened document must still report the source standard after the
        // conversion, on Android after the native reload, on iOS because only
        // a copy was converted.
        await _logOpenedStandard('Source standard after conversion');
      }
    } on CPDFPdfStandardException catch (e) {
      applyLog('convertToPdfStandard() failed: ${e.code} - ${e.message}');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _inspectOutput(String outputPath) async {
    final output = await CPDFDocument.createInstance();
    try {
      final error = await output.open(outputPath);
      applyLog('Reopen output: ${error.name}');
      if (error != CPDFDocumentError.success) {
        return;
      }
      final type = await output.getPdfStandardType();
      applyLog('Output standard: ${type.value}');
    } on CPDFPdfStandardException catch (e) {
      applyLog('Output standard failed: ${e.code} - ${e.message}');
    } finally {
      await output.close();
    }
  }

  void _openConvertedDocument() {
    final path = _convertedPath;
    if (path == null) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (readerContext) => CPDFReaderPage(
          title: 'Converted document',
          documentPath: path,
          configuration: CPDFConfiguration(),
          onCreated: (controller) =>
              _reportOpenedStandard(readerContext, controller),
          onIOSClickBackPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  /// Reads the standard of the document the reader has just opened, so the
  /// converted file is verified through the widget path as well as through the
  /// head-less [CPDFDocument] used by [_inspectOutput].
  Future<void> _reportOpenedStandard(
    BuildContext readerContext,
    CPDFReaderWidgetController controller,
  ) async {
    String message;
    try {
      final type = await controller.document.getPdfStandardType();
      message = 'Opened document standard: ${type.value}';
    } on CPDFPdfStandardException catch (e) {
      message = 'getPdfStandardType() failed: ${e.code} - ${e.message}';
    }

    applyLog(message);
    if (!readerContext.mounted) {
      return;
    }
    ScaffoldMessenger.of(readerContext).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 13)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
