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
    test('registers Page Thumbnail Provider example', () {
      final example = documentApiCategory.examples.firstWhere(
        (item) => item.title == 'Page Thumbnail Provider',
        orElse: () => throw TestFailure(
          'Page Thumbnail Provider example not found in registry',
        ),
      );

      expect(example.description, contains('opened document'));
      expect(example.routeType, ExampleRouteType.pageBuilder);
      expect(example.pageBuilder, isNotNull);
    });
  });
}
