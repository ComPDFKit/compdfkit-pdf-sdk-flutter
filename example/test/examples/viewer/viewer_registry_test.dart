// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/examples/shared/example_route_type.dart';
import 'package:compdfkit_flutter_example/examples/viewer/_registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Viewer Registry', () {
    test('category has correct metadata', () {
      expect(viewerCategory.id, 'viewer');
      expect(viewerCategory.name, 'Viewer');
      expect(viewerCategory.icon, isNotNull);
    });

    test('has at least 4 examples', () {
      expect(viewerCategory.examples.length, greaterThanOrEqualTo(4));
    });

    test('all examples have required fields', () {
      for (final example in viewerCategory.examples) {
        expect(example.title, isNotEmpty);
        expect(example.routeType, isNotNull);

        if (example.routeType == ExampleRouteType.pageBuilder) {
          expect(
            example.pageBuilder,
            isNotNull,
            reason: '${example.title} needs pageBuilder',
          );
        } else {
          expect(
            example.modalCallback,
            isNotNull,
            reason: '${example.title} needs modalCallback',
          );
        }
      }
    });

    test('Dark Theme example is always registered with supportedPlatforms', () {
      final darkTheme = viewerCategory.examples.firstWhere(
        (e) => e.title.contains('Dark'),
        orElse: () =>
            throw TestFailure('Dark Theme example not found in registry'),
      );
      expect(darkTheme.supportedPlatforms, isNotNull);
      expect(darkTheme.supportedPlatforms, contains(TargetPlatform.android));
    });
  });
}
