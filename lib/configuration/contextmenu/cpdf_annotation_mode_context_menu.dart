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

class CPDFAnnotationModeContextMenu {

  final List<CPDFContextMenuItem<CPDFAnnotationTextSelectMenuKey>> textSelect;
  final List<CPDFContextMenuItem<CPDFAnnotationLongPressMenuKey>> longPress;
  final List<CPDFContextMenuItem<CPDFAnnotationMarkupMenuKey>> markup;
  final List<CPDFContextMenuItem<CPDFAnnotationSoundMenuKey>> sound;
  final List<CPDFContextMenuItem<CPDFAnnotationInkMenuKey>> ink;
  final List<CPDFContextMenuItem<CPDFAnnotationShapeMenuKey>> shape;
  final List<CPDFContextMenuItem<CPDFAnnotationFreeTextMenuKey>> freeText;
  final List<CPDFContextMenuItem<CPDFAnnotationSignMenuKey>> signStamp;
  final List<CPDFContextMenuItem<CPDFAnnotationStampMenuKey>> stamp;
  final List<CPDFContextMenuItem<CPDFAnnotationLinkMenuKey>> link;



  const CPDFAnnotationModeContextMenu({
    this.textSelect = const [
      CPDFContextMenuItem(CPDFAnnotationTextSelectMenuKey.copy),
      CPDFContextMenuItem(CPDFAnnotationTextSelectMenuKey.highlight),
      CPDFContextMenuItem(CPDFAnnotationTextSelectMenuKey.underline),
      CPDFContextMenuItem(CPDFAnnotationTextSelectMenuKey.strikeout),
      CPDFContextMenuItem(CPDFAnnotationTextSelectMenuKey.squiggly),
    ],
    this.longPress = const [
      CPDFContextMenuItem(CPDFAnnotationLongPressMenuKey.paste),
      CPDFContextMenuItem(CPDFAnnotationLongPressMenuKey.note),
      CPDFContextMenuItem(CPDFAnnotationLongPressMenuKey.textBox),
      CPDFContextMenuItem(CPDFAnnotationLongPressMenuKey.stamp),
      CPDFContextMenuItem(CPDFAnnotationLongPressMenuKey.image),
    ],
    this.markup = const [
      CPDFContextMenuItem(CPDFAnnotationMarkupMenuKey.properties),
      CPDFContextMenuItem(CPDFAnnotationMarkupMenuKey.note),
      CPDFContextMenuItem(CPDFAnnotationMarkupMenuKey.reply),
      CPDFContextMenuItem(CPDFAnnotationMarkupMenuKey.viewReply),
      CPDFContextMenuItem(CPDFAnnotationMarkupMenuKey.delete),
    ],
    this.sound = const [
      CPDFContextMenuItem(CPDFAnnotationSoundMenuKey.reply),
      CPDFContextMenuItem(CPDFAnnotationSoundMenuKey.viewReply),
      CPDFContextMenuItem(CPDFAnnotationSoundMenuKey.play),
      CPDFContextMenuItem(CPDFAnnotationSoundMenuKey.record),
      CPDFContextMenuItem(CPDFAnnotationSoundMenuKey.delete),
    ],
    this.ink = const [
      CPDFContextMenuItem(CPDFAnnotationInkMenuKey.properties),
      CPDFContextMenuItem(CPDFAnnotationInkMenuKey.note),
      CPDFContextMenuItem(CPDFAnnotationInkMenuKey.reply),
      CPDFContextMenuItem(CPDFAnnotationInkMenuKey.viewReply),
      CPDFContextMenuItem(CPDFAnnotationInkMenuKey.delete),
    ],
    this.shape = const [
      CPDFContextMenuItem(CPDFAnnotationShapeMenuKey.properties),
      CPDFContextMenuItem(CPDFAnnotationShapeMenuKey.note),
      CPDFContextMenuItem(CPDFAnnotationShapeMenuKey.reply),
      CPDFContextMenuItem(CPDFAnnotationShapeMenuKey.viewReply),
      CPDFContextMenuItem(CPDFAnnotationShapeMenuKey.delete),
    ],
    this.freeText = const [
      CPDFContextMenuItem(CPDFAnnotationFreeTextMenuKey.properties),
      CPDFContextMenuItem(CPDFAnnotationFreeTextMenuKey.edit),
      CPDFContextMenuItem(CPDFAnnotationFreeTextMenuKey.reply),
      CPDFContextMenuItem(CPDFAnnotationFreeTextMenuKey.viewReply),
      CPDFContextMenuItem(CPDFAnnotationFreeTextMenuKey.delete),
    ],
    this.signStamp = const [
      CPDFContextMenuItem(CPDFAnnotationSignMenuKey.signHere),
      CPDFContextMenuItem(CPDFAnnotationSignMenuKey.delete),
      CPDFContextMenuItem(CPDFAnnotationSignMenuKey.rotate),
    ],
    this.stamp = const [
      CPDFContextMenuItem(CPDFAnnotationStampMenuKey.note),
      CPDFContextMenuItem(CPDFAnnotationStampMenuKey.reply),
      CPDFContextMenuItem(CPDFAnnotationStampMenuKey.viewReply),
      CPDFContextMenuItem(CPDFAnnotationStampMenuKey.delete),
    ],
    this.link = const [
      CPDFContextMenuItem(CPDFAnnotationLinkMenuKey.edit),
      CPDFContextMenuItem(CPDFAnnotationLinkMenuKey.delete),
    ],
  });

  Map<String, dynamic> toJson() {
    return {
      'textSelect': textSelect.map((item) => item.toJson()).toList(),
      'longPressContent': longPress.map((item) => item.toJson()).toList(),
      'markupContent': markup.map((item) => item.toJson()).toList(),
      'soundContent': sound.map((item) => item.toJson()).toList(),
      'inkContent': ink.map((item) => item.toJson()).toList(),
      'shapeContent': shape.map((item) => item.toJson()).toList(),
      'freeTextContent': freeText.map((item) => item.toJson()).toList(),
      'signStampContent': signStamp.map((item) => item.toJson()).toList(),
      'stampContent': stamp.map((item) => item.toJson()).toList(),
      'linkContent': link.map((item) => item.toJson()).toList(),
    };
  }
}