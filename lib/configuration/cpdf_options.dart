// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

/// Viewer modes supported by ComPDFKit.
///
/// {@category configuration}
enum CPDFViewMode { viewer, annotations, contentEditor, forms, signatures }

/// Toolbar action identifiers used by the viewer UI.
///
/// {@category toolbar}
enum CPDFToolbarAction {
  back,

  thumbnail,

  search,

  bota,

  menu,

  viewSettings,

  documentEditor,

  security,

  watermark,

  flattened,

  documentInfo,

  save,

  share,

  openDocument,

  /// The PDF capture function allows you to capture an area
  /// in the PDF document and convert it into an image.
  snip,

  custom;
}

enum CPDFDisplayMode { singlePage, doublePage, coverPage }

enum CPDFThemeType {
  light,
  dark,
  sepia,
  reseda,
  custom,
}

class CPDFThemes {
  final CPDFThemeType type;
  final String color; // Hex color. for example: '#FF998822'

  const CPDFThemes._(this.type, this.color);

  static const light = CPDFThemes._(CPDFThemeType.light, '#FFFFFFFF');
  static const dark = CPDFThemes._(CPDFThemeType.dark, '#FF000000');
  static const sepia = CPDFThemes._(CPDFThemeType.sepia, '#FFFFEFBE');
  static const reseda = CPDFThemes._(CPDFThemeType.reseda, '#FFCDE6D0');

  factory CPDFThemes.custom(Color customColor) {
    return CPDFThemes._(CPDFThemeType.custom, customColor.toHex());
  }

  static CPDFThemes of(Color color) {
    final hex = color.toHex();
    return {
          light.color: light,
          dark.color: dark,
          sepia.color: sepia,
          reseda.color: reseda,
        }[hex.toUpperCase()] ??
        CPDFThemes.custom(color);
  }
}

/// readerView background themes
// enum CPDFThemes {
//   /// Bright mode, readerview background is white
//   light('#FFFFFFFF'),
//
//   /// dark mode, readerview background is black
//   dark('#FF000000'),
//
//   /// brown paper color
//   sepia('#FFFFEFBE'),
//
//   /// Light green, eye protection mode
//   reseda('#FFCDE6D0');
//
//   final String color;
//
//   const CPDFThemes(this.color);
//
//   static CPDFThemes of(Color color) {
//     return CPDFThemes.values.firstWhere(
//       (theme) => theme.color == color.toHex().toUpperCase(),
//       orElse: () => CPDFThemes.light,
//     );
//   }
//
//   String getColor() {
//     return color;
//   }
// }

enum CPDFAnnotationType {
  note,
  highlight,
  underline,
  squiggly,
  strikeout,
  ink,
  // ignore: constant_identifier_names
  ink_eraser,
  // only ios platform
  pencil,
  circle,
  square,
  arrow,
  line,
  freetext,
  signature,
  stamp,
  pictures,
  link,
  sound,
  unknown;

  static CPDFAnnotationType fromString(String typeStr) {
    return CPDFAnnotationType.values.firstWhere(
      (e) => e.name == typeStr.toLowerCase(),
      orElse: () => throw Exception('Unknown annotation type: $typeStr'),
    );
  }
}

enum CPDFConfigTool { setting, undo, redo }

enum CPDFAnnotBorderStyle { solid, dashed }

enum CPDFLineType {
  unknown,
  none,
  openArrow,
  closedArrow,
  square,
  circle,
  diamond;

  static CPDFLineType fromString(String typeStr) {
    return CPDFLineType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => unknown,
    );
  }
}

enum CPDFAlignment {
  left,
  center,
  right;

  static CPDFAlignment fromString(String typeStr) {
    return CPDFAlignment.values.firstWhere(
      (e) => e.name == typeStr.toLowerCase(),
      orElse: () => throw Exception('Unknown alignment type: $typeStr'),
    );
  }
}

enum CPDFContentEditorType { editorText, editorImage }

enum CPDFFormType {
  // formRecog,
  textField,
  checkBox,
  radioButton,
  listBox,
  comboBox,
  signaturesFields,
  pushButton,
  unknown;

  static CPDFFormType fromString(String typeStr) {
    return CPDFFormType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => throw Exception('Unknown form type: $typeStr'),
    );
  }
}

enum CPDFCheckStyle {
  check,
  circle,
  cross,
  diamond,
  square,
  star;

  static CPDFCheckStyle fromString(String typeStr) {
    return CPDFCheckStyle.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => CPDFCheckStyle.check,
    );
  }
}

enum CPDFThemeMode { light, dark, system }

/// [CPDFEdgeInsets] defines the padding for a PDF document.
///
/// - On **Android**, you can set individual margins for [top], [bottom], [left], and [right].
///   To adjust the spacing between pages, use the `setPageSpacing()` method.
///
/// - On **iOS**, you can also configure [top], [bottom], [left], and [right] margins.
///   The spacing between pages is equal to the [top] margin.
class CPDFEdgeInsets {
  final int left;

  final int top;

  final int right;

  final int bottom;

  const CPDFEdgeInsets.all(int value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const CPDFEdgeInsets.symmetric(
      {required int horizontal, required int vertical})
      : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  const CPDFEdgeInsets.only(
      {required this.left,
      required this.top,
      required this.right,
      required this.bottom});

  Map<String, dynamic> toJson() => {
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
      };
}

enum CPDFDocumentPermissions { none, user, owner }

/// Error types of the opening document.
enum CPDFDocumentError {
  /// No read permission.
  noReadPermission,

  /// SDK No verified license
  notVerifyLicense,

  /// open document success.
  success,

  /// Unknown error
  unknown,

  /// File not found or could not be opened.
  errorFile,

  /// File not in PDF format or corrupted.
  errorFormat,

  /// Password required or incorrect password.
  errorPassword,

  /// Unsupported security scheme.
  errorSecurity,

  /// Error page.
  errorPage
}

enum CPDFDocumentEncryptAlgo {
  // RC4 encryption algorithm.
  rc4,

  /// AES encryption with a 128-bit key.
  aes128,

  /// AES encryption with a 256-bit key.
  aes256,

  /// No encryption algorithm selected.
  noEncryptAlgo;
}

enum CPDFWatermarkType { text, image }

/// Configure the signature method for signing in viewer mode, signature mode,
/// electronic signature, digital signature or manual selection of signature method
enum CPDFFillSignatureType {
  /// Manually select electronic signature or digital signature
  manual,

  /// Digital signature
  digital,

  /// Electronic signature
  electronic
}

enum CPDFBorderEffectType {
  solid,
  cloudy;

  static CPDFBorderEffectType fromString(String typeStr) {
    return CPDFBorderEffectType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => throw Exception('Unknown border effect type: $typeStr'),
    );
  }
}

enum CPDFBotaTabs {
  outline,

  bookmark,

  annotations;
}

enum CPDFBotaAnnotGlobalMenu {
  importAnnotation,

  exportAnnotation,

  removeAllAnnotation,

  removeAllReply;
}

enum CPDFBotaAnnotItemMenu {
  reviewStatus,

  markedStatus,

  more;
}

class CPDFReviewState {
  static const accepted = 'accepted';

  static const rejected = 'rejected';

  static const cancelled = 'cancelled';

  static const completed = 'completed';

  static const none = 'none';
}

class CPDFBotaAnnotMoreMenu {
  static const addReply = 'addReply';

  static const viewReply = 'viewReply';

  static const delete = 'delete';
}

enum CPDFUIVisibilityMode {
  /// Tap the PDF page to hide or show the top and bottom toolbars,
  /// and hide the top toolbar when drawing with Ink.
  automatic,

  /// Always show the top and bottom toolbars.
  always,

  /// Never show the top and bottom toolbars.
  never;
}

/// Page editing menu options
enum CPDFPageEditorMenus {
  insertPage,

  replacePage,

  extractPage,

  copyPage,

  rotatePage,

  deletePage;
}

enum CPDFPencilMenus {
  touch,

  discard,

  save;
}

enum CPDFPageCompression {
  png,

  jpeg;
}

enum CPDFStandardStamp {
  notApproved,
  approved,
  completed,
  final_,
  draft,
  confidential,
  notForPublicRelease,
  forPublicRelease,
  forComment,
  void_,
  preliminaryResults,
  informationOnly,
  accepted,
  rejected,
  witness,
  initialHere,
  signHere,
  revised,
  privateAccepted,
  privateRejected,
  privateRadioMark,
  unknown;
}

extension CPDFStampExtension on CPDFStandardStamp {
  String get name {
    switch (this) {
      case CPDFStandardStamp.notApproved:
        return "NotApproved";
      case CPDFStandardStamp.approved:
        return "Approved";
      case CPDFStandardStamp.completed:
        return "Completed";
      case CPDFStandardStamp.final_:
        return "Final";
      case CPDFStandardStamp.draft:
        return "Draft";
      case CPDFStandardStamp.confidential:
        return "Confidential";
      case CPDFStandardStamp.notForPublicRelease:
        return "NotForPublicRelease";
      case CPDFStandardStamp.forPublicRelease:
        return "ForPublicRelease";
      case CPDFStandardStamp.forComment:
        return "ForComment";
      case CPDFStandardStamp.void_:
        return "Void";
      case CPDFStandardStamp.preliminaryResults:
        return "PreliminaryResults";
      case CPDFStandardStamp.informationOnly:
        return "InformationOnly";
      case CPDFStandardStamp.accepted:
        return "Accepted";
      case CPDFStandardStamp.rejected:
        return "Rejected";
      case CPDFStandardStamp.witness:
        return "Witness";
      case CPDFStandardStamp.initialHere:
        return "InitialHere";
      case CPDFStandardStamp.signHere:
        return "SignHere";
      case CPDFStandardStamp.revised:
        return "revised";
      case CPDFStandardStamp.privateAccepted:
        return "PrivateMark#1";
      case CPDFStandardStamp.privateRejected:
        return "PrivateMark#2";
      case CPDFStandardStamp.privateRadioMark:
        return "PrivateMark#3";
      case CPDFStandardStamp.unknown:
        return "Unknown";
    }
  }
}

enum CPDFStampType {
  unknown,

  standard,

  text,

  image;
}

/// Adds event listener callbacks.
/// Use ComPDFKit.addEventListener(CPDFEvent event, CPDFOnEventsCallback callback) to register.
/// See example at example/lib/cpdf_event_listener_example.dart
/// Example:
/// controller.addEventListener(CPDFEvent.annotationsCreated, (event) {
///   debugPrint('ComPDFKit: Annotation created: Type=${event.runtimeType}');
///   printJsonString(jsonEncode(event));
/// });
enum CPDFEvent {
  /// Fired when an annotation is created.
  /// Data type: CPDFAnnotation and its subclasses.
  annotationsCreated,

  /// Fired when an annotation is selected.
  /// Data type: CPDFAnnotation and its subclasses.
  annotationsSelected,

  /// Fired when an annotation is deselected.
  /// Data type: CPDFAnnotation and its subclasses.
  /// Data may be null.
  annotationsDeselected,

  /// Fired when a form field is created.
  /// Data type: CPDFWidget and its subclasses.
  formFieldsCreated,

  /// Fired when a form field is selected.
  /// Data type: CPDFWidget and its subclasses.
  formFieldsSelected,

  /// Fired when a form field is deselected.
  /// Data type: CPDFWidget and its subclasses.
  /// Data may be null.
  formFieldsDeselected,

  /// Fired when a content editor element is selected.
  /// Data type: CPDFEditArea and its subclasses.
  /// image: CPDFEditImageArea
  /// text: CPDFEditTextArea
  editorSelectionSelected,

  /// Fired when a content editor element is deselected.
  /// No data returned.
  editorSelectionDeselected,
}
