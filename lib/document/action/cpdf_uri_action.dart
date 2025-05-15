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

class CPDFUriAction extends CPDFAction {
  final String uri;

  CPDFUriAction({required CPDFActionType actionType, required this.uri})
      : super(actionType: actionType);

  @override
  factory CPDFUriAction.fromJson(Map<String, dynamic> json) {
    return CPDFUriAction(actionType: CPDFActionType.uri, uri: json["uri"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "uri": uri};
  }
}
