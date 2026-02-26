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


class CPDFNamedAction extends CPDFAction {
  
  final CPDFNamedActionType namedAction;

  CPDFNamedAction({required this.namedAction})
      : super(actionType: CPDFActionType.named);

  factory CPDFNamedAction.fromJson(Map<String, dynamic> json) {
    return CPDFNamedAction(namedAction: json["namedAction"] != null
        ? CPDFNamedActionType.values.firstWhere(
            (e) => e.name == json["namedAction"],
            orElse: () => CPDFNamedActionType.none,
          )
        : CPDFNamedActionType.none);
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "namedAction": namedAction.name};
  }
}

enum CPDFNamedActionType {
  firstPage,
  lastPage,
  nextPage,
  prevPage,
  print,
  none
}