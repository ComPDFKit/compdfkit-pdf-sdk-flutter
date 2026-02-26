// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

/// Display setting page for PDF reader widget.
///
/// This page provides UI controls for adjusting display settings such as:
/// - Scroll direction (vertical/horizontal)
/// - Display mode (single page/double page/cover page)
/// - Highlight options (links/form fields)
/// - Other options (continuous scrolling, crop mode)
/// - Theme colors
class DisplaySettingsPage extends StatefulWidget {
  final CPDFReaderWidgetController controller;

  const DisplaySettingsPage({
    super.key,
    required this.controller,
  });

  @override
  State<DisplaySettingsPage> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  bool _isVertical = true;
  CPDFDisplayMode _displayMode = CPDFDisplayMode.singlePage;
  bool _isLinkHighlight = true;
  bool _isFormFieldHighlight = true;
  bool _isContinuous = true;
  bool _isCrop = false;
  bool _canScale = true;
  CPDFThemes _themes = CPDFThemes.light;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initReaderViewWidgetStates();
  }

  Future<void> _initReaderViewWidgetStates() async {
    try {
      final controller = widget.controller;
      final results = await Future.wait([
        controller.isVerticalMode(),
        controller.isDoublePageMode(),
        controller.isCoverPageMode(),
        controller.isLinkHighlight(),
        controller.isFormFieldHighlight(),
        controller.isContinueMode(),
        controller.isCropMode(),
        controller.getReadBackgroundColor(),
      ]);

      if (!mounted) return;

      final isVertical = results[0] as bool;
      final isDoublePageMode = results[1] as bool;
      final isCoverPageMode = results[2] as bool;
      final themeColor = results[7] as Color;

      setState(() {
        _isVertical = isVertical;
        _displayMode = _resolveDisplayMode(isDoublePageMode, isCoverPageMode);
        _isLinkHighlight = results[3] as bool;
        _isFormFieldHighlight = results[4] as bool;
        _isContinuous = results[5] as bool;
        _isCrop = results[6] as bool;
        _themes = CPDFThemes.of(themeColor);
        _isLoading = false;
      });

      debugPrint('Display settings loaded - theme: ${themeColor.toHex()}');
    } catch (e) {
      debugPrint('Failed to load display settings: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  CPDFDisplayMode _resolveDisplayMode(bool isDouble, bool isCover) {
    if (!isDouble) return CPDFDisplayMode.singlePage;
    return isCover ? CPDFDisplayMode.coverPage : CPDFDisplayMode.doublePage;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildScrollingSection(),
                    const SizedBox(height: 16),
                    _buildDisplayModeSection(),
                    const SizedBox(height: 16),
                    _buildOptionsSection(),
                    const SizedBox(height: 16),
                    _buildThemesSection(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          // Left placeholder to balance the close button
          const SizedBox(width: 48),
          Expanded(
            child: Text(
              'Display Settings',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  // ==================== Scrolling Section ====================

  Widget _buildScrollingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Scrolling'),
        const SizedBox(height: 8),
        _CardContainer(
          children: [
            _SelectableRow(
              title: 'Vertical Scrolling',
              isSelected: _isVertical,
              onTap: () => _updateVerticalMode(true),
            ),
            const _CardDivider(),
            _SelectableRow(
              title: 'Horizontal Scrolling',
              isSelected: !_isVertical,
              onTap: () => _updateVerticalMode(false),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _updateVerticalMode(bool isVertical) async {
    if (_isVertical == isVertical) return;
    setState(() => _isVertical = isVertical);
    await widget.controller.setVerticalMode(isVertical);
  }

  // ==================== Display Mode Section ====================

  Widget _buildDisplayModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Display Mode'),
        const SizedBox(height: 8),
        _CardContainer(
          children: [
            _SelectableRow(
              title: 'Single Page',
              isSelected: _displayMode == CPDFDisplayMode.singlePage,
              onTap: () => _updateDisplayMode(CPDFDisplayMode.singlePage),
            ),
            const _CardDivider(),
            _SelectableRow(
              title: 'Two Pages',
              isSelected: _displayMode == CPDFDisplayMode.doublePage,
              onTap: () => _updateDisplayMode(CPDFDisplayMode.doublePage),
            ),
            const _CardDivider(),
            _SelectableRow(
              title: 'Cover Mode',
              isSelected: _displayMode == CPDFDisplayMode.coverPage,
              onTap: () => _updateDisplayMode(CPDFDisplayMode.coverPage),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _updateDisplayMode(CPDFDisplayMode mode) async {
    if (_displayMode == mode) return;
    setState(() => _displayMode = mode);

    switch (mode) {
      case CPDFDisplayMode.singlePage:
        await widget.controller.setDoublePageMode(false);
        break;
      case CPDFDisplayMode.doublePage:
        await widget.controller.setDoublePageMode(true);
        break;
      case CPDFDisplayMode.coverPage:
        await widget.controller.setCoverPageMode(true);
        break;
    }
  }

  // ==================== Options Section ====================

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Options'),
        const SizedBox(height: 8),
        _CardContainer(
          children: [
            _ToggleRow(
              title: 'Highlight Links',
              value: _isLinkHighlight,
              onChanged: (value) async {
                setState(() => _isLinkHighlight = value);
                await widget.controller.setLinkHighlight(value);
              },
            ),
            const _CardDivider(),
            _ToggleRow(
              title: 'Highlight Form Fields',
              value: _isFormFieldHighlight,
              onChanged: (value) async {
                setState(() => _isFormFieldHighlight = value);
                await widget.controller.setFormFieldHighlight(value);
              },
            ),
            const _CardDivider(),
            _ToggleRow(
              title: 'Continuous Scrolling',
              value: _isContinuous,
              onChanged: (value) async {
                setState(() => _isContinuous = value);
                await widget.controller.setContinueMode(value);
              },
            ),
            const _CardDivider(),
            _ToggleRow(
              title: 'Crop Mode',
              value: _isCrop,
              onChanged: (value) async {
                setState(() => _isCrop = value);
                await widget.controller.setCropMode(value);
              },
            ),
            if (Platform.isAndroid) ...[
              const _CardDivider(),
              _ToggleRow(
                title: 'Can Scale',
                value: _canScale,
                onChanged: (value) async {
                  setState(() => _canScale = value);
                  await widget.controller.setCanScale(value);
                },
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ==================== Themes Section ====================

  Widget _buildThemesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Themes'),
        const SizedBox(height: 8),
        _CardContainer(
          children: [
            _ThemeRow(
              title: 'Light',
              color: HexColor.fromHex(CPDFThemes.light.color),
              isSelected: _themes == CPDFThemes.light,
              onTap: () => _updateTheme(CPDFThemes.light),
            ),
            const _CardDivider(),
            _ThemeRow(
              title: 'Dark',
              color: HexColor.fromHex(CPDFThemes.dark.color),
              isSelected: _themes == CPDFThemes.dark,
              onTap: () => _updateTheme(CPDFThemes.dark),
            ),
            const _CardDivider(),
            _ThemeRow(
              title: 'Sepia',
              color: HexColor.fromHex(CPDFThemes.sepia.color),
              isSelected: _themes == CPDFThemes.sepia,
              onTap: () => _updateTheme(CPDFThemes.sepia),
            ),
            const _CardDivider(),
            _ThemeRow(
              title: 'Reseda',
              color: HexColor.fromHex(CPDFThemes.reseda.color),
              isSelected: _themes == CPDFThemes.reseda,
              onTap: () => _updateTheme(CPDFThemes.reseda),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _updateTheme(CPDFThemes theme) async {
    if (_themes == theme) return;
    setState(() => _themes = theme);
    await widget.controller.setReadBackgroundColor(theme);
  }
}

// ==================== Reusable Components ====================

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final List<Widget> children;

  const _CardContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 12),
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class _SelectableRow extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableRow({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 20,
                  color: colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            _ToggleSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: value ? colorScheme.primary : colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(13),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  final String title;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeRow({
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 20,
                  color: colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
