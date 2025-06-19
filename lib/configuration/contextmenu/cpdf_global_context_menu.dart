/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'cpdf_context_menu_item.dart';
import 'cpdf_context_menu_options.dart';

class CPDFGlobalContextMenu {

  final List<CPDFContextMenuItem<CPDFScreenShotMenuKey>> screenshot;

  const CPDFGlobalContextMenu({
    this.screenshot = const [
      CPDFContextMenuItem(CPDFScreenShotMenuKey.exit),
      CPDFContextMenuItem(CPDFScreenShotMenuKey.share),
    ],
  });

  factory CPDFGlobalContextMenu.screenshotOnly(
      List<CPDFScreenShotMenuKey> keys) {
    return CPDFGlobalContextMenu(
      screenshot: keys.map(CPDFContextMenuItem.of).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screenshot': screenshot.map((item) => item.toJson()).toList(),
    };
  }
}
