// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../widgets/app_toolbar.dart';
import '../shared/example_document_loader.dart';

/// Demonstrates the four interactive annotation and form creation policies.
class CreationPolicyExample extends StatelessWidget {
  /// Creates the creation policy example.
  const CreationPolicyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Creation Policy',
      assetPath: AppAssets.pdfDocument,
      builder: (path) => _CreationPolicyPage(documentPath: path),
    );
  }
}

class _CreationPolicyPage extends StatefulWidget {
  const _CreationPolicyPage({required this.documentPath});

  final String documentPath;

  @override
  State<_CreationPolicyPage> createState() => _CreationPolicyPageState();
}

class _CreationPolicyPageState extends State<_CreationPolicyPage> {
  bool _continuousCreation = true;
  bool _autoSelectCreatedAnnotation = true;
  String _lastEvent = 'Create an annotation or form field to inspect events.';
  CPDFReaderWidgetController? _controller;

  CPDFConfiguration get _configuration => CPDFConfiguration(
        modeConfig:
            const CPDFModeConfig(initialViewMode: CPDFViewMode.annotations),
        creationConfig: CPDFCreationConfig(
          continuousCreation: _continuousCreation,
          autoSelectCreatedAnnotation: _autoSelectCreatedAnnotation,
        ),
      );

  String get _policyKey => '${_continuousCreation ? 'continuous' : 'single'}-'
      '${_autoSelectCreatedAnnotation ? 'selected' : 'unselected'}';

  String get _policyLabel =>
      '${_continuousCreation ? 'Continuous' : 'Single'} / '
      '${_autoSelectCreatedAnnotation ? 'Auto-select' : 'No selection'}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Creation Policy',
            onBack: () async {
              await _controller?.document.save();
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          _buildPolicySelector(context),
          Expanded(
            child: CPDFReaderWidget(
              key: ValueKey(_policyKey),
              document: widget.documentPath,
              configuration: _configuration,
              onCreated: _onCreated,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 5),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            // Keep Flutter 3.3 compatibility; initialValue was added later.
            // ignore: deprecated_member_use
            value: _policyLabel,
            isDense: true,
            isExpanded: true,
            itemHeight: 48,
            menuMaxHeight: 220,
            borderRadius: BorderRadius.circular(12),
            dropdownColor: colorScheme.surface,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            decoration: InputDecoration(
              labelText: 'Creation behavior',
              labelStyle: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(Icons.tune_rounded, color: colorScheme.primary),
              prefixIconConstraints: const BoxConstraints(minWidth: 36),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: InputBorder.none,
            ),
            items: [
              for (final continuous in [true, false])
                for (final select in [true, false])
                  DropdownMenuItem(
                    value: '${continuous ? 'Continuous' : 'Single'} / '
                        '${select ? 'Auto-select' : 'No selection'}',
                    child: _buildPolicyMenuItem(
                      context,
                      continuous: continuous,
                      autoSelect: select,
                    ),
                  ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _continuousCreation = value.startsWith('Continuous');
                _autoSelectCreatedAnnotation = value.endsWith('Auto-select');
                _lastEvent =
                    'Policy updated. Create an annotation or form field to test it.';
                _controller = null;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 1, 2, 0),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 15, color: colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _lastEvent,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyMenuItem(
    BuildContext context, {
    required bool continuous,
    required bool autoSelect,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = continuous == _continuousCreation &&
        autoSelect == _autoSelectCreatedAnnotation;
    final label = '${continuous ? 'Continuous' : 'Single'} / '
        '${autoSelect ? 'Auto-select' : 'No selection'}';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          continuous ? Icons.repeat_rounded : Icons.looks_one_rounded,
          size: 18,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Text(label),
        if (isSelected) ...[
          const SizedBox(width: 8),
          Icon(Icons.check_rounded, size: 18, color: colorScheme.primary),
        ],
      ],
    );
  }

  void _onCreated(CPDFReaderWidgetController controller) {
    _controller = controller;
    controller.addEventListener(CPDFEvent.annotationsCreated, (_) {
      if (mounted) setState(() => _lastEvent = 'Annotation created');
    });
    controller.addEventListener(CPDFEvent.formFieldsCreated, (_) {
      if (mounted) setState(() => _lastEvent = 'Form field created');
    });
    controller.addEventListener(CPDFEvent.annotationsSelected, (_) {
      if (mounted) setState(() => _lastEvent = 'Annotation selected');
    });
    controller.addEventListener(CPDFEvent.formFieldsSelected, (_) {
      if (mounted) setState(() => _lastEvent = 'Form field selected');
    });
    controller.addEventListener(CPDFEvent.annotationsDeselected, (_) {
      if (mounted) setState(() => _lastEvent = 'Annotation deselected');
    });
    controller.addEventListener(CPDFEvent.formFieldsDeselected, (_) {
      if (mounted) setState(() => _lastEvent = 'Form field deselected');
    });
  }
}
