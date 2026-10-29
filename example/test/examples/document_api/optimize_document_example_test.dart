// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/constants/asset_paths.dart';
import 'package:compdfkit_flutter_example/examples/document_api/optimize_document_example.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptimizeDocumentExample', () {
    test('uses the shared sample document and the expected title', () {
      const example = OptimizeDocumentExample();

      expect(example.title, 'Optimize Document');
      expect(example.assetPath, AppAssets.pdfDocument);
    });
  });
}
