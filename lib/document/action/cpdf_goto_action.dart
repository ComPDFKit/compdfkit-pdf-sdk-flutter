/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/document/action/cpdf_action.dart';

class CPDFGoToAction extends CPDFAction {
  final int pageIndex;

  CPDFGoToAction({required super.actionType, required this.pageIndex});

  factory CPDFGoToAction.fromJson(Map<String, dynamic> json) {
    return CPDFGoToAction(
        actionType: CPDFActionType.goTo, pageIndex: json["pageIndex"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "pageIndex": pageIndex};
  }
}
