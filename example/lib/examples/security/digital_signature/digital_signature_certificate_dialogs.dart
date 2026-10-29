// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION AND DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of 'digital_signature_widgets.dart';

/// Shows an empty password field for a selected PKCS#12 certificate.
Future<String?> showCertificatePasswordDialog({
  required BuildContext context,
  required String certificateName,
  required Future<bool> Function(String password) validatePassword,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _CertificatePasswordDialog(
      certificateName: certificateName,
      validatePassword: validatePassword,
    ),
  );
}

class _CertificatePasswordDialog extends StatefulWidget {
  const _CertificatePasswordDialog({
    required this.certificateName,
    required this.validatePassword,
  });

  final String certificateName;
  final Future<bool> Function(String password) validatePassword;

  @override
  State<_CertificatePasswordDialog> createState() =>
      _CertificatePasswordDialogState();
}

class _CertificatePasswordDialogState
    extends State<_CertificatePasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecking = false;
  String? _errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _errorText = 'Enter the certificate password.');
      return;
    }
    setState(() {
      _isChecking = true;
      _errorText = null;
    });
    try {
      final valid = await widget.validatePassword(password);
      if (!mounted) {
        return;
      }
      if (valid) {
        Navigator.of(context).pop(password);
      } else {
        setState(() => _errorText = 'Incorrect certificate password.');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorText = 'The password could not be verified.');
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Certificate password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.certificateName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('digital-signature-password'),
            controller: _passwordController,
            autofocus: true,
            obscureText: true,
            onSubmitted: (_) => _verify(),
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              errorText: _errorText,
              enabledBorder: _passwordBorder(),
              focusedBorder: _passwordBorder(focused: true),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isChecking ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isChecking ? null : _verify,
          child: _isChecking
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Verify'),
        ),
      ],
    );
  }

  OutlineInputBorder _passwordBorder({bool focused = false}) {
    final invalid = _errorText != null;
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: invalid ? _error : (focused ? _primary : _border),
        width: focused || invalid ? 2 : 1,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }
}

/// Values entered in the create-certificate dialog.
class DigitalSignatureCertificateCreation {
  const DigitalSignatureCertificateCreation({
    required this.commonName,
    this.country = '',
    this.state = '',
    this.locality = '',
    required this.organization,
    this.organizationalUnit = '',
    this.email = '',
    required this.password,
  });

  final String commonName;
  final String country;
  final String state;
  final String locality;
  final String organization;
  final String organizationalUnit;
  final String email;
  final String password;
}

/// Opens the small form used before [ComPDFKit.generatePkcs12Certificate].
Future<DigitalSignatureCertificateCreation?> showCreateCertificateDialog({
  required BuildContext context,
}) {
  return showDialog<DigitalSignatureCertificateCreation>(
    context: context,
    builder: (context) => const _CreateCertificateDialog(),
  );
}

class _CreateCertificateDialog extends StatefulWidget {
  const _CreateCertificateDialog();

  @override
  State<_CreateCertificateDialog> createState() =>
      _CreateCertificateDialogState();
}

class _CreateCertificateDialogState extends State<_CreateCertificateDialog> {
  final _commonNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _localityController = TextEditingController();
  final _organizationController = TextEditingController();
  final _unitController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _commonNameFocus = FocusNode();
  final _countryFocus = FocusNode();
  final _stateFocus = FocusNode();
  final _localityFocus = FocusNode();
  final _organizationFocus = FocusNode();
  final _unitFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  String? _errorText;

  @override
  void dispose() {
    _commonNameController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _localityController.dispose();
    _organizationController.dispose();
    _unitController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _commonNameFocus.dispose();
    _countryFocus.dispose();
    _stateFocus.dispose();
    _localityFocus.dispose();
    _organizationFocus.dispose();
    _unitFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _create() {
    final commonName = _commonNameController.text.trim();
    final organization = _organizationController.text.trim();
    final password = _passwordController.text;
    if (commonName.isEmpty) {
      setState(() => _errorText = 'Enter a common name.');
      return;
    }
    if (password.isEmpty) {
      setState(() => _errorText = 'Enter a certificate password.');
      return;
    }
    Navigator.of(context).pop(
      DigitalSignatureCertificateCreation(
        commonName: commonName,
        country: _countryController.text.trim(),
        state: _stateController.text.trim(),
        locality: _localityController.text.trim(),
        organization: organization,
        organizationalUnit: _unitController.text.trim(),
        email: _emailController.text.trim(),
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const fieldStyle = TextStyle(fontSize: 12);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final availableHeight =
        MediaQuery.sizeOf(context).height - viewInsets.bottom;
    return AlertDialog(
      title: const Text('Create certificate', style: TextStyle(fontSize: 18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      content: SizedBox(
        width: 420,
        height: (availableHeight * .68).clamp(260.0, 520.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const ValueKey('digital-signature-common-name'),
                controller: _commonNameController,
                focusNode: _commonNameFocus,
                style: fieldStyle,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _countryFocus.requestFocus(),
                decoration: const InputDecoration(
                  labelText: 'Common name',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 10),
              _CertificateField(
                  controller: _countryController,
                  focusNode: _countryFocus,
                  onSubmitted: (_) => _stateFocus.requestFocus(),
                  label: 'Country',
                  hint: 'US',
                  icon: Icons.flag_outlined),
              const SizedBox(height: 10),
              _CertificateField(
                  controller: _stateController,
                  focusNode: _stateFocus,
                  onSubmitted: (_) => _localityFocus.requestFocus(),
                  label: 'State / province',
                  icon: Icons.map_outlined),
              const SizedBox(height: 10),
              _CertificateField(
                  controller: _localityController,
                  focusNode: _localityFocus,
                  onSubmitted: (_) => _organizationFocus.requestFocus(),
                  label: 'Locality / city',
                  icon: Icons.location_city_outlined),
              const SizedBox(height: 10),
              TextField(
                controller: _organizationController,
                focusNode: _organizationFocus,
                style: fieldStyle,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _unitFocus.requestFocus(),
                decoration: const InputDecoration(
                  labelText: 'Organization (optional)',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
              ),
              const SizedBox(height: 10),
              _CertificateField(
                  controller: _unitController,
                  focusNode: _unitFocus,
                  onSubmitted: (_) => _emailFocus.requestFocus(),
                  label: 'Organizational unit',
                  icon: Icons.account_tree_outlined),
              const SizedBox(height: 10),
              _CertificateField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 10),
              TextField(
                key: const ValueKey('digital-signature-create-password'),
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: true,
                style: fieldStyle,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _create(),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _errorText!,
                    style: const TextStyle(color: _error, fontSize: 11),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _create,
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class _CertificateField extends StatelessWidget {
  const _CertificateField(
      {required this.controller,
      required this.focusNode,
      required this.onSubmitted,
      required this.label,
      required this.icon,
      this.hint,
      this.keyboardType});
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final String label;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        onSubmitted: onSubmitted,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
            labelText: label, hintText: hint, prefixIcon: Icon(icon)),
      );
}
