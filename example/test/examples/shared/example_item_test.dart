// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/examples/shared/example_item.dart';
import 'package:compdfkit_flutter_example/examples/shared/example_route_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExampleItem', () {
    test('constructs correctly with pageBuilder', () {
      const item = ExampleItem(
        title: 'Test Example',
        description: 'Test Description',
        routeType: ExampleRouteType.pageBuilder,
        pageBuilder: _testPageBuilder,
      );

      expect(item.title, 'Test Example');
      expect(item.description, 'Test Description');
      expect(item.routeType, ExampleRouteType.pageBuilder);
      expect(item.pageBuilder, isNotNull);
      expect(item.modalCallback, isNull);
    });

    test('constructs correctly with modalCallback', () {
      final item = ExampleItem(
        title: 'Modal Example',
        routeType: ExampleRouteType.modalCallback,
        modalCallback: (context) {},
      );

      expect(item.title, 'Modal Example');
      expect(item.routeType, ExampleRouteType.modalCallback);
      expect(item.modalCallback, isNotNull);
      expect(item.pageBuilder, isNull);
    });

    test('validates routeType matches provided builder/callback', () {
      expect(
        () => ExampleItem(
          title: 'Invalid',
          routeType: ExampleRouteType.pageBuilder,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => ExampleItem(
          title: 'Invalid',
          routeType: ExampleRouteType.modalCallback,
          // modalCallback
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('supports platform restrictions', () {
      const item = ExampleItem(
        title: 'Android Only',
        routeType: ExampleRouteType.pageBuilder,
        pageBuilder: _testPageBuilder,
        supportedPlatforms: [TargetPlatform.android],
      );

      expect(item.supportedPlatforms, isNotNull);
      expect(item.supportedPlatforms, contains(TargetPlatform.android));
      expect(item.supportedPlatforms, isNot(contains(TargetPlatform.iOS)));
    });
  });
}

// pageBuilder
Widget _testPageBuilder(BuildContext context) {
  return const Placeholder();
}
