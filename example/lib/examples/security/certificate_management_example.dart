// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/app_toolbar.dart';

part 'certificate_management/certificate_details_page.dart';
part 'certificate_management/certificate_home_widgets.dart';
part 'certificate_management/certificate_form_widgets.dart';
part 'certificate_management/certificate_detail_widgets.dart';
part 'certificate_management/generate_certificate_page.dart';
part 'certificate_management/load_certificate_page.dart';

abstract final class _CertificateTheme {
  static const background = Color(0xFFF6F8FB);
  static const surface = Colors.white;
  static const primary = Color(0xFF1460F3);
  static const text = Color(0xFF1A1A1A);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const inputBorder = Color(0xFFD7DEE8);
  static const softBlue = Color(0xFFEAF2FF);
  static const softGreen = Color(0xFFE9F8EF);
  static const warning = Color(0xFFFFF7E8);
  static const information = Color(0xFFEEF5FF);
}

/// Demonstrates PKCS#12 certificate creation, loading, inspection and trust.
class CertificateManagementExample extends StatefulWidget {
  const CertificateManagementExample({super.key});

  @override
  State<CertificateManagementExample> createState() =>
      _CertificateManagementExampleState();
}

class _CertificateManagementExampleState
    extends State<CertificateManagementExample> {
  _CertificateSession? _session;
  CPDFCertificateInfo? _certificate;
  bool _verified = false;
  bool _busy = false;

  Future<void> _selectSource(bool generate) async {
    final session = await Navigator.of(context).push<_CertificateSession>(
      MaterialPageRoute(
        builder: (_) => generate
            ? const _GenerateCertificatePage()
            : const _LoadCertificatePage(),
      ),
    );
    if (session == null || !mounted) return;
    setState(() {
      _session = session;
      _certificate = null;
      _verified = false;
    });
    _showMessage(session.generated
        ? 'Certificate created. Unlock it to load metadata.'
        : 'Certificate selected. Unlock it to load metadata.');
  }

  Future<void> _unlockCertificate() async {
    final session = _session;
    if (session == null) return;
    await _run(() async {
      final valid = await ComPDFKit.checkPkcs12CertificatePassword(
        session.path,
        session.password,
      );
      if (!valid) {
        if (mounted) setState(() => _verified = false);
        _showMessage('Invalid certificate password.');
        return;
      }
      final certificate = await ComPDFKit.loadPkcs12Certificate(
        session.path,
        session.password,
      );
      if (!mounted) return;
      setState(() {
        _verified = certificate != null;
        _certificate = certificate;
      });
      _showMessage(certificate == null
          ? 'Unable to read certificate metadata.'
          : 'Certificate unlocked and metadata loaded.');
    });
  }

  Future<void> _openDetails() async {
    final session = _session;
    final certificate = _certificate;
    if (session == null || certificate == null) return;
    final updatedCertificate =
        await Navigator.of(context).push<CPDFCertificateInfo>(
      MaterialPageRoute(
        builder: (_) => _CertificateDetailsPage(
          session: session,
          certificate: certificate,
          onTrust: _trustCertificate,
        ),
      ),
    );
    if (updatedCertificate != null && mounted) {
      setState(() => _certificate = updatedCertificate);
    }
  }

  Future<CPDFCertificateInfo?> _trustCertificate() async {
    final session = _session;
    if (session == null) return null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trust this certificate?'),
        content: const Text(
          'This changes certificate verification behavior for this application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.verified_user_outlined),
            label: const Text('Add to trusted certificates'),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    CPDFCertificateInfo? updatedCertificate;
    await _run(() async {
      final trusted = await ComPDFKit.addTrustedCertificate(
        session.path,
        session.password,
      );
      if (trusted) {
        updatedCertificate = await ComPDFKit.loadPkcs12Certificate(
          session.path,
          session.password,
        );
        if (updatedCertificate == null) {
          _showMessage(
              'Certificate was trusted, but metadata could not be refreshed.');
          return;
        }
        if (mounted) setState(() => _certificate = updatedCertificate);
      }
      _showMessage(trusted
          ? 'Certificate added to the application trust store.'
          : 'Failed to add certificate to the trust store.');
    });
    return updatedCertificate;
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on PlatformException catch (error) {
      _showMessage(error.message ?? error.code);
    } catch (error) {
      _showMessage('Operation failed: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    return Scaffold(
      backgroundColor: _CertificateTheme.background,
      appBar: const _CertificateAppBar(
        title: 'Certificate Management',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          const _SectionHeader(
            title: 'Certificate source',
            description:
                'Generate a development certificate or load a PKCS#12 file.',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SourceAction(
                  icon: Icons.add_card_outlined,
                  title: 'Generate',
                  subtitle: 'Development PKCS#12',
                  onTap: _busy ? null : () => _selectSource(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SourceAction(
                  icon: Icons.folder_open_outlined,
                  title: 'Choose existing',
                  subtitle: '.p12 or .pfx file',
                  onTap: _busy ? null : () => _selectSource(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionHeader(title: 'Current certificate'),
          const SizedBox(height: 12),
          _CurrentCertificateCard(
            session: session,
            verified: _verified,
            certificate: _certificate,
          ),
          const SizedBox(height: 20),
          const _SectionHeader(title: 'Certificate actions'),
          const SizedBox(height: 12),
          _ActionList(
            enabled: session != null && !_busy,
            detailsEnabled: _certificate != null && !_busy,
            onUnlock: _unlockCertificate,
            onDetails: _openDetails,
            onTrust: _certificate != null && !_certificate!.isTrusted
                ? _openDetails
                : null,
          ),
          const SizedBox(height: 20),
          const _SectionHeader(title: 'Platform storage'),
          const SizedBox(height: 12),
          const _PlatformStorageCard(),
        ],
      ),
    );
  }
}
