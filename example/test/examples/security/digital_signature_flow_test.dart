// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/signature/cpdf_digital_signature.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:compdfkit_flutter_example/examples/security/digital_signature/digital_signature_flow.dart';

void main() {
  final widget = CPDFSignatureWidget(
    title: 'Approval',
    page: 0,
    rect: const CPDFRectF(left: 10, top: 80, right: 120, bottom: 20),
    borderColor: Colors.black,
    fillColor: Colors.white,
    uuid: 'widget',
  );

  test('matches a signed field by field name and page', () {
    final match = DigitalSignatureFlow.findSignature(
      widget,
      [
        CPDFDigitalSignatureInfo(
          signatureIndex: 4,
          fieldName: 'Approval',
          pageIndex: 0,
          bounds: const CPDFRectF(
            left: 10,
            top: 80,
            right: 120,
            bottom: 20,
          ),
          permissions: CPDFSignaturePermission.fillAndSign,
        ),
      ],
    );

    expect(match?.index, 4);
    expect(match?.info.fieldName, 'Approval');
  });

  test('falls back to field bounds when the native name differs', () {
    final match = DigitalSignatureFlow.findSignature(
      widget,
      [
        CPDFDigitalSignatureInfo(
          signatureIndex: 3,
          fieldName: 'NativeSignatureName',
          pageIndex: 0,
          bounds: const CPDFRectF(
            left: 10.4,
            top: 79.7,
            right: 120.2,
            bottom: 20.1,
          ),
          permissions: CPDFSignaturePermission.fillAndSign,
        ),
      ],
    );

    expect(match?.index, 3);
  });

  test('builds a signed output path without certificate secrets', () {
    final path = DigitalSignatureFlow.signedOutputPath(
      '/tmp/digital_signature',
      DateTime.fromMillisecondsSinceEpoch(123456789),
    );

    expect(path, '/tmp/digital_signature/signed_document_123456789.pdf');
    expect(path, isNot(contains('password')));
  });

  test('builds separate LTV and LTA output paths', () {
    final (ltvPath, ltaPath) = DigitalSignatureFlow.ltvOutputPaths(
      '/tmp/digital_signature',
      DateTime.fromMillisecondsSinceEpoch(42),
    );

    expect(ltvPath, '/tmp/digital_signature/ltv_document_42.pdf');
    expect(ltaPath, '/tmp/digital_signature/ltv_document_42_lta.pdf');
  });

  test('accepts only http and https TSA URLs', () {
    expect(
      DigitalSignatureFlow.isTimestampServerUrl(
        'http://timestamp.digicert.com',
      ),
      isTrue,
    );
    expect(
      DigitalSignatureFlow.isTimestampServerUrl(' https://tsa.example.com '),
      isTrue,
    );
    expect(DigitalSignatureFlow.isTimestampServerUrl(''), isFalse);
    expect(
      DigitalSignatureFlow.isTimestampServerUrl('ftp://tsa.example.com'),
      isFalse,
    );
    expect(DigitalSignatureFlow.isTimestampServerUrl('tsa.example'), isFalse);
  });

  test('labels every timestamp source', () {
    expect(
      CPDFSignatureTimestampSource.values
          .map(DigitalSignatureFlow.timestampSourceLabel)
          .toSet(),
      hasLength(CPDFSignatureTimestampSource.values.length),
    );
  });
}
