// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/constants/asset_paths.dart';
import 'package:compdfkit_flutter_example/examples/document_api/pdf_standard_example.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PdfStandardExample', () {
    test('uses the shared sample document and the expected title', () {
      const example = PdfStandardExample();

      expect(example.title, 'PDF Standard');
      expect(example.assetPath, AppAssets.pdfDocument);
    });
  });
}
