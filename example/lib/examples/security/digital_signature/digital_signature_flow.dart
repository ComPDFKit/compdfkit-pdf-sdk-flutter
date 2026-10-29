// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/signature/cpdf_certificate.dart';
import 'package:compdfkit_flutter/signature/cpdf_digital_signature.dart';

/// A certificate and its password kept only for the active signing flow.
///
/// The example never persists [password] and never uses it to build a file
/// name or log message.
class DigitalSignatureCertificateSession {
  const DigitalSignatureCertificateSession({
    required this.path,
    required this.password,
    this.info,
  });

  final String path;
  final String password;
  final CPDFCertificateInfo? info;

  String get fileName => path.split(Platform.pathSeparator).last;

  String get displayName {
    final subject = info?.subject;
    return subject == null || subject.isEmpty ? fileName : subject;
  }
}

/// Values collected by the signing Bottom Sheet.
class DigitalSignatureSheetResult {
  const DigitalSignatureSheetResult({
    required this.certificate,
    required this.name,
    required this.reason,
    required this.location,
    required this.permissions,
    required this.appearance,
    this.timestampServerUrl,
  });

  final DigitalSignatureCertificateSession certificate;
  final String name;
  final String reason;
  final String location;
  final CPDFSignaturePermission permissions;
  final CPDFDigitalSignatureAppearance appearance;

  /// RFC 3161 TSA URL, or `null` to sign without an embedded timestamp.
  final String? timestampServerUrl;
}

/// A signed field matched to its native document signature index.
class DigitalSignatureMatch {
  const DigitalSignatureMatch({
    required this.index,
    required this.info,
  });

  final int index;
  final CPDFDigitalSignatureInfo info;
}

/// Small, stateless rules shared by the Digital Signature example.
abstract final class DigitalSignatureFlow {
  /// Finds the signature metadata belonging to a tapped form widget.
  ///
  /// Field name and page are the primary identity. Bounds provide a fallback
  /// for documents whose native signature metadata uses a different field
  /// name representation.
  static DigitalSignatureMatch? findSignature(
    CPDFSignatureWidget widget,
    List<CPDFDigitalSignatureInfo> signatures,
  ) {
    for (var index = 0; index < signatures.length; index++) {
      final info = signatures[index];
      if (info.pageIndex != widget.page) {
        continue;
      }
      if (info.fieldName == widget.title) {
        return DigitalSignatureMatch(index: info.signatureIndex, info: info);
      }
    }

    for (var index = 0; index < signatures.length; index++) {
      final info = signatures[index];
      if (info.pageIndex == widget.page &&
          _sameBounds(info.bounds, widget.rect)) {
        return DigitalSignatureMatch(index: info.signatureIndex, info: info);
      }
    }
    return null;
  }

  /// Builds a unique output path inside the supplied directory.
  static String signedOutputPath(String directory, DateTime timestamp) {
    return '$directory${Platform.pathSeparator}signed_document_'
        '${timestamp.millisecondsSinceEpoch}.pdf';
  }

  /// Builds the output paths for adding LTV material to a signed PDF.
  ///
  /// The second path receives the copy with an appended document timestamp.
  static (String ltvPath, String ltaPath) ltvOutputPaths(
    String directory,
    DateTime timestamp,
  ) {
    final prefix = '$directory${Platform.pathSeparator}'
        'ltv_document_${timestamp.millisecondsSinceEpoch}';
    return ('$prefix.pdf', '${prefix}_lta.pdf');
  }

  /// Whether [value] can be used as an RFC 3161 TSA URL.
  static bool isTimestampServerUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// A readable label for the source of a signature's signing time.
  static String timestampSourceLabel(CPDFSignatureTimestampSource source) {
    switch (source) {
      case CPDFSignatureTimestampSource.none:
        return 'None';
      case CPDFSignatureTimestampSource.localClock:
        return 'Signer device clock';
      case CPDFSignatureTimestampSource.embedded:
        return 'Embedded RFC 3161 timestamp';
      case CPDFSignatureTimestampSource.document:
        return 'Document timestamp';
    }
  }

  static bool _sameBounds(dynamic first, dynamic second) {
    const tolerance = 1.5;
    return (first.left - second.left).abs() <= tolerance &&
        (first.top - second.top).abs() <= tolerance &&
        (first.right - second.right).abs() <= tolerance &&
        (first.bottom - second.bottom).abs() <= tolerance;
  }
}
