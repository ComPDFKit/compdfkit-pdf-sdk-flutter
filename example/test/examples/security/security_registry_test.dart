// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/examples/security/_registry.dart';
import 'package:compdfkit_flutter_example/examples/shared/example_route_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Security registry', () {
    test('registers Header & Footer', () {
      final example = securityCategory.examples.firstWhere(
        (item) => item.title == 'Header & Footer',
        orElse: () => throw TestFailure(
          'Header & Footer example not found in Security registry',
        ),
      );

      expect(example.routeType, ExampleRouteType.pageBuilder);
      expect(example.pageBuilder, isNotNull);
    });

    test('registers Document Background', () {
      final example = securityCategory.examples.firstWhere(
        (item) => item.title == 'Document Background',
        orElse: () => throw TestFailure(
          'Document Background example not found in Security registry',
        ),
      );

      expect(example.description, contains('image backgrounds'));
      expect(example.routeType, ExampleRouteType.pageBuilder);
      expect(example.pageBuilder, isNotNull);
    });

    test('registers Certificate Management', () {
      final example = securityCategory.examples.firstWhere(
        (item) => item.title == 'Certificate Management',
        orElse: () => throw TestFailure(
          'Certificate Management example not found in Security registry',
        ),
      );

      expect(example.description, contains('PKCS#12'));
      expect(example.routeType, ExampleRouteType.pageBuilder);
      expect(example.pageBuilder, isNotNull);
    });

    test('registers Digital Signature', () {
      final example = securityCategory.examples.firstWhere(
        (item) => item.title == 'Digital Signature',
        orElse: () => throw TestFailure(
          'Digital Signature example not found in Security registry',
        ),
      );

      expect(example.description, contains('signature field'));
      expect(example.routeType, ExampleRouteType.pageBuilder);
      expect(example.pageBuilder, isNotNull);
    });
  });
}
