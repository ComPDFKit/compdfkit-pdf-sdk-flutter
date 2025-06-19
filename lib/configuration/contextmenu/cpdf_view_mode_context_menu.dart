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


class CPDFViewModeContextMenu {

  final List<CPDFContextMenuItem<CPDFViewModeTextSelectKey>> textSelect;

  const CPDFViewModeContextMenu({
    this.textSelect = const [
      CPDFContextMenuItem(CPDFViewModeTextSelectKey.copy),
    ],
  });

  factory CPDFViewModeContextMenu.textSelectOnly(
      List<CPDFViewModeTextSelectKey> keys) {
    return CPDFViewModeContextMenu(
      textSelect: keys.map(CPDFContextMenuItem.of).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'textSelect': textSelect.map((item) => item.toJson()).toList(),
    };
  }
}