/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/page/cpdf_text_range.dart';

class CPDFSearchItem {

  final CPDFTextRange keywordsTextRange;

  final CPDFTextRange contentTextRange;

  final String keywords;

  final String content;

  const CPDFSearchItem({
    required this.keywordsTextRange,
    required this.contentTextRange,
    required this.keywords,
    required this.content,
  });

}