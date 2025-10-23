/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */


import '../cpdf_options.dart';

class CPDFPageEditorConfig {

  final List<CPDFPageEditorMenus> menus;

  const CPDFPageEditorConfig({this.menus = const [
    CPDFPageEditorMenus.insertPage,
    CPDFPageEditorMenus.replacePage,
    CPDFPageEditorMenus.extractPage,
    CPDFPageEditorMenus.copyPage,
    CPDFPageEditorMenus.rotatePage,
    CPDFPageEditorMenus.deletePage,
  ]});

  /// toJson
  Map<String, dynamic> toJson() => {
    'menus': menus.map((e) => e.name).toList(),
  };

}