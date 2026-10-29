// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of '../certificate_management_example.dart';

/// Displays certificate metadata and keeps trust state synchronized in place.
class _CertificateDetailsPage extends StatefulWidget {
  const _CertificateDetailsPage({
    required this.session,
    required this.certificate,
    required this.onTrust,
  });

  final _CertificateSession session;
  final CPDFCertificateInfo certificate;
  final Future<CPDFCertificateInfo?> Function() onTrust;

  @override
  State<_CertificateDetailsPage> createState() =>
      _CertificateDetailsPageState();
}

class _CertificateDetailsPageState extends State<_CertificateDetailsPage> {
  late CPDFCertificateInfo _certificate;

  @override
  void initState() {
    super.initState();
    _certificate = widget.certificate;
  }

  Future<void> _trust() async {
    final updatedCertificate = await widget.onTrust();
    if (updatedCertificate != null && mounted) {
      setState(() => _certificate = updatedCertificate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = <String, String?>{
      'Subject': _certificate.subject,
      'Issuer': _certificate.issuer,
      'Serial Number': _certificate.serialNumber,
      'Version': _certificate.version,
      'Signature Algorithm': _certificate.signatureAlgorithm,
      'Valid From': _certificate.validFrom,
      'Valid To': _certificate.validTo,
      'SHA1 Digest': _certificate.sha1Digest,
      'MD5 Digest': _certificate.md5Digest,
      'Trusted status': _certificate.isTrusted ? 'Verified' : 'Not trusted',
    };
    return Scaffold(
      backgroundColor: _CertificateTheme.background,
      appBar: const _CertificateAppBar(
        title: 'Certificate details',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          _CertificateDetailsSummary(
            session: widget.session,
            certificate: _certificate,
            onChangeCertificate: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 16),
          _PencilPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const _MetadataHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
                  child: Column(
                    children: rows.entries
                        .map((entry) => _MetadataRow(
                              label: entry.key,
                              value: entry.value ?? '-',
                              copyable: entry.key.contains('digest') ||
                                  entry.key == 'Serial Number',
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!_certificate.isTrusted)
            _PrimaryButton(
              label: 'Add to trusted certificates',
              icon: Icons.verified_user_outlined,
              onPressed: _trust,
              height: 40,
              radius: 6,
            )
          else
            const _TrustedCertificateState(),
        ],
      ),
    );
  }
}
