// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION AND DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of 'digital_signature_widgets.dart';

/// Shows metadata and verification state for a signed field.
Future<void> showDigitalSignatureInfoDialog({
  required BuildContext context,
  required CPDFDigitalSignatureInfo info,
  required CPDFDigitalSignatureVerificationResult? verification,
  CPDFLtvReadiness? ltvReadiness,
  Future<bool> Function()? onTrustCertificate,
  Future<String?> Function(bool appendDocumentTimestamp)? onAddLtv,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _DigitalSignatureInfoSheet(
      info: info,
      verification: verification,
      ltvReadiness: ltvReadiness,
      onTrustCertificate: onTrustCertificate,
      onAddLtv: onAddLtv,
    ),
  );
}

class _DigitalSignatureInfoSheet extends StatefulWidget {
  const _DigitalSignatureInfoSheet({
    required this.info,
    required this.verification,
    required this.ltvReadiness,
    required this.onTrustCertificate,
    required this.onAddLtv,
  });

  final CPDFDigitalSignatureInfo info;
  final CPDFDigitalSignatureVerificationResult? verification;
  final CPDFLtvReadiness? ltvReadiness;
  final Future<bool> Function()? onTrustCertificate;

  /// Adds LTV material; returns an error message, or `null` on success.
  final Future<String?> Function(bool appendDocumentTimestamp)? onAddLtv;

  @override
  State<_DigitalSignatureInfoSheet> createState() =>
      _DigitalSignatureInfoSheetState();
}

class _DigitalSignatureInfoSheetState
    extends State<_DigitalSignatureInfoSheet> {
  bool _trusting = false;
  String? _trustError;
  bool _addingLtv = false;
  bool _appendDocumentTimestamp = false;
  String? _ltvError;

  Future<void> _addLtv() async {
    final action = widget.onAddLtv;
    if (action == null || _addingLtv) {
      return;
    }
    setState(() {
      _addingLtv = true;
      _ltvError = null;
    });
    try {
      final error = await action(_appendDocumentTimestamp);
      if (!mounted) {
        return;
      }
      if (error == null) {
        Navigator.of(context).pop();
      } else {
        setState(() => _ltvError = error);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _ltvError = 'The LTV material could not be added.');
      }
    } finally {
      if (mounted) {
        setState(() => _addingLtv = false);
      }
    }
  }

  Future<void> _trustCertificate() async {
    final action = widget.onTrustCertificate;
    if (action == null || _trusting) {
      return;
    }
    setState(() {
      _trusting = true;
      _trustError = null;
    });
    try {
      final success = await action();
      if (!mounted) {
        return;
      }
      if (success) {
        Navigator.of(context).pop();
      } else {
        setState(() => _trustError = 'The certificate could not be trusted.');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _trustError = 'The certificate could not be trusted.');
      }
    } finally {
      if (mounted) {
        setState(() => _trusting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final certificate = _certificate(widget.info);
    final signer =
        widget.info.signers.isEmpty ? null : widget.info.signers.first;
    final status = widget.verification == null
        ? 'Verification unavailable'
        : widget.verification!.signatureValid &&
                widget.verification!.documentUnmodified
            ? 'Valid signature'
            : 'Review required';
    final statusColor = widget.verification == null
        ? _muted
        : widget.verification!.signatureValid &&
                widget.verification!.documentUnmodified
            ? const Color(0xFF16803C)
            : _error;
    final canTrustCertificate =
        widget.onTrustCertificate != null && certificate?.isTrusted != true;

    return Material(
      color: _background,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .78),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: _SheetHeader(
                title: 'Signature information',
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBanner(label: status, color: statusColor),
                    const SizedBox(height: 16),
                    _InfoRow(
                        label: 'Field', value: _display(widget.info.fieldName)),
                    _InfoRow(
                        label: 'Signer', value: _display(widget.info.name)),
                    _InfoRow(
                        label: 'Signed date',
                        value: _display(widget.info.date)),
                    _InfoRow(
                        label: 'Reason', value: _display(widget.info.reason)),
                    _InfoRow(
                        label: 'Location',
                        value: _display(widget.info.location)),
                    _InfoRow(
                      label: 'Permission',
                      value: _permissionLabel(widget.info.permissions),
                    ),
                    _InfoRow(
                        label: 'Filter', value: _display(widget.info.filter)),
                    _InfoRow(
                        label: 'SubFilter',
                        value: _display(widget.info.subFilter)),
                    const Divider(height: 24),
                    const Text(
                      'Certificate',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Subject',
                      value: _display(certificate?.subject),
                    ),
                    _InfoRow(
                      label: 'Issuer',
                      value: _display(certificate?.issuer),
                    ),
                    _InfoRow(
                      label: 'Valid to',
                      value: _display(certificate?.validTo),
                    ),
                    _InfoRow(
                      label: 'Trusted',
                      value: certificate == null
                          ? 'Unavailable'
                          : certificate.isTrusted
                              ? 'Yes'
                              : 'No',
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Verification',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    _VerificationRow(
                      label: 'Signature valid',
                      value: widget.verification?.signatureValid,
                    ),
                    _VerificationRow(
                      label: 'Document unmodified',
                      value: widget.verification?.documentUnmodified,
                    ),
                    _VerificationRow(
                      label: 'Certificate trusted',
                      value: widget.verification?.certificateTrusted,
                    ),
                    _VerificationRow(
                      label: 'Certificate not expired',
                      value: widget.verification == null
                          ? null
                          : !widget.verification!.certificateExpired,
                    ),
                    _VerificationRow(
                      label: 'Signer verified',
                      value: signer?.signatureVerified,
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Timestamp and LTV',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Signing time source',
                      value: widget.verification == null
                          ? 'Unavailable'
                          : DigitalSignatureFlow.timestampSourceLabel(
                              widget.verification!.timestampSource,
                            ),
                    ),
                    _VerificationRow(
                      label: 'Embedded timestamp valid',
                      value: widget.verification?.embeddedTimestampValid,
                    ),
                    _VerificationRow(
                      label: 'LTV enabled (document)',
                      value: widget.verification?.ltvEnabled,
                    ),
                    if (widget.ltvReadiness != null) ...[
                      _InfoRow(
                        label: 'DSS material',
                        value: 'certs ${widget.ltvReadiness!.certificatesCount}'
                            ', OCSP ${widget.ltvReadiness!.ocspResponsesCount}'
                            ', CRL ${widget.ltvReadiness!.crlsCount}'
                            ', VRI ${widget.ltvReadiness!.vriEntriesCount}',
                      ),
                      if (widget.ltvReadiness!.missingMaterials.isNotEmpty)
                        _InfoRow(
                          label: 'Missing LTV material',
                          value:
                              widget.ltvReadiness!.missingMaterials.join(', '),
                        ),
                    ],
                    if (widget.onAddLtv != null) ...[
                      const SizedBox(height: 8),
                      _AppearanceSwitch(
                        label: 'Also append a document timestamp (LTA)',
                        value: _appendDocumentTimestamp,
                        onChanged: _addingLtv
                            ? (_) {}
                            : (value) => setState(
                                () => _appendDocumentTimestamp = value),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Column(
                  children: [
                    if (_trustError != null)
                      _InlineError(message: _trustError!),
                    if (_ltvError != null) _InlineError(message: _ltvError!),
                    if (widget.onAddLtv != null) ...[
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _addingLtv ? null : _addLtv,
                          icon: const Icon(Icons.history_toggle_off, size: 17),
                          label: Text(
                            _addingLtv
                                ? 'Adding LTV...'
                                : 'Add LTV with a trusted root (PEM)',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close',
                                    style: TextStyle(fontSize: 13)))),
                        if (canTrustCertificate) ...[
                          const SizedBox(width: 10),
                          Expanded(
                              child: FilledButton.icon(
                                  onPressed:
                                      _trusting ? null : _trustCertificate,
                                  icon: const Icon(Icons.verified_user_outlined,
                                      size: 17),
                                  label: Text(
                                      _trusting
                                          ? 'Trusting...'
                                          : 'Trust certificate',
                                      style: const TextStyle(fontSize: 12)))),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static CPDFCertificateInfo? _certificate(CPDFDigitalSignatureInfo info) {
    for (final signer in info.signers) {
      if (signer.certificates.isNotEmpty) {
        return signer.certificates.first;
      }
    }
    return null;
  }

  static String _display(String? value) {
    return value == null || value.isEmpty ? 'Unavailable' : value;
  }

  static String _permissionLabel(CPDFSignaturePermission permission) {
    switch (permission) {
      case CPDFSignaturePermission.forbidChange:
        return 'No changes';
      case CPDFSignaturePermission.fillAndSign:
        return 'Fill and sign';
      case CPDFSignaturePermission.annotationFillAndSign:
        return 'Annotations, fill and sign';
    }
  }
}
