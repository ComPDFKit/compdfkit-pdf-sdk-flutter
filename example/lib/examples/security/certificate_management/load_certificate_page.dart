// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of '../certificate_management_example.dart';

/// Selects and validates an existing PKCS#12 certificate before use.
class _LoadCertificatePage extends StatefulWidget {
  const _LoadCertificatePage();

  @override
  State<_LoadCertificatePage> createState() => _LoadCertificatePageState();
}

class _LoadCertificatePageState extends State<_LoadCertificatePage> {
  final _path = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _busy = false;
  String? _passwordError;

  @override
  void dispose() {
    _path.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _browse() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['p12', 'pfx'],
    );
    final path = result?.files.singleOrNull?.path;
    if (path != null) setState(() => _path.text = path);
  }

  Future<void> _load() async {
    if (_path.text.trim().isEmpty || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Select a certificate and enter its password.')),
      );
      return;
    }
    setState(() {
      _busy = true;
      _passwordError = null;
    });
    try {
      final valid = await ComPDFKit.checkPkcs12CertificatePassword(
        _path.text.trim(),
        _password.text,
      );
      if (!mounted) return;
      if (!valid) {
        setState(() => _passwordError = 'Incorrect PKCS#12 password.');
        _passwordFocus.requestFocus();
        return;
      }
      Navigator.of(context).pop(
        _CertificateSession(path: _path.text.trim(), password: _password.text),
      );
    } on PlatformException catch (error) {
      if (mounted) {
        setState(() => _passwordError = error.message ?? error.code);
        _passwordFocus.requestFocus();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _CertificateTheme.background,
      appBar: const _CertificateAppBar(
        title: 'Choose certificate',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          const _SectionHeader(
            title: 'Load certificate',
            description:
                'Choose a .p12 or .pfx file, then unlock it from the main workflow.',
          ),
          const SizedBox(height: 16),
          _PencilPanel(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _CertificateTextField(
                  controller: _path,
                  label: 'Certificate file',
                  hintText: 'No file selected',
                  readOnly: true,
                  prefixIcon: Icons.file_present_outlined,
                  suffix: IconButton(
                    tooltip: 'Browse files',
                    onPressed: _browse,
                    icon: const Icon(Icons.folder_open_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                _CertificateTextField(
                  controller: _password,
                  label: 'PKCS#12 password',
                  errorText: _passwordError,
                  obscureText: _obscurePassword,
                  focusNode: _passwordFocus,
                  prefixIcon: Icons.key_outlined,
                  suffix: IconButton(
                    tooltip:
                        _obscurePassword ? 'Show password' : 'Hide password',
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            label: 'Use certificate',
            icon: Icons.file_open_outlined,
            busy: _busy,
            onPressed: _busy ? null : _load,
          ),
        ],
      ),
    );
  }
}
