/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

class CPDFBotaConfig {
  final List<CPDFBotaTabs> tabs;

  final CPDFBotaMenuConfig menus;

  const CPDFBotaConfig(
      {this.tabs = const [
        CPDFBotaTabs.outline,
        CPDFBotaTabs.bookmark,
        CPDFBotaTabs.annotations
      ],
      this.menus = const CPDFBotaMenuConfig()});

  factory CPDFBotaConfig.fromJson(Map<String, dynamic> json) {
    return CPDFBotaConfig(
      tabs: (json['tabs'] as List<dynamic>?)
              ?.map((e) => CPDFBotaTabs.values.firstWhere(
                    (tab) => tab.name == e,
                    orElse: () => CPDFBotaTabs.outline,
                  ))
              .toList() ??
          const [
            CPDFBotaTabs.outline,
            CPDFBotaTabs.bookmark,
            CPDFBotaTabs.annotations
          ],
      menus: json['menus'] != null
          ? CPDFBotaMenuConfig.fromJson(json['menus'])
          : const CPDFBotaMenuConfig(),
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'tabs': tabs.map((e) => e.name).toList(),
        'menus': menus.toJson(),
      };
}

class CPDFBotaMenuConfig {
  final CPDFBotaAnnotationMenuConfig annotations;

  const CPDFBotaMenuConfig({
    this.annotations = const CPDFBotaAnnotationMenuConfig(),
  });

  factory CPDFBotaMenuConfig.fromJson(Map<String, dynamic> json) {
    return CPDFBotaMenuConfig(
      annotations: json['annotations'] != null
          ? CPDFBotaAnnotationMenuConfig.fromJson(json['annotations'])
          : const CPDFBotaAnnotationMenuConfig(),
    );
  }

  Map<String, dynamic> toJson() => {
        'annotations': annotations.toJson(),
      };
}

class CPDFBotaAnnotationMenuConfig {
  final List<CPDFBotaMenuItem<CPDFBotaAnnotGlobalMenu>> global;

  final List<CPDFBotaMenuItem> item;

  const CPDFBotaAnnotationMenuConfig({
    this.global = const [
      CPDFBotaMenuItem(id: CPDFBotaAnnotGlobalMenu.importAnnotation),
      CPDFBotaMenuItem(id: CPDFBotaAnnotGlobalMenu.exportAnnotation),
      CPDFBotaMenuItem(id: CPDFBotaAnnotGlobalMenu.removeAllAnnotation),
      CPDFBotaMenuItem(id: CPDFBotaAnnotGlobalMenu.removeAllReply),
    ],
    this.item = const [
      CPDFBotaMenuItem(
          id: CPDFBotaAnnotItemMenu.reviewStatus,
          subMenus: ['accepted', 'rejected', 'cancelled', 'completed', 'none']),
      CPDFBotaMenuItem(
          id: CPDFBotaAnnotItemMenu.markedStatus),
      CPDFBotaMenuItem(id: CPDFBotaAnnotItemMenu.more, subMenus: [
        'addReply', 'viewReply', 'delete'
      ]),
    ],
  });

  factory CPDFBotaAnnotationMenuConfig.fromJson(Map<String, dynamic> json) {
    return CPDFBotaAnnotationMenuConfig(
      global: (json['global'] as List<dynamic>?)
              ?.map((e) => CPDFBotaMenuItem<CPDFBotaAnnotGlobalMenu>.fromJson(
                    e,
                    (id) => CPDFBotaAnnotGlobalMenu.values.firstWhere(
                      (m) => m.name == id,
                      orElse: () => CPDFBotaAnnotGlobalMenu.importAnnotation,
                    ),
                  ))
              .toList() ??
          const [],
      item: (json['item'] as List<dynamic>?)
              ?.map((e) => CPDFBotaMenuItem<String>.fromJson(
                    e,
                    (id) => id,
                  ))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'global': global.map((e) => e.toJson()).toList(),
        'item': item.map((e) => e.toJson()).toList(),
      };
}

class CPDFBotaMenuItem<T> {
  final T id;
  final List<String> subMenus;

  const CPDFBotaMenuItem({
    required this.id,
    this.subMenus = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id is Enum ? (id as Enum).name : id.toString(),
        if (subMenus.isNotEmpty) 'subMenus': subMenus,
      };

  factory CPDFBotaMenuItem.fromJson(
    Map<String, dynamic> json,
    T Function(String) idParser,
  ) {
    return CPDFBotaMenuItem<T>(
      id: idParser(json['id'] as String),
      subMenus: (json['subMenus'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
