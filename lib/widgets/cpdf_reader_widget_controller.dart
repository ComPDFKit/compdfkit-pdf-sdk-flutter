// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:async';
import 'dart:io';
import 'package:compdfkit_flutter/history/cpdf_annotation_history_manager.dart';
import 'package:flutter/services.dart';

import '../configuration/cpdf_options.dart';
import '../document/cpdf_document.dart';
import '../util/extension/cpdf_color_extension.dart';
import 'cpdf_reader_widget.dart';

/// PDF Reader Widget Controller
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

  late CPDFAnnotationHistoryManager _annotationHistoryManager;

  final Completer<void> _readyCompleter = Completer<void>();

  Future<void> get ready => _readyCompleter.future;

  CPDFReaderWidgetController(int id,
      {CPDFPageChangedCallback? onPageChanged,
      CPDFDocumentSaveCallback? saveCallback,
      CPDFPageEditDialogBackPressCallback? onPageEditBackPress,
      CPDFFillScreenChangedCallback? onFillScreenChanged,
      CPDFIOSClickBackPressedCallback? onIOSClickBackPressed,
      CPDFOnTapMainDocAreaCallback? onTapMainDocArea}) {
    _channel = MethodChannel('com.compdfkit.flutter.ui.pdfviewer.$id');
    _annotationHistoryManager = CPDFAnnotationHistoryManager(_channel);
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
  CPDFAnnotationHistoryManager get annotationHistoryManager => _annotationHistoryManager;

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
    return await _channel.invokeMethod('set_widget_background_color', color.toHex());
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

  /// Sets the spacing between pages. This method is supported only on the [Android] platform.
  ///
  /// - For the [iOS] platform, use the [setMargins] method instead.
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
  /// [cropMode] Whether it is crop mode.
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
  ///
  /// example:
  /// ```dart
  /// _controller.setDisplayPageIndex(1, animated: true);
  /// ```
  Future<void> setDisplayPageIndex(int pageIndex,
      {bool animated = true}) async {
    await _channel.invokeMethod('set_display_page_index',
        {'pageIndex': pageIndex, 'animated': animated});
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

  /// Displays the "Add Watermark" view, where users can add watermarks to the document.
  ///
  /// Example:
  /// ```dart
  /// await controller.showAddWatermarkView();
  /// ```
  Future<void> showAddWatermarkView({bool saveAsNewFile = true}) async {
    await _channel.invokeMethod('show_add_watermark_view', saveAsNewFile);
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

  /// Used to add a specified annotation type when touching the page in annotation mode
  /// This method is only available in [CPDFViewMode.annotations] mode.
  /// Example:
  /// ```dart
  /// await controller.setAnnotationMode(CPDFAnnotationType.note);
  /// ```
  /// Throws an exception if called in a mode other than [CPDFViewMode.annotations].
  Future<void> setAnnotationMode(CPDFAnnotationType type) async {
    var viewMode = await getPreviewMode();
    if(viewMode != CPDFViewMode.annotations) {
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

}
