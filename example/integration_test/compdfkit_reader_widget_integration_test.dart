// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:async';
import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> initializeComPDFKitSDK() async {
  final licenseFile =
      await CPDFFileUtil.extractAsset('assets/license_key_flutter.xml');
  final ok = await ComPDFKit.initWithPath(licenseFile.path);
  if (!ok) {
    fail('ComPDFKit SDK initialization failed (license: ${licenseFile.path}).');
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeComPDFKitSDK();
  });

  group('CPDFReaderWidget', () {
    late File pdfFile;
    late CPDFReaderWidgetController controller;

    setUp(() async {
      pdfFile = await CPDFFileUtil.extractAsset('pdfs/annot_test.pdf');
    });

    testWidgets('widget builds and onCreated fires with ready controller',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () => fail('onCreated callback did not fire'),
      );

      expect(controller.document, isNotNull);
      expect(controller.document.isValid, true);

      await controller.document.close();
    });

    testWidgets('document is accessible from controller',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      final document = controller.document;
      expect(document, isNotNull);
      expect(document.isValid, true);

      final pageCount = await document.getPageCount();
      expect(pageCount, greaterThan(0));

      await document.close();
    });

    testWidgets('getCurrentPageIndex returns valid value',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      final pageIndex = await controller.getCurrentPageIndex();
      expect(pageIndex, isA<int>());

      await controller.document.close();
    });

    testWidgets('setScale and getScale smoke test',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      await controller.setScale(1.5);
      final scale = await controller.getScale();
      expect(scale, greaterThan(0));

      await controller.document.close();
    });

    testWidgets('display mode methods do not throw',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      await controller.isVerticalMode();
      await controller.isContinueMode();
      await controller.isDoublePageMode();
      await controller.isCoverPageMode();
      await controller.isCropMode();

      await controller.document.close();
    });

    testWidgets('page changed callback fires when changing page',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();
      var pageChangedCalled = false;
      int? changedPageIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
              onPageChanged: (pageIndex) {
                pageChangedCalled = true;
                changedPageIndex = pageIndex;
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      final pageCount = await controller.document.getPageCount();
      if (pageCount > 1) {
        await controller.setDisplayPageIndex(pageIndex: 1);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(pageChangedCalled, true,
            reason: 'onPageChanged callback should fire after page navigation');
        expect(changedPageIndex, isNotNull);
      }

      await controller.document.close();
    });

    testWidgets('annotation layer visibility works',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      await controller.setAnnotationsVisible(false);
      final isVisible1 = await controller.isAnnotationsVisible();
      expect(isVisible1, false);

      await controller.setAnnotationsVisible(true);
      final isVisible2 = await controller.isAnnotationsVisible();
      expect(isVisible2, true);

      await controller.document.close();
    });

    testWidgets('form field highlight works',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      await controller.setFormFieldHighlight(true);
      final isHighlight = await controller.isFormFieldHighlight();
      expect(isHighlight, true);

      await controller.setFormFieldHighlight(false);
      final isNotHighlight = await controller.isFormFieldHighlight();
      expect(isNotHighlight, false);

      await controller.document.close();
    });

    testWidgets('link highlight works',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      await controller.setLinkHighlight(true);
      final isHighlight = await controller.isLinkHighlight();
      expect(isHighlight, true);

      await controller.setLinkHighlight(false);
      final isNotHighlight = await controller.isLinkHighlight();
      expect(isNotHighlight, false);

      await controller.document.close();
    });

    testWidgets('event listener registration works',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      void onAnnotationsCreated(dynamic event) {}
      controller.addEventListener(CPDFEvent.annotationsCreated,
          onAnnotationsCreated);

      final removed = controller.removeEventListener(
          CPDFEvent.annotationsCreated, onAnnotationsCreated);
      expect(removed, true);

      final removedAgain = controller.removeEventListener(
          CPDFEvent.annotationsCreated, onAnnotationsCreated);
      expect(removedAgain, false);

      await controller.document.close();
    });

    testWidgets('setDisplayPageIndex does not throw',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      await controller.setDisplayPageIndex(pageIndex: 0);
      final pageIndex = await controller.getCurrentPageIndex();
      expect(pageIndex, isA<int>());

      await controller.document.close();
    });

    testWidgets('dispose does not crash',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final completer = Completer<CPDFReaderWidgetController>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CPDFReaderWidget(
              document: pdfFile.path,
              configuration: CPDFConfiguration(),
              onCreated: (c) {
                controller = c;
                completer.complete(c);
              },
            ),
          ),
        ),
      );
      await tester.pump();

      controller = await completer.future.timeout(
        const Duration(seconds: 20),
      );

      await controller.document.close();
      controller.dispose();
    });
  });
}
