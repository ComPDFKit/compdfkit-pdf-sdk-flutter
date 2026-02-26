// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/examples/document_api/_registry.dart';
import 'package:compdfkit_flutter_example/examples/shared/example_route_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Document API Registry', () {
    test('category has correct metadata', () {
      expect(documentApiCategory.id, 'document_api');
      expect(documentApiCategory.name, isNotEmpty);
      expect(documentApiCategory.icon, isNotNull);
    });

    test('has at least 6 examples', () {
      expect(documentApiCategory.examples.length, greaterThanOrEqualTo(6));
    });

    test('all examples have required fields', () {
      for (final example in documentApiCategory.examples) {
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
  });
}
