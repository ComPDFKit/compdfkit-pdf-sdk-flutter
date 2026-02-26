/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/document/action/cpdf_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_goto_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Link configuration dialog for configuring PDF link annotations.
///
/// Supports configurable link types:
/// - Web URL (https://)
/// - Email (mailto:)
/// - Page Jump (go to page index)
class LinkConfigDialog extends StatefulWidget {
  /// Enabled link types for the dialog.
  final List<LinkType> enabledTypes;

  /// Default URL value when the URL type is enabled.
  final String defaultUrl;

  /// Default email value when the email type is enabled.
  final String defaultEmail;

  /// Default page index when the page type is enabled.
  final int defaultPageIndex;

  const LinkConfigDialog({
    super.key,
    this.enabledTypes = const [
      LinkType.url,
      LinkType.email,
      LinkType.page,
    ],
    this.defaultUrl = 'https://www.compdf.com',
    this.defaultEmail = 'support@compdf.com',
    this.defaultPageIndex = 0,
  }) : assert(
          enabledTypes.length > 0,
          'At least one link type must be enabled.',
        );

  @override
  State<LinkConfigDialog> createState() => _LinkConfigDialogState();
}

enum LinkType { url, email, page }

class _LinkConfigDialogState extends State<LinkConfigDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final List<LinkType> _availableTypes;
  late final TextEditingController _urlController;
  late final TextEditingController _emailController;
  late final TextEditingController _pageController;

  @override
  void initState() {
    super.initState();
    _availableTypes = widget.enabledTypes;
    _urlController = TextEditingController(text: widget.defaultUrl);
    _emailController = TextEditingController(text: widget.defaultEmail);
    _pageController =
        TextEditingController(text: widget.defaultPageIndex.toString());
    _tabController = TabController(length: _availableTypes.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  LinkType get _selectedType {
    return _availableTypes[_tabController.index];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    _emailController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  CPDFAction? _buildAction() {
    switch (_selectedType) {
      case LinkType.url:
        final url = _urlController.text.trim();
        if (url.isEmpty) return null;
        return CPDFUriAction(uri: url);
      case LinkType.email:
        final email = _emailController.text.trim();
        if (email.isEmpty) return null;
        return CPDFUriAction.email(email: email);
      case LinkType.page:
        final pageIndex = int.tryParse(_pageController.text.trim());
        if (pageIndex == null || pageIndex < 0) return null;
        return CPDFGoToAction(pageIndex: pageIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== Header ====================
            Text(
              'Configure Link',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // ==================== Type Selector ====================
            if (_availableTypes.length > 1) ...[
              _buildTypeSelector(colorScheme, textTheme),
              const SizedBox(height: 20),
            ],

            // ==================== Input Fields ====================
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              child: _buildInputField(colorScheme),
            ),
            const SizedBox(height: 24),

            // ==================== Action Buttons ====================
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    foregroundColor: colorScheme.onSurfaceVariant,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Cancel',
                    style: textTheme.labelLarge,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    final action = _buildAction();
                    if (action != null) {
                      Navigator.pop(context, action);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirm',
                    style: textTheme.labelLarge
                        ?.copyWith(color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(ColorScheme colorScheme, TextTheme textTheme) {
    final tabs = _availableTypes.map((type) {
      switch (type) {
        case LinkType.url:
          return const Tab(icon: Icon(Icons.language, size: 24), height: 56);
        case LinkType.email:
          return const Tab(
            icon: Icon(Icons.email_outlined, size: 24),
            height: 56,
          );
        case LinkType.page:
          return const Tab(
            icon: Icon(Icons.description_outlined, size: 24),
            height: 56,
          );
      }
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelMedium,
        tabs: tabs,
      ),
    );
  }

  Widget _buildInputField(ColorScheme colorScheme) {
    switch (_selectedType) {
      case LinkType.url:
        return _buildTextField(
          key: const ValueKey('url'),
          controller: _urlController,
          label: 'Web URL',
          hint: 'https://www.example.com',
          icon: Icons.link,
          colorScheme: colorScheme,
          keyboardType: TextInputType.url,
        );
      case LinkType.email:
        return _buildTextField(
          key: const ValueKey('email'),
          controller: _emailController,
          label: 'Email Address',
          hint: 'example@email.com',
          icon: Icons.email_outlined,
          colorScheme: colorScheme,
          keyboardType: TextInputType.emailAddress,
        );
      case LinkType.page:
        return _buildTextField(
          key: const ValueKey('page'),
          controller: _pageController,
          label: 'Target Page Index',
          hint: '0',
          icon: Icons.bookmark_outline,
          colorScheme: colorScheme,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        );
    }
  }

  Widget _buildTextField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ColorScheme colorScheme,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
