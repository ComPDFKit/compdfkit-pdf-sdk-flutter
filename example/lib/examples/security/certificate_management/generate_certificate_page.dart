// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of '../certificate_management_example.dart';

/// Collects development certificate identity data and creates a PKCS#12 file.
class _GenerateCertificatePage extends StatefulWidget {
  const _GenerateCertificatePage();

  @override
  State<_GenerateCertificatePage> createState() =>
      _GenerateCertificatePageState();
}

class _GenerateCertificatePageState extends State<_GenerateCertificatePage> {
  final _commonName = TextEditingController(text: 'ComPDF Flutter QA');
  final _organization = TextEditingController(text: 'PDF Technologies');
  final _password = TextEditingController();
  final _country = TextEditingController();
  final _state = TextEditingController();
  final _locality = TextEditingController();
  final _unit = TextEditingController();
  final _email = TextEditingController();
  final _commonNameFocus = FocusNode();
  final _organizationFocus = FocusNode();
  final _countryFocus = FocusNode();
  final _stateFocus = FocusNode();
  final _localityFocus = FocusNode();
  final _unitFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _showAdvanced = false;
  bool _busy = false;
  bool _appliedLocaleDefaults = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appliedLocaleDefaults) return;
    _appliedLocaleDefaults = true;
    _country.text = Localizations.localeOf(context).countryCode ?? '';
  }

  @override
  void dispose() {
    for (final controller in [
      _commonName,
      _organization,
      _password,
      _country,
      _state,
      _locality,
      _unit,
      _email,
    ]) {
      controller.dispose();
    }
    for (final focusNode in [
      _commonNameFocus,
      _organizationFocus,
      _countryFocus,
      _stateFocus,
      _localityFocus,
      _unitFocus,
      _emailFocus,
      _passwordFocus,
    ]) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _generate() async {
    if (_commonName.text.trim().isEmpty || _password.text.isEmpty) {
      _showMessage('Common name and password are required.');
      return;
    }
    setState(() => _busy = true);
    try {
      final directory = await ComPDFKit.getTemporaryDirectory();
      final path = '${directory.path}/compdf-flutter-development.p12';
      final success = await ComPDFKit.generatePkcs12Certificate(
        CPDFCertificateRequest(
          subject: CPDFCertificateSubject(
            commonName: _commonName.text.trim(),
            organization: _value(_organization),
            country: _value(_country),
            state: _value(_state),
            locality: _value(_locality),
            organizationalUnit: _value(_unit),
            email: _value(_email),
          ),
          password: _password.text,
          outputPath: path,
        ),
      );
      if (!mounted) return;
      if (!success) {
        _showMessage('Certificate creation failed.');
        return;
      }
      Navigator.of(context).pop(
        _CertificateSession(
            path: path, password: _password.text, generated: true),
      );
    } on PlatformException catch (error) {
      _showMessage(error.message ?? error.code);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String? _value(TextEditingController controller) =>
      controller.text.trim().isEmpty ? null : controller.text.trim();

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _CertificateTheme.background,
      appBar: const _CertificateAppBar(
        title: 'Generate certificate',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          const _SectionHeader(
            title: 'Certificate identity',
            description:
                'Use a development certificate for integration and signature testing. Do not use this flow for production credentials.',
          ),
          const SizedBox(height: 20),
          _CertificateFormCard(
            commonName: _commonName,
            organization: _organization,
            password: _password,
            country: _country,
            state: _state,
            locality: _locality,
            unit: _unit,
            email: _email,
            commonNameFocus: _commonNameFocus,
            organizationFocus: _organizationFocus,
            countryFocus: _countryFocus,
            stateFocus: _stateFocus,
            localityFocus: _localityFocus,
            unitFocus: _unitFocus,
            emailFocus: _emailFocus,
            passwordFocus: _passwordFocus,
            showAdvanced: _showAdvanced,
            onAdvancedChanged: () =>
                setState(() => _showAdvanced = !_showAdvanced),
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            label: 'Generate certificate',
            icon: Icons.add_card_outlined,
            onPressed: _busy ? null : _generate,
            busy: _busy,
            height: 48,
          ),
          const SizedBox(height: 20),
          const _InlineNote(
            icon: Icons.shield_outlined,
            text:
                'The password is used only for this operation and is not stored.',
          ),
        ],
      ),
    );
  }
}
