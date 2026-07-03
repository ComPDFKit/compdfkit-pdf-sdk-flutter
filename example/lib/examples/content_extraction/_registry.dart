// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import '../shared/category_info.dart';
import '../shared/example_item.dart';
import '../shared/example_route_type.dart';
import 'extract_images_example.dart';
import 'page_text_extraction_example.dart';

/// Content Extraction category information.
final CategoryInfo contentExtractionCategory = CategoryInfo(
  id: 'content_extraction',
  name: 'Content Extraction',
  icon: Icons.text_fields,
  description: 'Extract text, images and page content',
  examples: [
    ExampleItem(
      title: 'Page Text Extraction',
      description: 'Extract page text and inspect text lines',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const PageTextExtractionExample(),
      visual: const ExampleVisual(
        icon: Icons.text_fields,
        backgroundColor: Color(0xFFE0F2F1),
        iconColor: Color(0xFF0F766E),
      ),
    ),
    ExampleItem(
      title: 'Extract Images',
      description: 'Extract embedded images from PDF pages',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ExtractImagesExample(),
      visual: const ExampleVisual(
        icon: Icons.image_search,
        backgroundColor: Color(0xFFE0F7FA),
        iconColor: Color(0xFF00838F),
      ),
    ),
  ],
);
