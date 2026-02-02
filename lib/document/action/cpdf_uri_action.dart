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

/// A class representing a URI action in a PDF document.
/// This action opens a specified URI when triggered.
/// It extends the [CPDFAction] class.
/// The [uri] property holds the URI to be opened.
/// Example usage:
/// ```dart
/// // Create a URI action
/// CPDFUriAction action = CPDFUriAction(uri: "https://www.compdf.com/");
///
/// // Create to email action
/// CPDFUriAction emailAction = CPDFUriAction(url: "mailto:support@compdf.com");
///
/// ```
/// See also:
/// * [CPDFAction] - The base class for PDF actions.
///
class CPDFUriAction extends CPDFAction {
  String uri;

  CPDFUriAction({required this.uri})
      : super(actionType: CPDFActionType.uri);

  CPDFUriAction.url({required String url})
      : uri = url,
        super(actionType: CPDFActionType.uri);

  CPDFUriAction.email({required String email})
      : uri = 'mailto:$email',
        super(actionType: CPDFActionType.uri);

  @override
  factory CPDFUriAction.fromJson(Map<String, dynamic> json) {
    return CPDFUriAction(uri: json["uri"] ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "uri": uri};
  }
}
