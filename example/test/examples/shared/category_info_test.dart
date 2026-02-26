// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/examples/shared/category_info.dart';
import 'package:compdfkit_flutter_example/examples/shared/example_item.dart';
import 'package:compdfkit_flutter_example/examples/shared/example_route_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryInfo', () {
    test('constructs correctly with all fields', () {
      const category = CategoryInfo(
        id: 'test',
        name: 'Test Category',
        icon: Icons.science,
        description: 'Test Description',
        examples: [],
      );

      expect(category.id, 'test');
      expect(category.name, 'Test Category');
      expect(category.icon, Icons.science);
      expect(category.description, 'Test Description');
      expect(category.examples, isEmpty);
    });

    test('stores examples list correctly', () {
      const examples = [
        ExampleItem(
          title: 'Example 1',
          routeType: ExampleRouteType.pageBuilder,
          pageBuilder: _testPageBuilder,
        ),
        ExampleItem(
          title: 'Example 2',
          routeType: ExampleRouteType.pageBuilder,
          pageBuilder: _testPageBuilder,
        ),
      ];

      const category = CategoryInfo(
        id: 'test',
        name: 'Test Category',
        icon: Icons.science,
        examples: examples,
      );

      expect(category.examples.length, 2);
      expect(category.examples[0].title, 'Example 1');
      expect(category.examples[1].title, 'Example 2');
    });
  });
}

Widget _testPageBuilder(BuildContext context) {
  return const Placeholder();
}
