// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/asset_paths.dart';
import '../../cpdf_reader_page.dart';
import '../shared/api_example_base.dart';

/// Optimize Document Example
///
/// Demonstrates the document optimization, i.e. compression, pipeline.
///
/// This example shows:
/// - Reading the options the document currently holds via
///   [CPDFDocument.getOptimizeOptions]
/// - Writing an optimized copy via [CPDFDocument.optimizeToFile], including
///   live page progress and the resulting file size reduction
/// - Stopping a run with [CPDFDocument.cancelOptimize], which resolves the
///   pending call with [CPDFOptimizeResult.cancelled] rather than throwing
/// - Surfacing the raw [CPDFOptimizeException] code returned by the platform
///
/// The default flag set is lossy: it removes every bookmark and every
/// JavaScript action. The switches below make that visible and adjustable.
///
/// After every run the document is reopened from its source file, so unsaved
/// changes are discarded. Save before optimizing when they must be kept.
class OptimizeDocumentExample extends ApiExampleBase {
  /// Constructor
  const OptimizeDocumentExample({super.key});

  @override
  String get assetPath => AppAssets.pdfDocument;

  @override
  String get title => 'Optimize Document';

  @override
  State<OptimizeDocumentExample> createState() =>
      _OptimizeDocumentExampleState();
}

/// The flags the example exposes as switches. The remaining flags stay at
/// whatever [CPDFOptimizeFlag.defaults] holds.
const List<(CPDFOptimizeFlag, String)> _toggleableFlags = [
  (CPDFOptimizeFlag.compressImages, 'Compress images'),
  (CPDFOptimizeFlag.removeBookmarks, 'Remove bookmarks (lossy)'),
  (CPDFOptimizeFlag.removeJavaScriptActions, 'Remove JavaScript (lossy)'),
  (CPDFOptimizeFlag.removeEmbeddedFonts, 'Remove embedded fonts (lossy)'),
  (CPDFOptimizeFlag.optimizePageContent, 'Optimize page content'),
  (CPDFOptimizeFlag.fastWebView, 'Fast web view'),
];

class _OptimizeDocumentExampleState
    extends ApiExampleBaseState<OptimizeDocumentExample> {
  Set<CPDFOptimizeFlag> _flags = CPDFOptimizeFlag.defaults;
  double _imageQuality = 40;
  bool _fontSubset = false;

  String? _optimizedPath;
  int? _progressPageIndex;
  bool _busy = false;
  int? _sourceFileSize;

  /// The actions touch the base class's `late document`, so they stay disabled
  /// until the sample document has actually been opened.
  bool get _canRun => !_busy && isDocumentReady;

  @override
  void onDocumentReady() {
    _loadSourceFileSize();
    _loadOptions();
  }

  @override
  List<Widget> buildExampleContent(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return [
      const _UnsavedChangesNotice(),
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
            _buildHeaderRow(colors),
            const SizedBox(height: 10),
            _buildQualityRow(colors),
            for (final entry in _toggleableFlags)
              _buildFlagRow(colors, entry.$1, entry.$2),
            _buildFontSubsetRow(colors),
            const SizedBox(height: 10),
            _buildActionsRow(colors),
            const SizedBox(height: 8),
            _buildOpenOutputRow(colors),
          ],
        ),
      ),
    ];
  }

  Widget _buildHeaderRow(ColorScheme colors) {
    final progress = _progressPageIndex;
    final sourceSize = _sourceFileSize;
    return Row(
      children: [
        Text(
          progress != null ? 'Processing' : 'Source file',
          style: TextStyle(
            fontSize: 12,
            color: progress != null ? colors.primary : colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            progress != null
                ? 'page $progress'
                : sourceSize != null
                    ? _formatFileSize(sourceSize)
                    : '—',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: progress != null ? colors.primary : colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (progress == null)
          SizedBox(
            height: 28,
            child: TextButton.icon(
              onPressed: _canRun ? _loadOptions : null,
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

  Widget _buildQualityRow(ColorScheme colors) {
    return Row(
      children: [
        Text(
          'Image quality',
          style: TextStyle(fontSize: 12, color: colors.onSurface),
        ),
        Expanded(
          child: Slider(
            value: _imageQuality,
            max: 100,
            divisions: 100,
            label: _imageQuality.round().toString(),
            onChanged: _canRun
                ? (value) => setState(() => _imageQuality = value)
                : null,
          ),
        ),
        SizedBox(
          width: 28,
          child: Text(
            '${_imageQuality.round()}',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildFlagRow(
    ColorScheme colors,
    CPDFOptimizeFlag flag,
    String label,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: colors.onSurface),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: _flags.contains(flag),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: _canRun
                ? (value) => setState(() {
                      final next = Set<CPDFOptimizeFlag>.from(_flags);
                      if (value) {
                        next.add(flag);
                      } else {
                        next.remove(flag);
                      }
                      _flags = next;
                    })
                : null,
          ),
        ),
      ],
    );
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
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _canRun ? _optimizeToFile : null,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Optimize to file', style: TextStyle(fontSize: 13)),
      ),
    );
  }

  Widget _buildOpenOutputRow(ColorScheme colors) {
    final canOpenOutput = _canRun && _optimizedPath != null;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            // Cancelling is only meaningful while a run is in flight, which is
            // exactly when every other button is disabled.
            onPressed: _busy ? _cancel : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cancel', style: TextStyle(fontSize: 13)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: canOpenOutput ? _openOptimizedDocument : null,
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

  CPDFOptimizeOptions _buildOptions() {
    return CPDFOptimizeOptions(
      flags: _flags,
      imageQuality: _imageQuality,
    );
  }

  void _onProgress(int pageIndex) {
    if (mounted) setState(() => _progressPageIndex = pageIndex);
  }

  Future<void> _loadOptions() async {
    setState(() => _busy = true);
    try {
      final options = await document.getOptimizeOptions();
      if (mounted) {
        setState(() {
          _flags = options.flags;
          _imageQuality = options.imageQuality.clamp(0, 100);
        });
      }
      applyLog('getOptimizeOptions()');
      applyLog('  flags: ${options.flags.toMask()}');
      applyLog('  imageQuality: ${options.imageQuality}');
      applyLog('  color: ${options.colorImageOptions}');
      applyLog('  grayscale: ${options.grayscaleImageOptions}');
      applyLog('  monochrome: ${options.monochromeImageOptions}');
      applyLog('  colorSpaceConvert: ${options.colorSpaceConvert}');
    } on CPDFOptimizeException catch (e) {
      applyLog('getOptimizeOptions() failed: ${e.code} - ${e.message}');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _loadSourceFileSize() async {
    try {
      final path = await document.getDocumentPath();
      final file = File(path);
      if (await file.exists()) {
        final size = await file.length();
        if (mounted) setState(() => _sourceFileSize = size);
      }
    } catch (e) {
      // Fail silently; the header will show "—" when the size is unknown.
    }
  }

  Future<void> _optimizeToFile() async {
    setState(() {
      _busy = true;
      _optimizedPath = null;
      _progressPageIndex = null;
    });
    clearLogs();
    try {
      final directory = await ComPDFKit.getTemporaryDirectory();
      final outputPath = '${directory.path}/optimized_document.pdf';
      final sourcePath = await document.getFileName();

      applyLog('optimizeToFile()');
      applyLog('  source: $sourcePath');
      applyLog('  output: $outputPath');
      applyLog('  flags: ${_flags.toMask()}');
      applyLog('  fontSubset: $_fontSubset');

      final result = await document.optimizeToFile(
        outputPath,
        options: _buildOptions(),
        fontSubset: _fontSubset,
        onProgress: _onProgress,
      );
      _logResult(result);

      if (result.ok) {
        setState(() => _optimizedPath = outputPath);
        await _logSize(outputPath);
      }
    } on CPDFOptimizeException catch (e) {
      applyLog('optimizeToFile() failed: ${e.code} - ${e.message}');
    } on PlatformException catch (e) {
      // getTemporaryDirectory() and the document queries report failures as
      // plain platform exceptions; they belong in the log, not in the console.
      applyLog('optimizeToFile() failed: ${e.code} - ${e.message}');
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _progressPageIndex = null;
        });
      }
    }
  }

  Future<void> _cancel() async {
    try {
      await document.cancelOptimize();
      applyLog('cancelOptimize() requested');
    } on CPDFOptimizeException catch (e) {
      applyLog('cancelOptimize() failed: ${e.code} - ${e.message}');
    }
  }

  void _logResult(CPDFOptimizeResult result) {
    applyLog('  ok: ${result.ok}');
    applyLog('  cancelled: ${result.cancelled}');
    applyLog('  pagesProcessed: ${result.pagesProcessed}');
    applyLog('  stepsUs: ${result.stepsUs}');
    applyLog('  saveUs: ${result.saveUs}');
  }

  Future<void> _logSize(String outputPath) async {
    try {
      final output = File(outputPath);
      if (!await output.exists()) {
        applyLog('Output file is missing: $outputPath');
        return;
      }
      final bytes = await output.length();
      final sizeStr = _formatFileSize(bytes);
      applyLog('Output size: $sizeStr');
    } on FileSystemException catch (e) {
      applyLog('Reading the output size failed: ${e.message}');
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  void _openOptimizedDocument() {
    final path = _optimizedPath;
    if (path == null) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (readerContext) => CPDFReaderPage(
          title: 'Optimized document',
          documentPath: path,
          configuration: CPDFConfiguration(),
          onIOSClickBackPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class _UnsavedChangesNotice extends StatelessWidget {
  const _UnsavedChangesNotice();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 15, color: colors.onTertiaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'The document is reopened from its source file after each run, '
              'so unsaved changes are discarded. Save first to keep them.',
              style: TextStyle(
                fontSize: 11.5,
                color: colors.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
