// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// Callback type for search action.
typedef CPDFSearchCallback = void Function(String keyword);

/// Reusable search bar component for PDF text search.
///
/// Features:
/// - Text input field with clear button
/// - Search icon button (disabled when input is empty)
/// - Loading indicator during search
/// - Follows Material Design 3 theme
///
/// Example usage:
/// ```dart
/// PdfSearchBar(
///   onSearch: (keyword) async {
///     // Perform search
///   },
/// )
/// ```
class PdfSearchBar extends StatefulWidget {
  /// Callback when search button is pressed or keyboard submit.
  final CPDFSearchCallback? onSearch;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when clear button is pressed.
  final VoidCallback? onClear;

  /// Whether search is in progress.
  final bool isLoading;

  /// Hint text for the input field.
  final String hintText;

  /// External text controller (optional).
  final TextEditingController? controller;

  /// External focus node (optional).
  final FocusNode? focusNode;

  /// Constructor
  const PdfSearchBar({
    super.key,
    this.onSearch,
    this.onChanged,
    this.onClear,
    this.isLoading = false,
    this.hintText = 'Enter search keyword',
    this.controller,
    this.focusNode,
  });

  @override
  State<PdfSearchBar> createState() => _PdfSearchBarState();
}

class _PdfSearchBarState extends State<PdfSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isInternalController = false;
  bool _isInternalFocusNode = false;

  bool get _canSearch =>
      _controller.text.trim().isNotEmpty && !widget.isLoading;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _isInternalController = true;
    }
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_isInternalController) {
      _controller.dispose();
    }
    if (_isInternalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
    widget.onChanged?.call(_controller.text);
  }

  void _handleSearch() {
    if (!_canSearch) return;
    _focusNode.unfocus();
    widget.onSearch?.call(_controller.text.trim());
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(128),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTextField(colorScheme)),
          const SizedBox(width: 12),
          _buildSearchButton(colorScheme),
        ],
      ),
    );
  }

  Widget _buildTextField(ColorScheme colorScheme) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: TextStyle(
        fontSize: 15,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 15,
          color: colorScheme.onSurfaceVariant.withAlpha(153),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withAlpha(128),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: _handleClear,
              )
            : null,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _handleSearch(),
    );
  }

  Widget _buildSearchButton(ColorScheme colorScheme) {
    if (widget.isLoading) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(51),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return Material(
      color: _canSearch
          ? colorScheme.primary
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _canSearch ? _handleSearch : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            Icons.search,
            size: 22,
            color: _canSearch
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant.withAlpha(102),
          ),
        ),
      ),
    );
  }
}
