// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';


/// {@category viewer-ui}
/// Called when the [CPDFReaderWidgetController] is ready.
typedef CPDFReaderWidgetCreatedCallback = void Function(
  CPDFReaderWidgetController controller,
);

/// Called when the current visible page changes.
typedef CPDFPageChangedCallback = void Function(int pageIndex);

/// Called when the document is saved.
typedef CPDFDocumentSaveCallback = void Function();

/// Called when user presses back in page edit dialog.
typedef CPDFPageEditDialogBackPressCallback = void Function();

/// Called when fill-screen mode changes.
typedef CPDFFillScreenChangedCallback = void Function(bool isFillScreen);

/// Called when the iOS back button is pressed.
typedef CPDFIOSClickBackPressedCallback = void Function();

/// Called when the native document is ready.
typedef CPDFDocumentIsReadyCallback = void Function();

/// Called when the main document area is tapped.
typedef CPDFOnTapMainDocAreaCallback = void Function();

/// Called when native side emits a custom event payload.
typedef CPDFOnEventsCallback = void Function(Object? data);

/// Called when a custom toolbar item is tapped.
typedef CPDFOnCustomToolbarItemTappedCallback = void Function(
  String identifier,
);

/// Called when annotation creation is prepared on the native side.
///
/// - [type]: The annotation type to be created.
/// - [annotation]: A pre-filled annotation payload, if available.
typedef CPDFOnAnnotationCreationPreparedCallback = void Function(
  CPDFAnnotationType type,
  CPDFAnnotation? annotation,
);

/// Callback triggered when a custom context menu item is tapped.
///
/// **Signature:**
/// `void Function(String identifier, dynamic event)`
///
/// - `identifier`: Unique identifier of the tapped custom menu item,
///   defined in `CPDFContextMenuItem`.
/// - `event`: Event payload containing detailed information related to
///   the tap action. The structure varies depending on the context menu type.
///
/// ---
///
/// **Example Usage:**
/// ```dart
/// onCustomContextMenuItemTappedCallback: (String identifier, dynamic event) {
///   debugPrint('Custom menu tapped: $identifier, event: $event');
/// }
/// ```
///
/// ---
///
/// # **Event Payload Structure**
///
/// ## **1. global**
///
/// ### screenshot
/// ```dart
/// event = {
///   "identifier": String,
///   "image": Uint8List,
/// };
/// ```
///
/// ---
///
/// ## **2. viewMode**
///
/// ### textSelect
/// ```dart
/// event = {
///   "identifier": String,
///   "text": String,
///   "rect": CPDFRectF,
///   "pageIndex": int,
/// };
/// ```
///
/// ---
///
/// ## **3. annotationMode**
///
/// ### textSelect
/// ```dart
/// event = {
///   "identifier": String,
///   "text": String,
///   "rect": CPDFRectF,
///   "pageIndex": int,
/// };
/// ```
///
/// ### longPressContent
/// ```dart
/// event = {
///   "identifier": String,
///   "point": CPDFPointF,
///   "pageIndex": int,
/// };
/// ```
///
/// ### markupContent / soundContent / inkContent
/// ### shapeContent / freeTextContent / signStampContent
/// ### stampContent / linkContent
/// ```dart
/// event = {
///   "annotation": CPDFAnnotation,
/// };
/// ```
///
/// ---
///
/// ## **4. contentEditorMode**
///
/// ### editTextAreaContent / editSelectTextContent
/// ```dart
/// event = {
///   "editArea": CPDFEditTextArea,
/// };
/// ```
///
/// ### imageAreaContent
/// ```dart
/// event = {
///   "imageArea": CPDFEditImageArea,
/// };
/// ```
///
/// ### editPathContent
/// ```dart
/// event = {
///   "editArea": CPDFEditPathArea,
/// };
/// ```
///
/// ### longPressWithEditTextMode / longPressWithEditImageMode / longPressWithAllMode
/// ```dart
/// event = {
///   "point": Offset,
///   "pageIndex": int,
/// };
/// ```
///
/// ---
///
/// ## **5. formMode**
///
/// ### textField / checkBox / radioButton
/// ### listBox / comboBox / signatureField / pushButton
/// ```dart
/// event = {
///   "widget": CPDFWidget,
/// };
/// ```
///
/// ---
///
typedef CPDFOnCustomContextMenuItemTappedCallback = void Function(
  String identifier,
  dynamic event,
);
