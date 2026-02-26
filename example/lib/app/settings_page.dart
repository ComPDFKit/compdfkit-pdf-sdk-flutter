// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../utils/preferences_service.dart';
import '../widgets/app_toolbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _highlightLink = false;
  bool _highlightForm = false;
  String _documentAuthor = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    setState(() {
      _highlightLink = PreferencesService.highlightLink;
      _highlightForm = PreferencesService.highlightForm;
      _documentAuthor = PreferencesService.documentAuthor;
    });
  }

  Future<void> _saveDocumentAuthor(String author) async {
    await PreferencesService.setDocumentAuthor(author);
    setState(() {
      _documentAuthor = author;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppToolbar(
              title: 'Settings',
              subtitle: 'Settings & Info',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    const _SectionHeader(title: 'Global setting'),
                    const SizedBox(height: 8),
                    _CardContainer(
                      children: [
                        _ToggleRow(
                          title: 'Highlight Link area',
                          value: _highlightLink,
                          onChanged: (value) {
                            PreferencesService.setHighlightLink(value);
                            setState(() => _highlightLink = value);
                          },
                        ),
                        const _CardDivider(),
                        _ToggleRow(
                          title: 'Highlight Form Area',
                          value: _highlightForm,
                          onChanged: (value) {
                            PreferencesService.setHighlightForm(value);
                            setState(() => _highlightForm = value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _CardContainer(
                      children: [
                        _EditableRow(
                          title: 'Document Author',
                          value: _documentAuthor,
                          onChanged: _saveDocumentAuthor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _SectionHeader(title: 'SDK Information'),
                    const SizedBox(height: 8),
                    _CardContainer(
                      children: [
                        _ValueRow(
                          title: 'Versions',
                          valueWidget: FutureBuilder<String>(
                            future: ComPDFKit.getVersionCode(),
                            builder: (context, snap) {
                              final version = snap.data;
                              return Text(
                                version == null ? '' : 'v$version',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _SectionHeader(title: 'Company Information'),
                    const SizedBox(height: 8),
                    _CardContainer(
                      children: [
                        _LinkRow(
                          title: AppConstants.websiteUrl,
                          onTap: () => launchUrl(
                            Uri.parse(AppConstants.websiteUrl),
                          ),
                        ),
                        const _CardDivider(),
                        _LinkRow(
                          title: 'About Us',
                          onTap: () => launchUrl(
                            Uri.parse(AppConstants.aboutUsUrl),
                          ),
                        ),
                        const _CardDivider(),
                        _LinkRow(
                          title: 'Technical Support',
                          onTap: () => launchUrl(
                            Uri.parse(AppConstants.technicalSupportUrl),
                          ),
                        ),
                        const _CardDivider(),
                        _LinkRow(
                          title: 'Contact Sales',
                          onTap: () => launchUrl(
                            Uri.parse(AppConstants.contactSalesUrl),
                          ),
                        ),
                        const _CardDivider(),
                        _LinkRow(
                          title: AppConstants.supportEmail,
                          onTap: () => launchUrl(
                            Uri.parse(AppConstants.supportEmailUrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
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
      child: Column(
        children: children,
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
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
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.bodyMedium,
              ),
            ),
            _ToggleSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String title;
  final Widget? valueWidget;

  const _ValueRow({
    required this.title,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.bodyMedium,
              ),
            ),
            valueWidget ??
                Text(
                  '',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _EditableRow extends StatelessWidget {
  final String title;
  final String value;
  final ValueChanged<String> onChanged;

  const _EditableRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: value);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter author name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                onChanged(newValue);
              }
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => _showEditDialog(context),
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(
                title,
                style: textTheme.bodyMedium,
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _LinkRow({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodyMedium,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Text(
            AppConstants.copyrightNotice,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(TextSpan(children: [
            TextSpan(
              text: 'Privacy Policy',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(
                      Uri.parse(AppConstants.privacyPolicyUrl),
                    ),
            ),
            const TextSpan(text: ' | '),
            TextSpan(
              text: 'Terms of Service',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(
                      Uri.parse(AppConstants.termsOfServiceUrl),
                    ),
            ),
          ])),
        ],
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
