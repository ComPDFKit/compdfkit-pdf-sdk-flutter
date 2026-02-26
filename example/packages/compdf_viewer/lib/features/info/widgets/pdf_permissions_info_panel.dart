// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_document_permission_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/info/controller/pdf_info_controller.dart';
import 'package:compdf_viewer/features/info/widgets/pdf_info_head.dart';
import 'package:compdf_viewer/features/info/widgets/pdf_info_item.dart';

/// Panel displaying PDF security and permissions information.
///
/// This panel shows document access control and security settings:
/// - **Encrypted**: Whether the document has encryption enabled (Yes/No)
/// - **Unlocked**: Whether the document is currently unlocked (Yes/No)
/// - **Allow Copy**: Whether text/content copying is permitted (Yes/No)
/// - **Allow Print**: Whether printing is permitted (Yes/No)
///
/// Data is reactively fetched from [PdfInfoController] which provides both
/// the encryption status and detailed permission flags from [CPDFDocumentPermissionInfo].
/// All values are displayed as localized Yes/No strings.
///
/// Example usage:
/// ```dart
/// // Used in PdfInfoContent to show security/permissions section
/// Column(
///   children: [
///     PdfBasicInfoPanel(),
///     PdfCreateInfoPanel(),
///     PdfPermissionsInfoPanel(), // Shows encryption & permissions
///   ],
/// )
/// ```
class PdfPermissionsInfoPanel extends GetView<PdfInfoController> {
  const PdfPermissionsInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CPDFDocumentPermissionInfo permissionInfo =
          controller.state.pdfPermissionInfo.value;
      return Column(
        children: [
          PdfInfoHead(
              title: PdfLocaleKeys.accessPer.tr, icon: Icons.lock_outline),
          PdfInfoItem(
            title: PdfLocaleKeys.encrypted.tr,
            content: controller.state.isEncrypted.value
                ? PdfLocaleKeys.yes.tr
                : PdfLocaleKeys.no.tr,
            isBadge: true,
            isPositive: controller.state.isEncrypted.value,
          ),
          PdfInfoItem(
            title: PdfLocaleKeys.unlocked.tr,
            content: controller.state.isLocked.value
                ? PdfLocaleKeys.yes.tr
                : PdfLocaleKeys.no.tr,
            isBadge: true,
            isPositive: controller.state.isLocked.value,
          ),
          PdfInfoItem(
            title: PdfLocaleKeys.allowCopy.tr,
            content: permissionInfo.allowsCopying
                ? PdfLocaleKeys.yes.tr
                : PdfLocaleKeys.no.tr,
            isBadge: true,
            isPositive: permissionInfo.allowsCopying,
          ),
          PdfInfoItem(
            title: PdfLocaleKeys.allowPrint.tr,
            content: permissionInfo.allowsPrinting
                ? PdfLocaleKeys.yes.tr
                : PdfLocaleKeys.no.tr,
            isBadge: true,
            isPositive: permissionInfo.allowsPrinting,
          ),
        ],
      );
    });
  }
}
