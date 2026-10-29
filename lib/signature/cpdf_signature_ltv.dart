// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// One error or warning reported by the native signature and LTV services.
///
/// [code] is the native core identifier, such as
/// `pades.lt.auto.chain_untrusted` or `timestamp.transport.failed`.
///
/// example:
/// ```dart
/// for (final issue in result.errors) {
///   print('${issue.code}: ${issue.message}');
/// }
/// ```
///
/// Since 3.2.0.
class CPDFSignatureIssue {
  const CPDFSignatureIssue({
    required this.code,
    this.message = '',
  });

  final String code;
  final String message;

  factory CPDFSignatureIssue.fromJson(Map<String, dynamic> json) {
    return CPDFSignatureIssue(
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  @override
  String toString() => message.isEmpty ? code : '$code: $message';
}

/// The long-term validation (LTV) material a document currently carries.
///
/// This inspects the document's DSS / VRI dictionaries. It does not establish
/// certificate trust or prove that every signature meets PAdES-LT.
///
/// example:
/// ```dart
/// final readiness = await document.getLtvReadiness();
/// if (!readiness.ltvReady) {
///   print('Missing: ${readiness.missingMaterials.join(', ')}');
/// }
/// ```
///
/// Since 3.2.0.
class CPDFLtvReadiness {
  const CPDFLtvReadiness({
    this.success = false,
    this.hasDss = false,
    this.hasVri = false,
    this.hasCertificates = false,
    this.hasRevocation = false,
    this.ltvReady = false,
    this.profileHint = '',
    this.missingMaterials = const <String>[],
    this.certificatesCount = 0,
    this.ocspResponsesCount = 0,
    this.crlsCount = 0,
    this.vriEntriesCount = 0,
    this.errors = const <CPDFSignatureIssue>[],
    this.warnings = const <CPDFSignatureIssue>[],
  });

  /// Whether the native readiness assessment completed.
  final bool success;
  final bool hasDss;
  final bool hasVri;
  final bool hasCertificates;

  /// Whether OCSP or CRL revocation evidence is present and validated.
  final bool hasRevocation;

  /// Whether the document carries enough LTV material.
  final bool ltvReady;

  /// A short native classification, such as `PAdES-LT-candidate` or `no-DSS`.
  final String profileHint;

  /// Human-readable descriptions of the missing LTV material.
  final List<String> missingMaterials;

  /// Certificates in the document-level DSS arrays.
  final int certificatesCount;

  /// OCSP responses in the document-level DSS arrays.
  final int ocspResponsesCount;

  /// CRLs in the document-level DSS arrays.
  final int crlsCount;

  /// VRI entries in the DSS dictionary.
  final int vriEntriesCount;
  final List<CPDFSignatureIssue> errors;
  final List<CPDFSignatureIssue> warnings;

  factory CPDFLtvReadiness.fromJson(Map<String, dynamic> json) {
    final rawDss = json['dss'];
    final dss = rawDss is Map
        ? Map<String, dynamic>.from(rawDss)
        : const <String, dynamic>{};
    return CPDFLtvReadiness(
      success: json['success'] == true,
      hasDss: json['has_dss'] == true,
      hasVri: json['has_vri'] == true,
      hasCertificates: json['has_certificates'] == true,
      hasRevocation: json['has_revocation'] == true,
      ltvReady: json['ltv_ready'] == true,
      profileHint: json['profile_hint']?.toString() ?? '',
      missingMaterials: _parseStrings(json['missing_materials']),
      certificatesCount: _parseInt(dss['certificates_count']),
      ocspResponsesCount: _parseInt(dss['ocsp_responses_count']),
      crlsCount: _parseInt(dss['crls_count']),
      vriEntriesCount: _parseInt(dss['vri_entries_count']),
      errors: _parseIssues(json['errors']),
      warnings: _parseIssues(json['warnings']),
    );
  }
}

/// Options for adding LTV material to the current signed document.
///
/// [trustedCertificatePath] is required: the native SDK must build the signer
/// certificate chain to a trusted root before it can collect validation
/// material.
///
/// example:
/// ```dart
/// const options = CPDFSignatureLtvOptions(
///   trustedCertificatePath: '/path/to/root.pem',
/// );
/// ```
///
/// Since 3.2.0.
class CPDFSignatureLtvOptions {
  const CPDFSignatureLtvOptions({
    required this.trustedCertificatePath,
    this.ocspUrls = const <String>[],
    this.crlUrls = const <String>[],
    this.appendDocumentTimestamp = false,
    this.timestampServerUrl,
    this.timestampOutputPath,
  });

  /// A PEM file containing the trust anchors for the signer certificate chain.
  final String trustedCertificatePath;

  /// OCSP responders to use instead of the URLs inside the certificates.
  final List<String> ocspUrls;

  /// CRL URLs to use instead of the distribution points inside the
  /// certificates.
  final List<String> crlUrls;

  /// Whether to append a document timestamp after the LTV material, producing
  /// a PAdES-LTA copy at [timestampOutputPath].
  final bool appendDocumentTimestamp;

  /// RFC 3161 TSA URL for the document timestamp. Required when
  /// [appendDocumentTimestamp] is `true`.
  final String? timestampServerUrl;

  /// Output path of the document-timestamped copy. Required when
  /// [appendDocumentTimestamp] is `true`.
  final String? timestampOutputPath;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'trusted_certificate_path': trustedCertificatePath,
        'ocsp_urls': ocspUrls,
        'crl_urls': crlUrls,
        'append_document_timestamp': appendDocumentTimestamp,
        if (timestampServerUrl != null)
          'timestamp_server_url': timestampServerUrl,
        if (timestampOutputPath != null) 'lta_output_path': timestampOutputPath,
      };
}

/// The outcome of adding LTV material to a signed document.
///
/// example:
/// ```dart
/// if (result.success) {
///   await document.open(result.finalPath);
/// } else {
///   print(result.errors.join('\n'));
/// }
/// ```
///
/// Since 3.2.0.
class CPDFSignatureLtvResult {
  const CPDFSignatureLtvResult({
    required this.success,
    this.ltvPath = '',
    this.ltaPath = '',
    this.errors = const <CPDFSignatureIssue>[],
    this.warnings = const <CPDFSignatureIssue>[],
  });

  final bool success;

  /// The copy carrying the DSS / VRI material. Empty when [success] is false.
  final String ltvPath;

  /// The document-timestamped copy. Empty unless a document timestamp was
  /// appended successfully.
  final String ltaPath;
  final List<CPDFSignatureIssue> errors;
  final List<CPDFSignatureIssue> warnings;

  /// The file to show the user: [ltaPath] when present, otherwise [ltvPath].
  String get finalPath => ltaPath.isNotEmpty ? ltaPath : ltvPath;

  factory CPDFSignatureLtvResult.fromJson(Map<String, dynamic> json) {
    final success = json['success'] == true;
    return CPDFSignatureLtvResult(
      success: success,
      ltvPath: success ? json['ltv_path']?.toString() ?? '' : '',
      ltaPath: success ? json['lta_path']?.toString() ?? '' : '',
      errors: _parseIssues(json['errors']),
      warnings: _parseIssues(json['warnings']),
    );
  }
}

List<CPDFSignatureIssue> _parseIssues(Object? value) {
  if (value is! List) {
    return const <CPDFSignatureIssue>[];
  }
  return value
      .whereType<Map>()
      .map((item) =>
          CPDFSignatureIssue.fromJson(Map<String, dynamic>.from(item)))
      .where((issue) => issue.code.isNotEmpty || issue.message.isNotEmpty)
      .toList();
}

List<String> _parseStrings(Object? value) {
  if (value is! List) {
    return const <String>[];
  }
  return value
      .where((item) => item != null)
      .map((item) => item.toString())
      .where((item) => item.isNotEmpty)
      .toList();
}

int _parseInt(Object? value) => value is num ? value.toInt() : 0;
