/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';

import 'cpdf_goto_action.dart';

class CPDFAction {

  final CPDFActionType actionType;

  CPDFAction({required this.actionType});

  factory CPDFAction.fromJson(Map<String, dynamic> json) {
    CPDFActionType actionType = CPDFActionType.values.firstWhere((element) => element.name == json["actionType"]);
    switch (actionType) {
      case CPDFActionType.goTo:
        return CPDFGoToAction.fromJson(json);
      case CPDFActionType.uri:
        return CPDFUriAction.fromJson(json);
      default:
        return CPDFAction(actionType: actionType);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "actionType": actionType.name,
    };
  }

}

enum CPDFActionType {

  unknown,

  goTo,

  goToR,

  goToE,

  launch,

  thread,

  uri,

  sound,

  movie,

  hide,

  named,

  submitForm,

  resetForm,

  importData,

  javaScript,

  setOCGState,

  rendition,

  trans,

  goTo3DView,

  uop,

  error;


}

