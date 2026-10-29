// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/examples/annotations/_registry.dart';
import 'package:compdfkit_flutter_example/examples/shared/example_route_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registers Redaction Annotation in Annotations', () {
    final example = annotationsCategory.examples.firstWhere(
      (item) => item.title == 'Redaction Annotation',
      orElse: () => throw TestFailure(
        'Redaction Annotation example not found in Annotations registry',
      ),
    );

    expect(example.routeType, ExampleRouteType.pageBuilder);
    expect(example.pageBuilder, isNotNull);
  });
}
