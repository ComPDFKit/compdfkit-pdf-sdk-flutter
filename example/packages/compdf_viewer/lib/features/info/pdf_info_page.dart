// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/info/widgets/pdf_info_content.dart';

/// Full-screen page displaying comprehensive PDF document information.
///
/// This page presents detailed metadata and properties of the currently open PDF,
/// organized into three main sections via [PdfInfoContent]:
/// - Basic information (file name, size, title, author)
/// - Creation information (version, page count, creator, producer, dates)
/// - Permissions (encryption status, copy/print permissions)
///
/// The page includes an app bar with the "File Info" title and back navigation.
/// All data is managed by [PdfInfoController] and displayed reactively.
///
/// Example usage:
/// ```dart
/// // Navigate to info page from PDF viewer
/// Get.to(() => PdfInfoPage());
///
/// // Or use in router configuration
/// GetPage(name: '/pdf-info', page: () => PdfInfoPage());
/// ```
class PdfInfoPage extends StatelessWidget {
  const PdfInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(PdfLocaleKeys.fileInfo.tr)),
      body: const PdfInfoContent(),
    );
  }
}
