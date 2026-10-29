// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of '../certificate_management_example.dart';

/// Certificate form and action widgets shared by certificate pages.
class _CertificateFormCard extends StatelessWidget {
  const _CertificateFormCard({
    required this.commonName,
    required this.organization,
    required this.password,
    required this.country,
    required this.state,
    required this.locality,
    required this.unit,
    required this.email,
    required this.commonNameFocus,
    required this.organizationFocus,
    required this.countryFocus,
    required this.stateFocus,
    required this.localityFocus,
    required this.unitFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.showAdvanced,
    required this.onAdvancedChanged,
  });

  final TextEditingController commonName;
  final TextEditingController organization;
  final TextEditingController password;
  final TextEditingController country;
  final TextEditingController state;
  final TextEditingController locality;
  final TextEditingController unit;
  final TextEditingController email;
  final FocusNode commonNameFocus;
  final FocusNode organizationFocus;
  final FocusNode countryFocus;
  final FocusNode stateFocus;
  final FocusNode localityFocus;
  final FocusNode unitFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final bool showAdvanced;
  final VoidCallback onAdvancedChanged;

  @override
  Widget build(BuildContext context) => _PencilPanel(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Identity details',
                  style: _CertificateText.groupHeading),
              const SizedBox(height: 12),
              _CertificateTextField(
                controller: commonName,
                label: 'Common name',
                pencilStyle: true,
                focusNode: commonNameFocus,
                nextFocusNode: organizationFocus,
              ),
              const SizedBox(height: 14),
              _CertificateTextField(
                controller: organization,
                label: 'Organization',
                pencilStyle: true,
                focusNode: organizationFocus,
                nextFocusNode: showAdvanced ? countryFocus : passwordFocus,
              ),
              const SizedBox(height: 12),
              _AdvancedFieldsButton(
                onPressed: onAdvancedChanged,
                expanded: showAdvanced,
              ),
              if (showAdvanced) ...[
                const SizedBox(height: 12),
                _CertificateTextField(
                  controller: country,
                  label: 'Country',
                  pencilStyle: true,
                  focusNode: countryFocus,
                  nextFocusNode: stateFocus,
                ),
                const SizedBox(height: 14),
                _CertificateTextField(
                  controller: state,
                  label: 'State / Province',
                  pencilStyle: true,
                  focusNode: stateFocus,
                  nextFocusNode: localityFocus,
                ),
                const SizedBox(height: 14),
                _CertificateTextField(
                  controller: locality,
                  label: 'Locality',
                  pencilStyle: true,
                  focusNode: localityFocus,
                  nextFocusNode: unitFocus,
                ),
                const SizedBox(height: 14),
                _CertificateTextField(
                  controller: unit,
                  label: 'Organizational unit',
                  pencilStyle: true,
                  focusNode: unitFocus,
                  nextFocusNode: emailFocus,
                ),
                const SizedBox(height: 14),
                _CertificateTextField(
                  controller: email,
                  label: 'Email',
                  pencilStyle: true,
                  focusNode: emailFocus,
                  nextFocusNode: passwordFocus,
                ),
              ],
              const SizedBox(height: 14),
              const Text('Security and export',
                  style: _CertificateText.groupHeading),
              const SizedBox(height: 12),
              _CertificateTextField(
                controller: password,
                obscureText: true,
                label: 'PKCS#12 password',
                hintText: 'Enter password',
                pencilStyle: true,
                focusNode: passwordFocus,
              ),
              const SizedBox(height: 12),
              const _CertificateOutputPath(pencilStyle: true),
            ],
          ),
        ),
      );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    this.height = 46,
    this.radius = 8,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: _CertificateTheme.primary,
            disabledBackgroundColor:
                _CertificateTheme.primary.withValues(alpha: .45),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (busy)
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            else if (icon != null)
              Icon(icon, size: 18),
            if (busy || icon != null) const SizedBox(width: 8),
            Text(label,
                style:
                    _CertificateText.actionTitle.copyWith(color: Colors.white)),
          ]),
        ),
      );
}

class _CertificateTextField extends StatelessWidget {
  const _CertificateTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.readOnly = false,
    this.obscureText = false,
    this.focusNode,
    this.nextFocusNode,
    this.pencilStyle = false,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool readOnly;
  final bool obscureText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool pencilStyle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _CertificateText.label),
          const SizedBox(height: 6),
          SizedBox(
            height: pencilStyle ? 44 : 42,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              readOnly: readOnly,
              obscureText: obscureText,
              textInputAction: nextFocusNode == null
                  ? TextInputAction.done
                  : TextInputAction.next,
              onEditingComplete: () {
                if (nextFocusNode != null) {
                  nextFocusNode!.requestFocus();
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              style: _CertificateText.input,
              decoration: InputDecoration(
                isDense: true,
                hintText: hintText,
                errorText: errorText,
                hintStyle: _CertificateText.input
                    .copyWith(color: _CertificateTheme.muted),
                prefixIcon: prefixIcon == null
                    ? null
                    : Icon(prefixIcon,
                        size: 18, color: _CertificateTheme.muted),
                suffixIcon: suffix,
                filled: pencilStyle,
                fillColor: pencilStyle ? const Color(0xFFFBFCFE) : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(pencilStyle ? 8 : 6),
                  borderSide: BorderSide(
                      color: pencilStyle
                          ? const Color(0xFFD9E1EC)
                          : _CertificateTheme.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(pencilStyle ? 8 : 6),
                  borderSide:
                      const BorderSide(color: _CertificateTheme.primary),
                ),
              ),
            ),
          ),
        ],
      );
}

class _AdvancedFieldsButton extends StatelessWidget {
  const _AdvancedFieldsButton(
      {required this.onPressed, required this.expanded});

  final VoidCallback onPressed;
  final bool expanded;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 40,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            backgroundColor: const Color(0xFFF5F7FA),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Row(children: [
            Text('Advanced identity fields', style: _CertificateText.label),
            const Spacer(),
            Icon(expanded ? Icons.expand_less : Icons.expand_more,
                size: 18, color: _CertificateTheme.muted),
          ]),
        ),
      );
}

class _CertificateOutputPath extends StatelessWidget {
  const _CertificateOutputPath({this.pencilStyle = false});

  final bool pencilStyle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Output path', style: _CertificateText.label),
          const SizedBox(height: 6),
          Container(
            height: pencilStyle ? 44 : 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: pencilStyle
                  ? const Color(0xFFFBFCFE)
                  : const Color(0xFFF5F7FA),
              border: Border.all(
                  color: pencilStyle
                      ? const Color(0xFFD9E1EC)
                      : _CertificateTheme.inputBorder),
              borderRadius: BorderRadius.circular(pencilStyle ? 8 : 6),
            ),
            child: Text('Temporary directory / compdf-flutter-development.p12',
                overflow: TextOverflow.ellipsis, style: _CertificateText.body),
          ),
        ],
      );
}
