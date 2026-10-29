// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Certificate usage supported by ComPDFKit.
///
/// example:
/// ```dart
/// const usage = CPDFCertificateUsage.digitalSignature;
/// ```
enum CPDFCertificateUsage {
  digitalSignature(1),
  dataEncryption(2),
  all(3);

  const CPDFCertificateUsage(this.value);

  final int value;
}

/// Subject fields used when generating a PKCS#12 certificate.
///
/// example:
/// ```dart
/// const subject = CPDFCertificateSubject(
///   commonName: 'ComPDF Flutter QA',
///   organization: 'PDF Technologies',
/// );
/// ```
class CPDFCertificateSubject {
  const CPDFCertificateSubject({
    this.country,
    this.state,
    this.locality,
    this.organization,
    this.organizationalUnit,
    required this.commonName,
    this.email,
  });

  final String? country;
  final String? state;
  final String? locality;
  final String? organization;
  final String? organizationalUnit;
  final String commonName;
  final String? email;

  Map<String, String> toJson() => <String, String>{
        if (country != null) 'country': country!,
        if (state != null) 'state': state!,
        if (locality != null) 'locality': locality!,
        if (organization != null) 'organization': organization!,
        if (organizationalUnit != null)
          'organizational_unit': organizationalUnit!,
        'common_name': commonName,
        if (email != null) 'email': email!,
      };
}

/// Request for creating a PKCS#12 certificate.
///
/// example:
/// ```dart
/// const request = CPDFCertificateRequest(
///   subject: CPDFCertificateSubject(commonName: 'ComPDF Flutter QA'),
///   password: 'certificate-password',
///   outputPath: '/path/to/qa-certificate.p12',
/// );
/// ```
class CPDFCertificateRequest {
  const CPDFCertificateRequest({
    required this.subject,
    required this.password,
    required this.outputPath,
    this.usage = CPDFCertificateUsage.digitalSignature,
  });

  final CPDFCertificateSubject subject;
  final String password;
  final String outputPath;
  final CPDFCertificateUsage usage;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'subject': subject.toJson(),
        'password': password,
        'output_path': outputPath,
        'usage': usage.value,
      };
}

/// Public certificate metadata returned by the native SDK.
///
/// example:
/// ```dart
/// final certificate = await ComPDFKit.loadPkcs12Certificate(
///   '/path/to/certificate.p12',
///   'certificate-password',
/// );
/// print(certificate?.subject);
/// ```
class CPDFCertificateInfo {
  const CPDFCertificateInfo({
    this.version,
    this.serialNumber,
    this.keyType,
    this.signatureAlgorithm,
    this.issuer,
    this.subject,
    this.validFrom,
    this.validTo,
    this.sha1Digest,
    this.md5Digest,
    this.isTrusted = false,
  });

  final String? version;
  final String? serialNumber;
  final String? keyType;
  final String? signatureAlgorithm;
  final String? issuer;
  final String? subject;
  final String? validFrom;
  final String? validTo;
  final String? sha1Digest;
  final String? md5Digest;
  final bool isTrusted;

  factory CPDFCertificateInfo.fromJson(Map<String, dynamic> json) {
    return CPDFCertificateInfo(
      version: json['version'] as String?,
      serialNumber: json['serial_number'] as String?,
      keyType: json['key_type']?.toString(),
      signatureAlgorithm: json['signature_algorithm'] as String?,
      issuer: json['issuer'] as String?,
      subject: json['subject'] as String?,
      validFrom: json['valid_from'] as String?,
      validTo: json['valid_to'] as String?,
      sha1Digest: json['sha1_digest'] as String?,
      md5Digest: json['md5_digest'] as String?,
      isTrusted: json['is_trusted'] == true,
    );
  }
}
