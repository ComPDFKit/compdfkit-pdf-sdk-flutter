// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

import 'cpdf_certificate.dart';

/// The document changes allowed after applying a digital signature.
///
/// example:
/// ```dart
/// const permission = CPDFSignaturePermission.fillAndSign;
/// ```
enum CPDFSignaturePermission {
  forbidChange(1),
  fillAndSign(2),
  annotationFillAndSign(3);

  const CPDFSignaturePermission(this.value);

  final int value;

  static CPDFSignaturePermission fromValue(Object? value) {
    final numericValue = value is num ? value.toInt() : null;
    return values.firstWhere(
      (permission) => permission.value == numericValue,
      orElse: () => CPDFSignaturePermission.forbidChange,
    );
  }
}

/// Where the signing time of a digital signature comes from.
///
/// example:
/// ```dart
/// final result = await document.verifyDigitalSignature(0);
/// if (result.timestampSource == CPDFSignatureTimestampSource.embedded) {
///   print('The signature contains an embedded RFC 3161 timestamp.');
/// }
/// ```
///
/// Since 3.2.0.
enum CPDFSignatureTimestampSource {
  /// The signature has no signing time information.
  none(0),

  /// The signing time comes from the signer's local clock.
  localClock(1),

  /// The signature contains an embedded RFC 3161 timestamp token.
  embedded(2),

  /// The signature itself is a document timestamp.
  document(3);

  const CPDFSignatureTimestampSource(this.value);

  final int value;

  static CPDFSignatureTimestampSource fromValue(Object? value) {
    final numericValue = value is num ? value.toInt() : null;
    return values.firstWhere(
      (source) => source.value == numericValue,
      orElse: () => CPDFSignatureTimestampSource.none,
    );
  }
}

/// Appearance settings used when writing a digital signature.
///
/// example:
/// ```dart
/// const appearance = CPDFDigitalSignatureAppearance(
///   text: 'Signed by ComPDF Flutter',
///   content: 'Approved document',
/// );
/// ```
class CPDFDigitalSignatureAppearance {
  const CPDFDigitalSignatureAppearance({
    this.text = '',
    this.content = '',
    this.textColor = const Color(0xFF000000),
    this.contentColor = const Color(0xFF000000),
    this.logoPath,
    this.imagePath,
    this.drawLogo = true,
    this.drawOnlyContent = false,
    this.contentAlignLeft = true,
  });

  final String text;
  final String content;
  final Color textColor;
  final Color contentColor;
  final String? logoPath;
  final String? imagePath;
  final bool drawLogo;
  final bool drawOnlyContent;
  final bool contentAlignLeft;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
        'content': content,
        'text_color': textColor.toHex(),
        'content_color': contentColor.toHex(),
        if (logoPath != null) 'logo_path': logoPath,
        if (imagePath != null) 'image_path': imagePath,
        'draw_logo': drawLogo,
        'draw_only_content': drawOnlyContent,
        'content_align_left': contentAlignLeft,
      };

  factory CPDFDigitalSignatureAppearance.fromJson(Map<String, dynamic> json) {
    return CPDFDigitalSignatureAppearance(
      text: json['text'] as String? ?? '',
      content: json['content'] as String? ?? '',
      textColor: _parseColor(json['text_color']),
      contentColor: _parseColor(json['content_color']),
      logoPath: json['logo_path'] as String?,
      imagePath: json['image_path'] as String?,
      drawLogo: json['draw_logo'] as bool? ?? true,
      drawOnlyContent: json['draw_only_content'] as bool? ?? false,
      contentAlignLeft: json['content_align_left'] as bool? ?? true,
    );
  }
}

/// Configuration for writing a digital signature to a new PDF file.
///
/// The certificate password is sent only for the signing call. Do not log or
/// persist it in application metadata.
///
/// example:
/// ```dart
/// final config = CPDFDigitalSignatureConfig(
///   certificatePath: certificatePath,
///   password: certificatePassword,
///   reason: 'Approved document',
///   location: 'Example app',
///   permissions: CPDFSignaturePermission.fillAndSign,
///   timestampServerUrl: 'http://timestamp.digicert.com',
/// );
/// ```
class CPDFDigitalSignatureConfig {
  const CPDFDigitalSignatureConfig({
    required this.certificatePath,
    required this.password,
    this.reason,
    this.location,
    this.name,
    this.permissions = CPDFSignaturePermission.fillAndSign,
    this.appearance = const CPDFDigitalSignatureAppearance(),
    this.timestampServerUrl,
  });

  final String certificatePath;
  final String password;
  final String? reason;
  final String? location;
  final String? name;
  final CPDFSignaturePermission permissions;
  final CPDFDigitalSignatureAppearance appearance;

  /// RFC 3161 timestamp authority (TSA) URL, using `http` or `https`.
  ///
  /// When set, the signature embeds a timestamp issued by the TSA. Signing
  /// requires network access and fails if the TSA cannot be reached or rejects
  /// the request; no signature without the requested timestamp is written.
  /// On iOS the request goes through `NSURLSession`, so plain `http` endpoints
  /// need an App Transport Security exception in the host app.
  ///
  /// Since 3.2.0.
  final String? timestampServerUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'certificate_path': certificatePath,
        'password': password,
        if (reason != null) 'reason': reason,
        if (location != null) 'location': location,
        if (name != null) 'name': name,
        'permissions': permissions.value,
        'appearance': appearance.toJson(),
        if (timestampServerUrl != null)
          'timestamp_server_url': timestampServerUrl,
      };
}

/// Certificate information associated with a PDF signer.
///
/// example:
/// ```dart
/// for (final signer in signature.signers) {
///   print('Verified: ${signer.signatureVerified}');
///   print('Trusted: ${signer.certificateTrusted}');
/// }
/// ```
class CPDFDigitalSignatureSignerInfo {
  const CPDFDigitalSignatureSignerInfo({
    required this.signatureVerified,
    required this.certificateTrusted,
    this.certificates = const <CPDFCertificateInfo>[],
  });

  final bool signatureVerified;
  final bool certificateTrusted;
  final List<CPDFCertificateInfo> certificates;

  factory CPDFDigitalSignatureSignerInfo.fromJson(Map<String, dynamic> json) {
    final rawCertificates = json['certificates'];
    return CPDFDigitalSignatureSignerInfo(
      signatureVerified: json['signature_verified'] == true,
      certificateTrusted: json['certificate_trusted'] == true,
      certificates: rawCertificates is List
          ? rawCertificates
              .whereType<Map>()
              .map(
                (item) => CPDFCertificateInfo.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const <CPDFCertificateInfo>[],
    );
  }
}

/// Describes a document modification reported by a signed PDF.
///
/// example:
/// ```dart
/// for (final modification in signature.modifications) {
///   print('${modification.type} on page ${modification.pageIndex}');
/// }
/// ```
class CPDFDigitalSignatureModificationInfo {
  const CPDFDigitalSignatureModificationInfo({
    required this.type,
    this.pageIndex,
    this.annotationType,
    this.formType,
    this.info,
  });

  final String type;
  final int? pageIndex;
  final int? annotationType;
  final int? formType;
  final String? info;

  factory CPDFDigitalSignatureModificationInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    return CPDFDigitalSignatureModificationInfo(
      type: json['type']?.toString() ?? 'unknown',
      pageIndex: (json['page_index'] as num?)?.toInt(),
      annotationType: (json['annotation_type'] as num?)?.toInt(),
      formType: (json['form_type'] as num?)?.toInt(),
      info: json['info'] as String?,
    );
  }
}

/// Information read from one digital signature in a PDF document.
///
/// example:
/// ```dart
/// final signatures = await document.getDigitalSignatures();
/// final signature = signatures.first;
/// print('${signature.fieldName} on page ${signature.pageIndex + 1}');
/// ```
class CPDFDigitalSignatureInfo {
  const CPDFDigitalSignatureInfo({
    this.signatureIndex = -1,
    required this.fieldName,
    required this.pageIndex,
    required this.bounds,
    required this.permissions,
    this.name,
    this.date,
    this.reason,
    this.location,
    this.filter,
    this.subFilter,
    this.signers = const <CPDFDigitalSignatureSignerInfo>[],
    this.modifications = const <CPDFDigitalSignatureModificationInfo>[],
  });

  /// Native document index used with `CPDFDocument.verifyDigitalSignature`.
  ///
  /// This can differ from the item's position in `getDigitalSignatures()` when
  /// a document contains an unreadable signature entry.
  final int signatureIndex;

  final String fieldName;
  final int pageIndex;
  final CPDFRectF bounds;
  final String? name;
  final String? date;
  final String? reason;
  final String? location;
  final String? filter;
  final String? subFilter;
  final CPDFSignaturePermission permissions;
  final List<CPDFDigitalSignatureSignerInfo> signers;
  final List<CPDFDigitalSignatureModificationInfo> modifications;

  factory CPDFDigitalSignatureInfo.fromJson(Map<String, dynamic> json) {
    final rawSigners = json['signers'];
    final rawModifications = json['modifications'];
    return CPDFDigitalSignatureInfo(
      signatureIndex: (json['signature_index'] as num?)?.toInt() ?? -1,
      fieldName: json['field_name'] as String? ?? '',
      pageIndex: (json['page_index'] as num?)?.toInt() ?? -1,
      bounds: CPDFRectF.fromJson(
        Map<String, dynamic>.from(json['bounds'] as Map? ?? const {}),
      ),
      name: json['name'] as String?,
      date: _parseSignatureDate(json['date']),
      reason: json['reason'] as String?,
      location: json['location'] as String?,
      filter: json['filter'] as String?,
      subFilter: json['sub_filter'] as String?,
      permissions: CPDFSignaturePermission.fromValue(json['permissions']),
      signers: rawSigners is List
          ? rawSigners
              .whereType<Map>()
              .map(
                (item) => CPDFDigitalSignatureSignerInfo.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const <CPDFDigitalSignatureSignerInfo>[],
      modifications: rawModifications is List
          ? rawModifications
              .whereType<Map>()
              .map(
                (item) => CPDFDigitalSignatureModificationInfo.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const <CPDFDigitalSignatureModificationInfo>[],
    );
  }
}

/// Verification results for one digital signature.
///
/// example:
/// ```dart
/// final result = await document.verifyDigitalSignature(0);
/// print('Valid: ${result.signatureValid}');
/// print('Unmodified: ${result.documentUnmodified}');
/// print('Timestamp: ${result.timestampTrusted ?? 'Unavailable'}');
/// print('Embedded timestamp: ${result.embeddedTimestampValid}');
/// print('LTV enabled: ${result.ltvEnabled}');
/// ```
class CPDFDigitalSignatureVerificationResult {
  const CPDFDigitalSignatureVerificationResult({
    required this.signatureValid,
    required this.documentUnmodified,
    required this.certificateTrusted,
    required this.certificateExpired,
    this.timestampTrusted,
    this.timestampSource = CPDFSignatureTimestampSource.none,
    this.embeddedTimestampValid,
    this.ltvEnabled = false,
  });

  final bool signatureValid;
  final bool documentUnmodified;
  final bool certificateTrusted;
  final bool certificateExpired;

  /// Whether the timestamp authority is trusted by the native SDK.
  ///
  /// This checks the TSA certificate trust, so it can be `false` for a
  /// cryptographically valid embedded timestamp. Use [embeddedTimestampValid]
  /// to check the embedded timestamp itself.
  final bool? timestampTrusted;

  /// Where this signature's signing time comes from.
  ///
  /// Since 3.2.0.
  final CPDFSignatureTimestampSource timestampSource;

  /// Whether the signature contains an embedded RFC 3161 timestamp that passed
  /// validation, or `null` when no validation report is available.
  ///
  /// Since 3.2.0.
  final bool? embeddedTimestampValid;

  /// Whether the document carries long-term validation (LTV) material.
  ///
  /// This is a document-level result: every signature in the same document
  /// reports the same value. It checks that the DSS dictionary contains VRI
  /// entries and OCSP or CRL revocation evidence; it is not a full PAdES-LT
  /// validation verdict. Use `CPDFDocument.getLtvReadiness()` for details.
  ///
  /// Since 3.2.0.
  final bool ltvEnabled;

  factory CPDFDigitalSignatureVerificationResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return CPDFDigitalSignatureVerificationResult(
      signatureValid: json['signature_valid'] == true,
      documentUnmodified: json['document_unmodified'] == true,
      certificateTrusted: json['certificate_trusted'] == true,
      certificateExpired: json['certificate_expired'] == true,
      timestampTrusted: json['timestamp_trusted'] as bool?,
      timestampSource: CPDFSignatureTimestampSource.fromValue(
        json['timestamp_source'],
      ),
      embeddedTimestampValid: json['embedded_timestamp_valid'] as bool?,
      ltvEnabled: json['ltv_enabled'] == true,
    );
  }
}

Color _parseColor(Object? value) {
  if (value is! String || value.isEmpty) {
    return const Color(0xFF000000);
  }
  try {
    return HexColor.fromHex(value);
  } on FormatException {
    return const Color(0xFF000000);
  }
}

String? _parseSignatureDate(Object? value) {
  if (value is! String || value.isEmpty) {
    return null;
  }
  final normalizedValue = value.replaceFirst(' ', 'T');
  final hasTimeZone =
      RegExp(r'(Z|[+-]\d{2}:?\d{2})$').hasMatch(normalizedValue);
  final isoDate = DateTime.tryParse(
    hasTimeZone ? normalizedValue : '${normalizedValue}Z',
  );
  if (isoDate != null) {
    return isoDate.toUtc().toIso8601String();
  }

  final pdfDate = RegExp(
    r"^D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(?:(Z)|([+-])(\d{2})'?((?:\d{2}))'?)?$",
  ).firstMatch(value);
  if (pdfDate == null) {
    return null;
  }
  final date = DateTime.utc(
    int.parse(pdfDate.group(1)!),
    int.parse(pdfDate.group(2)!),
    int.parse(pdfDate.group(3)!),
    int.parse(pdfDate.group(4)!),
    int.parse(pdfDate.group(5)!),
    int.parse(pdfDate.group(6)!),
  );
  final sign = pdfDate.group(8);
  if (sign == null) {
    return date.toIso8601String();
  }
  final offset = Duration(
    hours: int.parse(pdfDate.group(9)!),
    minutes: int.parse(pdfDate.group(10)!),
  );
  return (sign == '+' ? date.subtract(offset) : date.add(offset))
      .toIso8601String();
}
