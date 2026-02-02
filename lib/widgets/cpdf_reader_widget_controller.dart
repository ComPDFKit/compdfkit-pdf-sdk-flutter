// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:async';
import 'dart:io';
import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_annotation_registry.dart';
import 'package:compdfkit_flutter/annotation/cpdf_text_stamp.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_registry.dart';
import 'package:compdfkit_flutter/configuration/attributes/cpdf_annot_attr_base.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_area.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_image_area.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_manager.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_text_area.dart';
import 'package:compdfkit_flutter/history/cpdf_annotation_history_manager.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../configuration/cpdf_options.dart';
import '../document/cpdf_document.dart';
import '../util/extension/cpdf_color_extension.dart';
import 'cpdf_reader_widget.dart';

/// PDF Reader Widget Controller
///
/// {@category viewer-ui}
///
/// Examples:
/// ```dart
/// Scaffold(
///         resizeToAvoidBottomInset: false,
///         appBar: AppBar(title: const Text('CPDFReaderWidget Example')),
///         body: CPDFReaderWidget(
///           document: widget.documentPath,
///           configuration: CPDFConfiguration(),
///           onCreated: (controller) {
///             setState(() {
///               _controller = controller;
///             });
///           },
///         ));
/// ```
class CPDFReaderWidgetController {
  late MethodChannel _channel;

  late CPDFDocument _document;

  late CPDFEditManager _editManager;

  late CPDFAnnotationHistoryManager _annotationHistoryManager;

  final Completer<void> _readyCompleter = Completer<void>();

  Future<void> get ready => _readyCompleter.future;

  final Map<CPDFEvent, List<Function(dynamic eventData)>> _eventListeners = {};

  CPDFReaderWidgetController(int id,
      {CPDFPageChangedCallback? onPageChanged,
      CPDFDocumentSaveCallback? saveCallback,
      CPDFPageEditDialogBackPressCallback? onPageEditBackPress,
      CPDFFillScreenChangedCallback? onFillScreenChanged,
      CPDFIOSClickBackPressedCallback? onIOSClickBackPressed,
      CPDFOnTapMainDocAreaCallback? onTapMainDocArea,
      CPDFOnCustomToolbarItemTappedCallback? onCustomToolbarItemTapped,
      CPDFOnAnnotationCreationPreparedCallback? onAnnotationCreationPrepared,
      CPDFOnCustomContextMenuItemTappedCallback?
          onCustomContextMenuItemTapped}) {
    _channel = MethodChannel('com.compdfkit.flutter.ui.pdfviewer.$id');
    _annotationHistoryManager = CPDFAnnotationHistoryManager(_channel);
    _editManager = CPDFEditManager(_channel);
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onPageChanged':
          var pageIndex = call.arguments['pageIndex'];
          onPageChanged?.call(pageIndex);
          break;
        case 'saveDocument':
          saveCallback?.call();
          break;
        case 'onPageEditDialogBackPress':
          onPageEditBackPress?.call();
          break;
        case 'onFullScreenChanged':
          bool isFillScreen = call.arguments;
          onFillScreenChanged?.call(isFillScreen);
          break;
        case 'onIOSClickBackPressed':
          onIOSClickBackPressed?.call();
          break;
        case 'onDocumentIsReady':
          _readyCompleter.complete();
          break;
        case 'onAnnotationHistoryChanged':
          _annotationHistoryManager.handleMethodCall(call);
          break;
        case 'onTapMainDocArea':
          onTapMainDocArea?.call();
          break;
        case 'onContentEditorHistoryChanged':
          _editManager.historyManager.handleMethodCall(call);
          break;
        case 'onCustomToolbarItemTapped':
          onCustomToolbarItemTapped?.call(call.arguments);
          break;
        case 'annotationsCreated':
          dynamic annotationData = call.arguments;
          final map = Map<String, dynamic>.from(annotationData);
          final annotation = CPDFAnnotationRegistry.fromJson(map);
          _eventListeners[CPDFEvent.annotationsCreated]
              ?.forEach((cb) => cb(annotation));
          break;
        case 'annotationsSelected':
          dynamic annotationData = call.arguments;
          final map = Map<String, dynamic>.from(annotationData);
          final annotation = CPDFAnnotationRegistry.fromJson(map);
          _eventListeners[CPDFEvent.annotationsSelected]
              ?.forEach((cb) => cb(annotation));
          break;
        case 'annotationsDeselected':
          dynamic annotationData = call.arguments;
          dynamic data;
          if (annotationData != null) {
            final map = Map<String, dynamic>.from(annotationData);
            data = CPDFAnnotationRegistry.fromJson(map);
          }
          _eventListeners[CPDFEvent.annotationsDeselected]
              ?.forEach((cb) => cb(data));
          break;
        case 'formFieldsCreated':
          dynamic widgetData = call.arguments;
          final map = Map<String, dynamic>.from(widgetData);
          final widget = CPDFWidgetRegistry.fromJson(map);
          _eventListeners[CPDFEvent.formFieldsCreated]
              ?.forEach((cb) => cb(widget));
          break;
        case 'formFieldsSelected':
          dynamic widgetData = call.arguments;
          final map = Map<String, dynamic>.from(widgetData);
          final widget = CPDFWidgetRegistry.fromJson(map);
          _eventListeners[CPDFEvent.formFieldsSelected]
              ?.forEach((cb) => cb(widget));
          break;
        case 'formFieldsDeselected':
          dynamic widgetData = call.arguments;
          dynamic data;
          if (widgetData != null) {
            final map = Map<String, dynamic>.from(widgetData);
            data = CPDFWidgetRegistry.fromJson(map);
          }
          _eventListeners[CPDFEvent.formFieldsDeselected]
              ?.forEach((cb) => cb(data));
          break;
        case 'editorSelectionDeselected':
          _eventListeners[CPDFEvent.editorSelectionDeselected]
              ?.forEach((cb) => cb(null));
          break;
        case 'editorSelectionSelected':
          dynamic type = call.arguments['type'];
          dynamic editAreaData = call.arguments;
          final map = Map<String, dynamic>.from(editAreaData);
          CPDFEditArea? editArea;
          if (type == 'text') {
            editArea = CPDFEditTextArea.fromJson(map);
          } else if (type == 'image') {
            editArea = CPDFEditImageArea.fromJson(map);
          } else if (type == 'path') {
            editArea = CPDFEditArea.fromJson(map);
          }
          _eventListeners[CPDFEvent.editorSelectionSelected]
              ?.forEach((cb) => cb(editArea));
          break;
        case 'onAnnotationCreationPrepared':
          String typeName = call.arguments['type'];
          CPDFAnnotationType type =
              CPDFAnnotationType.values.firstWhere((e) => e.name == typeName);
          if (call.arguments['annotation'] != null) {
            dynamic annotationData = call.arguments['annotation'];
            final map = Map<String, dynamic>.from(annotationData);
            final annotation = CPDFAnnotationRegistry.fromJson(map);
            onAnnotationCreationPrepared?.call(type, annotation);
          } else {
            onAnnotationCreationPrepared?.call(type, null);
          }
          break;
        case 'onCustomContextMenuItemTapped':
          dynamic data = call.arguments;
          final dataMap = Map<String, dynamic>.from(data);
          Map<String, dynamic> resultMap = {};
          for (var element in dataMap.entries) {
            try {
              switch (element.key) {
                case 'rect':
                  final rectF = CPDFRectF.fromJson(
                      Map<String, dynamic>.from(element.value));
                  resultMap['rect'] = rectF;
                  break;
                case 'annotation':
                  final annotation = CPDFAnnotationRegistry.fromJson(
                      Map<String, dynamic>.from(element.value));
                  resultMap['annotation'] = annotation;
                  break;
                case 'widget':
                  final widget = CPDFWidgetRegistry.fromJson(
                      Map<String, dynamic>.from(element.value));
                  resultMap['widget'] = widget;
                  break;
                case 'editArea':
                  final editAreaMap = Map<String, dynamic>.from(element.value);
                  if (editAreaMap['type'] == 'text') {
                    final editTextArea = CPDFEditTextArea.fromJson(editAreaMap);
                    resultMap['editArea'] = editTextArea;
                  } else if (editAreaMap['type'] == 'image') {
                    final editImageArea =
                        CPDFEditImageArea.fromJson(editAreaMap);
                    resultMap['editArea'] = editImageArea;
                  } else {
                    final editArea = CPDFEditArea.fromJson(editAreaMap);
                    resultMap['editArea'] = editArea;
                  }
                  break;
                case 'point':
                  double x = (element.value['x'] as num).toDouble();
                  double y = (element.value['y'] as num).toDouble();
                  resultMap['point'] = {
                    'x': double.parse(x.toStringAsFixed(2)),
                    'y': double.parse(y.toStringAsFixed(2))
                  };
                  break;
                default:
                  if (element.key != 'customEventType') {
                    resultMap[element.key] = element.value;
                  }
                  break;
              }
            } catch (e) {
              debugPrint(
                  'ComPDFKit-Flutter: onCustomContextMenuItemTapped parse error: $e');
            }
          }
          final identifier = call.arguments["identifier"];
          onCustomContextMenuItemTapped?.call(identifier, resultMap);
          break;
      }
    });
    _document = CPDFDocument.withController(id);
  }

  CPDFDocument get document => _document;

  /// Get the annotation history manager
  /// This manager is used to handle annotation history operations such as undo and redo.
  /// Example:
  /// ```dart
  /// CPDFAnnotationHistoryManager historyManager = _controller.annotationHistoryManager;
  /// ```
  CPDFAnnotationHistoryManager get annotationHistoryManager =>
      _annotationHistoryManager;

  /// Get the edit manager
  /// This manager is used to handle content editing operations such as changing edit types.
  /// Example:
  /// ```dart
  /// CPDFEditManager? editManager = _controller.editManager;
  /// ```
  CPDFEditManager get editManager => _editManager;

  /// Save document
  ///
  /// example:
  /// ```dart
  /// bool result = await _controller.save();
  /// ```
  /// Return value: **true** if the save is successful,
  /// **false** if the save fails.
  @Deprecated("use CPDFDocument().save()")
  Future<bool> save() async {
    return await document.save();
  }

  /// Set the page scale
  /// Value Range: 1.0~5.0
  ///
  /// example:
  /// ```dart
  /// await _controller.setScale(1.5);
  /// ```
  Future<void> setScale(double scale) async {
    await _channel.invokeMethod('set_scale', scale);
  }

  /// Get the page scale
  ///
  /// example:
  /// ```dart
  /// double scaleValue = await _controller.getScale();
  /// ```
  Future<double> getScale() async {
    return await _channel.invokeMethod('get_scale');
  }

  /// Whether allow to scale.
  /// Default : true
  ///
  /// example:
  /// ```dart
  /// await _controller.setCanScale(canScale);
  /// ```
  Future<void> setCanScale(bool canScale) async {
    assert(Platform.isAndroid, 'This method is only supported on Android');
    await _channel.invokeMethod('set_can_scale', canScale);
  }

  /// Sets background color of reader.
  /// The color of each document space will be set to 75% of [color] transparency
  ///
  /// example:
  /// ```dart
  /// await _controller.setReadBackgroundColor(theme: CPDFThemes.light);
  /// ```
  Future<void> setReadBackgroundColor(CPDFThemes theme) async {
    await _channel.invokeMethod('set_read_background_color',
        {'displayMode': theme.type.name, 'color': theme.color});
  }

  Future<void> setWidgetBackgroundColor(Color color) async {
    return await _channel.invokeMethod(
        'set_widget_background_color', color.toHex());
  }

  /// Get background color of reader.
  ///
  /// example:
  /// ```dart
  /// Color color = await _controller.getReadBackgroundColor();
  /// ```
  Future<Color> getReadBackgroundColor() async {
    String hexColor = await _channel.invokeMethod('get_read_background_color');
    return HexColor.fromHex(hexColor);
  }

  /// Sets whether to display highlight Form Field.
  /// [isFormFieldHighlight] : true to display highlight Form Field.
  ///
  /// example:
  /// ```dart
  /// await _controller.setFormFieldHighlight(true);
  /// ```
  Future<void> setFormFieldHighlight(bool isFormFieldHighlight) async {
    await _channel.invokeMethod(
        'set_form_field_highlight', isFormFieldHighlight);
  }

  /// Whether to display highlight Form Field.
  ///
  /// example:
  /// ```dart
  /// bool isFormFieldHighlight = await _controller.isFormFieldHighlight();
  /// ```
  Future<bool> isFormFieldHighlight() async {
    return await _channel.invokeMethod('is_form_field_highlight');
  }

  /// Sets whether to display highlight Link.
  ///
  /// [isLinkHighlight] : Whether to highlight Link.
  ///
  /// example:
  /// ```dart
  /// await _controller.setLinkHighlight(true);
  /// ```
  Future<void> setLinkHighlight(bool isLinkHighlight) async {
    await _channel.invokeMethod('set_link_highlight', isLinkHighlight);
  }

  /// Whether to display highlight Link.
  ///
  /// example:
  /// ```dart
  /// bool isLinkHighlight = await _controller.isLinkHighlight();
  /// ```
  Future<bool> isLinkHighlight() async {
    return await _channel.invokeMethod('is_link_highlight');
  }

  /// Sets whether it is vertical scroll mode.
  ///
  /// [isVerticalMode] : Whether it is vertical scroll mode.
  ///
  /// example:
  /// ```dart
  /// await _controller.setVerticalMode(true);
  /// ```
  Future<void> setVerticalMode(bool isVerticalMode) async {
    await _channel.invokeMethod('set_vertical_mode', isVerticalMode);
  }

  /// Whether it is vertical scroll mode.
  ///
  /// example:
  /// ```dart
  /// bool isVerticalMode = await _controller.isVerticalMode();
  /// ```
  Future<bool> isVerticalMode() async {
    return await _channel.invokeMethod('is_vertical_mode');
  }

  /// Set document page spacing
  ///
  /// [spacing] the spacing between pages
  ///
  /// example:
  /// ```dart
  /// await _controller.setMargins(const CPDFEdgeInsets.symmetric(horizontal: 10, vertical: 10));
  /// ```
  Future<void> setMargins(CPDFEdgeInsets edgeInsets) async {
    await _channel.invokeMethod('set_margin', edgeInsets.toJson());
  }

  /// Sets the spacing between pages. This method is supported only on Android.
  ///
  /// - For iOS, use the [setMargins] method instead.
  ///   The spacing between pages is equal to the value of [CPDFEdgeInsets.top].
  ///
  /// Parameters:
  /// [spacing] The space between pages, in pixels.
  ///
  /// example:
  /// ```dart
  /// await _controller.setPageSpacing(10);
  /// ```
  Future<void> setPageSpacing(int spacing) async {
    await _channel.invokeMethod('set_page_spacing', spacing);
  }

  /// Sets whether it is continuous scroll mode.
  ///
  /// [isContinueMode] Whether it is continuous scroll mode.
  ///
  /// example:
  /// ```dart
  /// await _controller.setContinueMode(true);
  /// ```
  Future<void> setContinueMode(bool isContinueMode) async {
    await _channel.invokeMethod('set_continue_mode', isContinueMode);
  }

  /// Whether it is continuous scroll mode.
  ///
  /// example:
  /// ```dart
  /// bool isContinueMode = await _controller.isContinueMode();
  /// ```
  Future<bool> isContinueMode() async {
    return await _channel.invokeMethod('is_continue_mode');
  }

  /// Sets whether it is double page mode.
  ///
  /// [isDoublePageMode] Whether it is double page mode.
  ///
  /// example:
  /// ```dart
  /// await _controller.setDoublePageMode(true);
  /// ```
  Future<void> setDoublePageMode(bool isDoublePageMode) async {
    await _channel.invokeMethod('set_double_page_mode', isDoublePageMode);
  }

  /// Whether it is double page mode.
  ///is_
  /// example:
  /// ```dart
  /// bool isDoublePageMode = await _controller.isDoublePageMode();
  /// ```
  Future<bool> isDoublePageMode() async {
    return await _channel.invokeMethod('is_double_page_mode');
  }

  /// Sets whether it is cover page mode.
  ///
  /// example:
  /// ```dart
  /// await _controller.setCoverPageMode(true);
  /// ```
  Future<void> setCoverPageMode(bool coverPageMode) async {
    await _channel.invokeMethod('set_cover_page_mode', coverPageMode);
  }

  /// Whether it is cover page mode.
  ///
  /// example:
  /// ```dart
  /// bool isCoverPageMode = await _controller.isCoverPageMode();
  /// ```
  Future<bool> isCoverPageMode() async {
    return await _channel.invokeMethod('is_cover_page_mode');
  }

  /// Sets whether it is crop mode.
  ///
  /// `isCropMode` Whether crop mode is enabled.
  ///
  /// example:
  /// ```dart
  /// _controller.setCropMode(true);
  /// ```
  Future<void> setCropMode(bool isCropMode) async {
    await _channel.invokeMethod('set_crop_mode', isCropMode);
  }

  /// Whether it is crop mode.
  ///
  /// example:
  /// ```dart
  /// bool isCropMode = await _controller.isCropMode();
  /// ```
  Future<bool> isCropMode() async {
    return await _channel.invokeMethod('is_crop_mode');
  }

  /// Jump to the index page.
  ///
  /// [pageIndex] The index of the page to jump.
  /// [animated] only for iOS, whether to use animation when jumping.
  /// [rectList] The rects to display in the page.
  /// The coordinate system of the rectangle uses the bottom-left corner of the
  /// page as the origin, with the x-axis pointing to the right and the y-axis pointing upwards.
  ///
  /// example:
  /// ```dart
  /// _controller.setDisplayPageIndex(
  ///   pageIndex: 1,
  ///   animated: true,
  ///   rectList: [CPDFRectF(left: 0, top: 0, right: 100, bottom: 100)]
  ///   );
  /// ```
  Future<void> setDisplayPageIndex({
    required int pageIndex,
    bool animated = true,
    List<CPDFRectF> rectList = const [],
  }) async {
    await _channel.invokeMethod('set_display_page_index', {
      'pageIndex': pageIndex,
      'animated': animated,
      'rectList': rectList.map((e) => e.toJson()).toList(),
    });
  }

  /// get current page index
  ///
  /// example:
  /// ```dart
  /// int currentPageIndex = await _controller.getCurrentPageIndex();
  /// ```
  Future<int> getCurrentPageIndex() async {
    return await _channel.invokeMethod('get_current_page_index');
  }

  /// In the single page mode, set whether all pages keep the same width and the original page keeps the same width as readerView
  ///
  /// [isSame] true: All pages keep the same width, the original state keeps the same width as readerView; false: Show in the actual width of page
  ///
  /// example:
  /// ```dart
  /// _controller.setPageSameWidth(true);
  /// ```
  Future<void> setPageSameWidth(bool isSame) async {
    assert(Platform.isAndroid, 'This method is only supported on Android');
    await _channel.invokeMethod('set_page_same_width', isSame);
  }

  /// Gets whether the specified [pageIndex] is displayed on the screen
  ///
  /// example:
  /// ```dart
  /// bool isPageInScreen = await _controller.isPageInScreen(1);
  /// ```
  Future<bool> isPageInScreen(int pageIndex) async {
    assert(Platform.isAndroid, 'This method is only supported on Android');
    return await _channel.invokeMethod('is_page_in_screen', pageIndex);
  }

  /// Sets whether to fix the position of the non-swipe direction when zooming in for reading.
  ///
  /// example:
  /// ```dart
  /// await _controller.setFixedScroll(true);
  /// ```
  ///
  /// [isFixedScroll] true: fixed position; false: not fixed position; Set false by default
  ///
  Future<void> setFixedScroll(bool isFixedScroll) async {
    assert(Platform.isAndroid, 'This method is only supported on Android');
    await _channel.invokeMethod('set_fixed_scroll', isFixedScroll);
  }

  /// Check the document for modifications
  ///
  /// example:
  /// ```dart
  /// bool hasChange = await document.hasChange();
  /// ```
  @Deprecated("use CPDFDocument().hasChange()")
  Future<bool> hasChange() async {
    return await _document.hasChange();
  }

  /// Switch the mode displayed by the current CPDFReaderWidget.
  /// Please see [CPDFViewMode] for available modes.
  ///
  /// example:
  /// ```dart
  /// await setPreviewMode(CPDFViewMode.viewer);
  /// ```
  Future<void> setPreviewMode(CPDFViewMode viewMode) async {
    await _channel.invokeMethod('set_preview_mode', viewMode.name);
  }

  /// Get the currently displayed mode
  ///
  /// example:
  /// ```dart
  /// CPDFViewMode mode = await controller.getPreviewMode();
  /// ```
  Future<CPDFViewMode> getPreviewMode() async {
    String modeName = await _channel.invokeMethod('get_preview_mode');
    return CPDFViewMode.values.where((e) => e.name == modeName).first;
  }

  /// Displays the thumbnail view. When [editMode] is `true`, the page enters edit mode, allowing operations such as insert, delete, extract, etc.
  ///
  /// Example:
  /// ```dart
  /// await controller.showThumbnailView(false);
  /// ```
  Future<void> showThumbnailView(bool editMode) async {
    await _channel.invokeMethod('show_thumbnail_view', editMode);
  }

  /// Displays the BOTA view, which includes the document outline, bookmarks, and annotation list.
  ///
  /// Example:
  /// ```dart
  /// await controller.showBotaView();
  /// ```
  Future<void> showBotaView() async {
    await _channel.invokeMethod('show_bota_view');
  }

  /// Displays the **Add Watermark** view, allowing users to add
  /// text and/or image watermarks to the current document.
  ///
  /// The watermark can be configured through [CPDFWatermarkConfig].
  /// By default, both text and image watermark types are enabled.
  ///
  /// Example:
  /// ```dart
  /// final imagePath = await extractAsset(context, 'images/ic_logo.png');
  /// await controller.showAddWatermarkView(
  ///   config: CPDFWatermarkConfig(
  ///     saveAsNewFile: true,
  ///     types: [CPDFWatermarkType.text, CPDFWatermarkType.image],
  ///     image: imagePath.path,
  ///     text: 'ComPDFKit Flutter',
  ///     textSize: 40,
  ///     textColor: Colors.red,
  ///     rotation: -45,
  ///     opacity: 180,
  ///     scale: 2.0,
  ///     isFront: true,
  ///   ),
  /// );
  /// ```
  ///
  /// On **Android**, images can be provided either as:
  /// - A drawable resource name (`'ic_logo'`) → `R.drawable.ic_logo`
  /// - A file path
  ///
  /// On **iOS**, images should be provided as:
  /// - A bundled image file name (`'ic_logo'`)
  /// - A file path
  Future<void> showAddWatermarkView({CPDFWatermarkConfig? config}) async {
    await _channel.invokeMethod('show_add_watermark_view', config?.toJson());
  }

  /// Displays the document security settings view, allowing users to configure document security options.
  ///
  /// Example:
  /// ```dart
  /// await controller.showSecurityView();
  /// ```
  Future<void> showSecurityView() async {
    await _channel.invokeMethod('show_security_view');
  }

  /// Displays the display settings view, where users can configure options such as scroll direction, scroll mode, and themes.
  ///
  /// Example:
  /// ```dart
  /// await controller.showDisplaySettingView();
  /// ```
  Future<void> showDisplaySettingView() async {
    await _channel.invokeMethod('show_display_settings_view');
  }

  /// Enters snip mode, allowing users to capture screenshots.
  ///
  /// Example:
  /// ```dart
  /// await controller.enterSnipMode();
  /// ```
  Future<void> enterSnipMode() async {
    await _channel.invokeMethod('enter_snip_mode');
  }

  /// Exits snip mode, stopping the screenshot capture.
  ///
  /// Example:
  /// ```dart
  /// await controller.exitSnipMode();
  /// ```
  Future<void> exitSnipMode() async {
    await _channel.invokeMethod('exit_snip_mode');
  }

  Future<void> reloadPages() async {
    await _channel.invokeMethod('reload_pages');
  }

  Future<void> reloadPages2() async {
    await _channel
        .invokeMethod(Platform.isAndroid ? 'reload_pages_2' : 'reload_pages');
  }

  /// Used to add a specified annotation type when touching the page in annotation mode
  /// This method is only available in [CPDFViewMode.annotations] mode.
  /// Example:
  /// ```dart
  /// await controller.setAnnotationMode(CPDFAnnotationType.note);
  /// ```
  /// Throws an exception if called in a mode other than [CPDFViewMode.annotations].
  Future<void> setAnnotationMode(CPDFAnnotationType type) async {
    var viewMode = await getPreviewMode();
    if (viewMode != CPDFViewMode.annotations) {
      throw Exception(
          'setAnnotationMode is only available in CPDFViewMode.annotations mode, current mode is $viewMode');
    }
    await _channel.invokeMethod('set_annotation_mode', type.name);
  }

  /// Get the type of annotation added to the current touch page
  /// This method is only available in [CPDFViewMode.annotations] mode.
  /// Example:
  /// ```dart
  /// CPDFAnnotationType type = await controller.getAnnotationMode();
  /// ```
  Future<CPDFAnnotationType> getAnnotationMode() async {
    String typeName = await _channel.invokeMethod('get_annotation_mode');
    return CPDFAnnotationType.values.firstWhere((e) => e.name == typeName);
  }

  /// Used to add a specified form field type when touching the page in form creation mode
  /// This method is only available in [CPDFViewMode.forms] mode.
  /// Example:
  /// ```dart
  /// await controller.setFormCreationMode(CPDFFormType.text);
  /// ```
  /// Throws an exception if called in a mode other than [CPDFViewMode.forms].
  Future<void> setFormCreationMode(CPDFFormType type) async {
    var viewMode = await getPreviewMode();
    if (viewMode != CPDFViewMode.forms) {
      throw Exception(
          'setFormCreationMode is only available in CPDFViewMode.forms mode, current mode is $viewMode');
    }
    await _channel.invokeMethod('set_form_creation_mode', type.name);
  }

  /// Exit form creation mode, equivalent to setting the form creation type to [CPDFFormType.unknown]
  /// This method is only available in [CPDFViewMode.forms] mode.
  /// Example:
  /// ```dart
  /// await controller.exitFormCreationMode();
  /// ```
  Future<void> exitFormCreationMode() async {
    await setFormCreationMode(CPDFFormType.unknown);
  }

  /// Get the type of form field added to the current touch page
  /// This method is only available in [CPDFViewMode.forms] mode.
  /// Example:
  /// ```dart
  /// CPDFFormType type = await controller.getFormCreationMode();
  /// ```
  Future<CPDFFormType> getFormCreationMode() async {
    String typeName = await _channel.invokeMethod('get_form_creation_mode');
    return CPDFFormType.values.firstWhere((e) => e.name == typeName);
  }

  /// Verify the status of the digital signature in the document and display the verification result on the screen.
  /// If the document contains a digital signature, a status view will be displayed at the top of the document indicating the verification result.
  /// If the document does not contain a digital signature, no status view will be displayed.
  /// Example:
  /// ```dart
  /// await controller.verifyDigitalSignatureStatus();
  /// ```
  Future<void> verifyDigitalSignatureStatus() async {
    await _channel.invokeMethod('verify_digital_signature_status');
  }

  /// Hide the digital signature status view.
  /// This method can be used to hide the digital signature status view that is displayed after calling [verifyDigitalSignatureStatus].
  /// Example:
  /// ```dart
  /// await controller.hideDigitalSignStatusView();
  /// ```
  Future<void> hideDigitalSignStatusView() async {
    await _channel.invokeMethod('hide_digital_sign_status_view');
  }

  /// Clear the rectangular area set when jumping to the page number through controller.setDisplayPageIndex
  /// Example:
  /// ```dart
  /// await controller.clearDisplayRect();
  /// ```
  Future<void> clearDisplayRect() async {
    return await _channel.invokeMethod('clear_display_rect');
  }

  /// Dismiss the context menu if it is currently displayed.
  /// Example:
  /// ```dart
  /// await controller.dismissContextMenu();
  /// ```
  Future<void> dismissContextMenu() async {
    return await _channel.invokeMethod('dismiss_context_menu');
  }

  /// Show the text search view.
  /// Example:
  /// ```dart
  /// await controller.showTextSearchView();
  /// ```
  Future<void> showTextSearchView() async {
    return await _channel.invokeMethod('show_text_search_view');
  }

  /// Hide the text search view if it is currently displayed.
  /// Example:
  /// ```dart
  /// await controller.hideTextSearchView();
  /// ```
  Future<void> hideTextSearchView() async {
    return await _channel.invokeMethod('hide_text_search_view');
  }

  /// Save the currently drawing ink annotation
  /// Example:
  /// ```dart
  /// await controller.saveCurrentInk();
  /// ```
  Future<void> saveCurrentInk() async {
    return await _channel.invokeMethod('save_current_ink');
  }

  /// Save the currently drawing pencil annotation
  /// This method is only available on the iOS platform.
  /// Example:
  /// ```dart
  /// await controller.saveCurrentPencil();
  /// ```
  /// Throws an exception if called on a platform other than iOS.
  Future<void> saveCurrentPencil() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      throw Exception('saveCurrentPencil is only available on iOS platform');
    }
    return await _channel.invokeMethod('save_current_pencil');
  }

  /// Displays the default properties panel for the specified annotation type.
  ///
  /// Only some annotation types are supported. If an unsupported type is passed in
  /// (such as eraser, unknown, signature, stamp, sound, image, link, etc.),
  /// an exception will be thrown.
  ///
  /// Parameters:
  /// - [type] The annotation type [CPDFAnnotationType] for which to display the properties panel.
  ///
  /// Exceptions:
  /// - If an unsupported annotation type is passed in, an [Exception] will be thrown.
  ///
  /// Example:
  /// ```dart
  /// await controller.showDefaultAnnotationPropertiesView(CPDFAnnotationType.highlight);
  /// ```
  Future<void> showDefaultAnnotationPropertiesView(
      CPDFAnnotationType type) async {
    const notSupportType = [
      CPDFAnnotationType.ink_eraser,
      CPDFAnnotationType.unknown,
      CPDFAnnotationType.signature,
      CPDFAnnotationType.stamp,
      CPDFAnnotationType.sound,
      CPDFAnnotationType.pictures,
      CPDFAnnotationType.link,
    ];
    if (notSupportType.contains(type)) {
      throw Exception(
          'This type:$type of annotation is not supported, please select another type.');
    }
    return await _channel.invokeMethod(
        'show_default_annotation_properties_view', type.name);
  }

  /// Displays the properties panel for the specified annotation.
  /// Only some annotation types are supported. If an unsupported type is passed in
  /// (such as eraser, unknown, signature, stamp, sound, image, link, etc.),
  /// an exception will be thrown.
  ///
  /// Parameters:
  /// - [annotation] The annotation [CPDFAnnotation] for which to display the properties panel.
  ///
  /// Exceptions:
  /// - If an unsupported annotation type is passed in, an [Exception] will be thrown
  ///
  /// Example:
  /// ```dart
  /// await controller.showAnnotationPropertiesView(annotation);
  /// ```
  Future<void> showAnnotationPropertiesView(CPDFAnnotation annotation) async {
    const notSupportType = [
      CPDFAnnotationType.ink_eraser,
      CPDFAnnotationType.unknown,
      CPDFAnnotationType.signature,
      CPDFAnnotationType.stamp,
      CPDFAnnotationType.sound,
      CPDFAnnotationType.pictures,
      CPDFAnnotationType.link,
    ];
    if (notSupportType.contains(annotation.type)) {
      throw Exception(
          'This type:${annotation.type} of annotation is not supported, please select another type.');
    }
    return await _channel.invokeMethod(
        'show_annotation_properties_view', annotation.toJson());
  }

  /// Displays the properties panel for the specified form field widget.
  /// Only some form field types are supported. If an unsupported type is passed in
  /// (such as signature fields, unknown, etc.),
  /// an exception will be thrown.
  ///
  /// Parameters:
  /// - [widget] The form field widget [CPDFWidget] for which to display the properties panel.
  ///
  /// Exceptions:
  /// - If an unsupported form field type is passed in, an [Exception] will be thrown
  ///
  /// Example:
  /// ```dart
  /// await controller.showWidgetPropertiesView(widget);
  /// ```
  Future<void> showWidgetPropertiesView(CPDFWidget widget) async {
    if (widget.type == CPDFFormType.signaturesFields ||
        widget.type == CPDFFormType.unknown) {
      throw Exception(
          'This type:${widget.type} of form field is not supported, please select another type.');
    }
    return await _channel.invokeMethod(
        'show_widget_properties_view', widget.toJson());
  }

  /// Displays the properties panel for the specified edit area.
  /// Only some edit area types are supported. If an unsupported type is passed in
  /// (such as path type),
  /// an exception will be thrown.
  ///
  /// Parameters:
  /// - [editArea] The edit area [CPDFEditArea] for which to display the properties panel.
  ///
  /// Exceptions:
  /// - If an unsupported edit area type is passed in, an [Exception] will be thrown
  /// Example:
  /// ```dart
  /// await controller.showEditAreaPropertiesView(editArea);
  /// ```
  Future<void> showEditAreaPropertiesView(CPDFEditArea editArea) async {
    if (editArea.type == CPDFEditAreaType.path) {
      throw Exception(
          'This type:${editArea.type} of edit area is not supported, please select another type.');
    }
    return await _channel.invokeMethod(
        'show_edit_area_properties_view', editArea.toJson());
  }

  /// Add event listener for specific [event] with [callback].
  /// The [callback] will be invoked when the specified event occurs,
  /// and the event data will be passed as a parameter to the callback function.
  /// Example:
  /// ```dart
  /// controller.addEventListener(CPDFEvent.annotationsCreated, (event) {
  ///   debugPrint('Annotation created: ${event.toString()}');
  /// });
  /// ```
  Future<void> addEventListener(
      CPDFEvent event, Function(dynamic) callback) async {
    debugPrint('ComPDFKit-Flutter: addEventListener for event: $event');
    _eventListeners.putIfAbsent(event, () => []).add(callback);
  }

  /// show or hide annotations layer
  /// Example:
  /// ```dart
  /// await controller.setAnnotationsVisible(true); // show annotations
  /// await controller.setAnnotationsVisible(false); // hide annotations
  /// ```
  Future<void> setAnnotationsVisible(bool visible) async {
    return await _channel.invokeMethod('annotations_visible', visible);
  }

  /// check if annotations layer is visible
  /// Example:
  /// ```dart
  /// bool isVisible = await controller.isAnnotationsVisible();
  /// ```
  Future<bool> isAnnotationsVisible() async {
    return await _channel.invokeMethod('is_annotations_visible');
  }

  /// Pre-configure the next signature annotation to be inserted when the user taps the page.
  /// only use in signature creation mode. [CPDFAnnotationType.signature]
  /// Example:
  /// ```dart
  /// // first enter signature creation mode
  /// await controller.setAnnotationMode(CPDFAnnotationType.signature);
  ///
  /// // then prepare the signature image path
  /// await controller.prepareNextSignature('/path/to/signature.png');
  ///
  /// // now, when the user taps the page, the signature will be inserted using the specified image
  /// ```
  Future<void> prepareNextSignature(String signaturePath) async {
    return await _channel.invokeMethod('prepare_next_signature', signaturePath);
  }

  /// Pre-configure the next stamp annotation to be inserted when the user taps the page.
  ///
  /// Usage:
  /// Call this after entering stamp creation mode to specify which kind of stamp (image / standard / text) will be inserted on the next tap.
  ///
  /// Constraints:
  /// Exactly one of \`imagePath\`, \`standardStamp\`, or \`textStamp\` must be provided. Supplying none or more than one throws an \`ArgumentError\`.
  ///
  /// Parameters:
  /// [imagePath] Path to an image stamp. Android: file path or drawable resource name. iOS: file path or bundled image name.
  /// [standardStamp] Built-in standard stamp enum value (e.g. \`CPDFStandardStamp.approved\`).
  /// [textStamp] A \`CPDFTextStamp\` instance defining custom text, colors, size, etc.
  ///
  /// Returns:
  /// A \`Future<void>\` that completes when the native side is notified.
  ///
  /// Exceptions:
  /// \`ArgumentError\`: Thrown if the "exactly one parameter" rule is violated. Message is in English.
  ///
  /// Example:
  /// ```dart
  /// await controller.prepareNextStamp(imagePath: '/path/to/stamp.png');
  /// await controller.prepareNextStamp(standardStamp: CPDFStandardStamp.approved);
  /// await controller.prepareNextStamp(
  ///   textStamp: CPDFTextStamp(text: 'CONFIDENTIAL', textColor: Colors.red),
  /// );
  /// ```
  Future<void> prepareNextStamp({
    String? imagePath,
    CPDFStandardStamp? standardStamp,
    CPDFTextStamp? textStamp,
  }) async {
    final count =
        [imagePath, standardStamp, textStamp].where((e) => e != null).length;
    if (count != 1) {
      throw ArgumentError(
          'Exactly one argument must be provided: imagePath, standardStamp, or textStamp');
    }
    final Map<String, dynamic> payload = {};
    if (imagePath != null) {
      payload
        ..['type'] = 'image'
        ..['imagePath'] = imagePath;
    } else if (standardStamp != null) {
      payload
        ..['type'] = 'standard'
        ..['standardStamp'] = standardStamp.name;
    } else {
      payload['type'] = 'text';
      payload.addAll(textStamp!.toJson());
    }
    await _channel.invokeMethod('prepare_next_stamp', payload);
  }

  /// Pre-configure the next image annotation to be inserted when the user taps the page.
  /// Example:
  /// ```dart
  /// // first enter image creation mode
  /// await controller.setAnnotationMode(CPDFAnnotationType.pictures);
  ///
  /// // then prepare the image path
  /// await controller.prepareNextImage('/path/to/image.png');
  ///
  /// // now, when the user taps the page, the image will be inserted using the specified image
  /// ```
  Future<void> prepareNextImage(String imagePath) async {
    return await _channel.invokeMethod('prepare_next_image', imagePath);
  }

  /// Retrieves the default annotation style for the CPDFReaderWidget.
  /// This method returns a [CPDFAnnotAttribute] object that contains the default
  /// annotation attributes such as color, alpha, and border width.
  /// example:
  /// ```dart
  /// CPDFAnnotAttribute defaultStyle = await controller.fetchDefaultAnnotationStyle();
  /// ```
  Future<CPDFAnnotAttribute> fetchDefaultAnnotationStyle() async {
    final attrMap = await _channel.invokeMethod('get_default_annotation_attr');
    return CPDFAnnotAttribute.fromJson(Map<String, dynamic>.from(attrMap));
  }

  /// Sets the default annotation style for the CPDFReaderWidget.
  /// This method allows you to customize the default attributes for annotations
  /// such as color, alpha, and border width.
  /// example:
  /// ```dart
  /// CPDFAnnotAttribute defaultStyle = await controller.fetchDefaultAnnotationStyle();
  ///
  /// // For example, to set the default style for a note annotation:
  /// CPDFNoteAttr noteAttr = defaultStyle.noteAttr.copyWith(
  ///   color: Colors.red,
  ///   alpha: 128,
  ///   );
  /// await controller.updateDefaultAnnotationStyle(noteAttr);
  ///
  /// // To set the default style for an ink annotation:
  /// CPDFInkAttr inkAttr = defaultStyle.inkAttr.copyWith(
  ///    color: Colors.blue,
  ///    alpha: 200,
  ///    borderWidth: 5);
  /// await controller.updateDefaultAnnotationStyle(inkAttr);
  /// ```
  Future<void> updateDefaultAnnotationStyle(
      CPDFAnnotAttrBase annotationStyle) async {
    return await _channel.invokeMethod('set_default_annotation_attr',
        {'type': annotationStyle.type, 'attr': annotationStyle.toJson()});
  }

  /// Retrieves the default widget (form field) style applied inside the reader widget.
  /// Returns the current [CPDFFormAttribute] describing properties such as color
  /// and text appearance for interactive form fields.
  ///
  /// example:
  /// ```dart
  /// CPDFFormAttribute defaultWidgetStyle = await controller.fetchDefaultWidgetStyle();
  /// ```
  Future<CPDFFormAttribute> fetchDefaultWidgetStyle() async {
    final attrMap = await _channel.invokeMethod('get_default_widget_attr');
    return CPDFFormAttribute.fromJson(Map<String, dynamic>.from(attrMap));
  }

  /// Persists a new default widget style so subsequent form field creations share
  /// consistent appearance characteristics.
  ///
  /// example:
  /// ```dart
  /// CPDFFormAttribute defaultWidgetStyle = await controller.fetchDefaultWidgetStyle();
  ///
  /// // get all fonts
  /// final fonts  = await ComPDFKit.getFonts();
  /// final familyName = fonts[0].familyName;
  /// final styleName = fonts[0].styleNames[0];
  ///
  /// // Modify the text field attribute
  /// final textFieldAttr = defaultWidgetStyle.textFieldAttr.copyWith(
  ///    fillColor: Colors.lightGreen,
  ///    borderColor: Colors.deepOrange,
  ///    borderWidth: 5,
  ///    fontColor: Colors.black,
  ///    fontSize: 20,
  ///    alignment: CPDFAlignment.left,
  ///    multiline: false,
  ///    familyName: familyName,
  ///    styleName: styleName,
  /// );
  ///
  /// await controller.updateDefaultWidgetStyle(textFieldAttr);
  /// ```
  Future<void> updateDefaultWidgetStyle(CPDFAnnotAttrBase widgetStyle) async {
    return await _channel.invokeMethod('set_default_widget_attr',
        {'type': widgetStyle.type, 'attr': widgetStyle.toJson()});
  }

  void dispose() {
    debugPrint('ComPDFKit-Flutter: dispose CPDFReaderWidgetController');
    _eventListeners.clear();
    _channel.setMethodCallHandler(null);
  }
}
