// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';
import 'package:flutter/services.dart';

import '../configuration/cpdf_options.dart';

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

  // late CPDFDocument _document;

  CPDFReaderWidgetController(int id) {
    _channel = MethodChannel('com.compdfkit.flutter.ui.pdfviewer.$id');
    _channel.setMethodCallHandler((call) async {});
    // _document = CPDFDocument.withController(id);
  }

  // CPDFDocument get document => _document;

  /// Save document
  /// Return value: **true** if the save is successful,
  /// **false** if the save fails.
  Future<bool> save() async {
    return await _channel.invokeMethod('save');
  }

  /// Set the page scale
  /// Value Range: 1.0~5.0
  ///
  /// example:
  /// ```dart
  /// _controller.setScale(1.5);
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
  /// _controller.setCanScale(canScale);
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
  /// await _controller.setReadBackgroundColor(Colors.white);
  /// ```
  // Future<void> setReadBackgroundColor(Color color) async {
  //   await _channel.invokeMethod('set_read_background_color', color.toHex());
  // }

  /// Get background color of reader.
  ///
  /// example:
  /// ```dart
  /// Color color = await _controller.getReadBackgroundColor();
  /// ```
  // Future<Color> getReadBackgroundColor() async {
  //   String hexColor = await _channel.invokeMethod('get_read_background_color');
  //   return HexColor.fromHex(hexColor);
  // }

  /// Sets whether to display highlight Form Field.
  /// [isFormFieldHighlight] : true to display highlight Form Field.
  ///
  /// example:
  /// ```dart
  /// _controller.setFormFieldHighlight(true);
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
  /// _controller.setLinkHighlight(true);
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
  /// _controller.setVerticalMode(true);
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
  /// _controller.setMargins(const CPDFEdgeInsets.symmetric(horizontal: 10, vertical: 10));
  /// ```
  Future<void> setMargins(CPDFEdgeInsets edgeInsets) async {
    await _channel.invokeMethod('set_margin' , edgeInsets.toJson());
  }

  /// Sets whether it is continuous scroll mode.
  ///
  /// [isContinueMode] Whether it is continuous scroll mode.
  ///
  /// example:
  /// ```dart
  /// _controller.setContinueMode(true);
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
  /// _controller.setDoublePageMode(true);
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
  /// _controller.setCoverPageMode(true);
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
  Future<bool> hasChange() async {
    return await _channel.invokeMethod('has_change');
  }
}
