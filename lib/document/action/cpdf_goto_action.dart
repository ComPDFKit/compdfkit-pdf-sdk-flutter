/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/document/action/cpdf_action.dart';

/// A class representing a GoTo action in a PDF document.
/// This action navigates to a specified page within the document when triggered.
/// It extends the [CPDFAction] class.
/// The [pageIndex] property holds the index of the page to navigate to.
/// Example usage:
/// ```dart
/// // Create a GoTo action to navigate to page index 2
/// CPDFGoToAction action = CPDFGoToAction(pageIndex: 2);
/// ```
class CPDFGoToAction extends CPDFAction {

  int pageIndex;

  CPDFGoToAction({required this.pageIndex}) : super(actionType: CPDFActionType.goTo);

  factory CPDFGoToAction.fromJson(Map<String, dynamic> json) {
    return CPDFGoToAction(pageIndex: json["pageIndex"] ?? 0);
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "pageIndex": pageIndex};
  }
}
