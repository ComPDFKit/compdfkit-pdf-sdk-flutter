// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/signature/cpdf_digital_signature.dart';
import 'package:compdfkit_flutter/signature/cpdf_signature_ltv.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:compdfkit_flutter_example/examples/security/digital_signature/digital_signature_flow.dart';
import 'package:compdfkit_flutter_example/examples/security/digital_signature/digital_signature_widgets.dart';

void main() {
  testWidgets('wrong certificate password keeps dialog open', (tester) async {
    String? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showCertificatePasswordDialog(
                context: context,
                certificateName: 'example.p12',
                validatePassword: (password) async => password == 'correct',
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('digital-signature-password')),
      'wrong',
    );
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('Certificate password'), findsOneWidget);
    expect(find.text('Incorrect certificate password.'), findsOneWidget);
    expect(result, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('digital-signature-password')),
      'correct',
    );
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('Certificate password'), findsNothing);
    expect(result, 'correct');
  });

  testWidgets('bottom sheet close button dismisses the sheet', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDigitalSignatureSheet(
              context: context,
              fieldName: 'Approval',
              onChooseExisting: () async => null,
              onCreateCertificate: () async => null,
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sign Approval'), findsOneWidget);
    expect(find.text('Choose existing'), findsOneWidget);
    expect(find.text('Create certificate'), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    expect(find.text('Sign Approval'), findsNothing);
  });

  testWidgets('create certificate dialog starts with empty passwords',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showCreateCertificateDialog(context: context),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final password = tester.widget<TextField>(
      find.byKey(const ValueKey('digital-signature-create-password')),
    );
    expect(password.controller!.text, isEmpty);
    expect(find.byKey(const ValueKey('digital-signature-confirm-password')),
        findsNothing);
  });

  test('certificate session does not expose a password in its display name',
      () {
    const session = DigitalSignatureCertificateSession(
      path: '/tmp/example.p12',
      password: 'secret',
    );

    expect(session.displayName, 'example.p12');
    expect(session.displayName, isNot(contains('secret')));
  });

  testWidgets('signing sheet shows the TSA URL only when timestamp is on',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDigitalSignatureSheet(
              context: context,
              fieldName: 'Approval',
              onChooseExisting: () async => null,
              onCreateCertificate: () async => null,
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Timestamp server (TSA) URL'), findsNothing);

    final timestampSwitch = find.text(
      'Embed RFC 3161 timestamp (network required)',
    );
    await tester.ensureVisible(timestampSwitch);
    await tester.pumpAndSettle();
    await tester.tap(
      find
          .descendant(
            of: find
                .ancestor(of: timestampSwitch, matching: find.byType(Row))
                .first,
            matching: find.byType(Switch),
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Timestamp server (TSA) URL'), findsOneWidget);
    expect(find.text('http://timestamp.digicert.com'), findsOneWidget);
  });

  testWidgets('info sheet shows timestamp and LTV state', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    bool? requestedLta;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDigitalSignatureInfoDialog(
              context: context,
              info: const CPDFDigitalSignatureInfo(
                fieldName: 'Approval',
                pageIndex: 0,
                bounds: CPDFRectF(left: 0, top: 50, right: 100, bottom: 0),
                permissions: CPDFSignaturePermission.fillAndSign,
              ),
              verification: const CPDFDigitalSignatureVerificationResult(
                signatureValid: true,
                documentUnmodified: true,
                certificateTrusted: true,
                certificateExpired: false,
                timestampSource: CPDFSignatureTimestampSource.embedded,
                embeddedTimestampValid: true,
                ltvEnabled: false,
              ),
              ltvReadiness: const CPDFLtvReadiness(
                success: true,
                missingMaterials: ['DSS', 'VRI'],
              ),
              onAddLtv: (appendDocumentTimestamp) async {
                requestedLta = appendDocumentTimestamp;
                return 'pades.lt.auto.chain_untrusted: untrusted';
              },
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Embedded RFC 3161 timestamp'), findsOneWidget);
    expect(find.text('Embedded timestamp valid'), findsOneWidget);
    expect(find.text('LTV enabled (document)'), findsOneWidget);
    expect(find.text('DSS, VRI'), findsOneWidget);

    await tester.tap(find.text('Add LTV with a trusted root (PEM)'));
    await tester.pumpAndSettle();

    expect(requestedLta, isFalse);
    expect(
      find.text('pades.lt.auto.chain_untrusted: untrusted'),
      findsOneWidget,
    );
  });
}
