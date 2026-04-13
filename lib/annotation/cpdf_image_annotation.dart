/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_image_data.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';

/// Image annotation model.
///
/// An image-based stamp/annotation that extends [CPDFAnnotation].
///
/// Key properties:
/// - [image]: Deprecated legacy Base64-encoded image string.
/// - [imageData]: Preferred image source descriptor.
///
/// Serialization:
/// - Use [CPDFImageAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFImageAnnotation extends CPDFAnnotation {
  /// Legacy Base64 encoded image string representing the image annotation.
  ///
  /// Deprecated: Use [imageData] instead.
  ///
  /// for example:iVBORw0KGgoAAAANSUhEUgAAAgIAAABzCAY...
  @Deprecated(
      'Use imageData instead. This legacy Base64 field will be removed in a future release.')
  final String? image;

  /// Preferred image source for this annotation.
  final CPDFImageData? imageData;

  CPDFImageAnnotation(
      {super.title,
      super.content,
      super.createDate,
      required super.page,
      super.uuid = '',
      required super.rect,
      @Deprecated(
        'Use imageData instead. This legacy Base64 field will be removed in a future release.')
      this.image,
      this.imageData})
      : super(type: CPDFAnnotationType.pictures);

  /// Creates an image annotation from a raw Base64 string.
  ///
  /// Use this factory when the image bytes are already encoded as Base64 and
  /// can be embedded directly into the annotation payload.
  ///
  /// Example:
  /// ```dart
  /// final annotation = CPDFImageAnnotation.fromBase64(
  ///   page: 0,
  ///   rect: const CPDFRectF(
  ///     left: 80,
  ///     top: 120,
  ///     right: 220,
  ///     bottom: 260,
  ///   ),
  ///   base64: 'iVBORw0KGgoAAAANSUhEUgAAAAUA...',
  /// );
  /// ```
  factory CPDFImageAnnotation.fromBase64({
    String? title,
    String? content,
    DateTime? createDate,
    required int page,
    String uuid = '',
    required CPDFRectF rect,
    required String base64,
  }) {
    return CPDFImageAnnotation(
      title: title ?? '',
      content: content ?? '',
      createDate: createDate,
      page: page,
      uuid: uuid,
      rect: rect,
      imageData: CPDFImageData.fromBase64(base64),
    );
  }

  /// Creates an image annotation from a data URI string.
  ///
  /// This is useful when the image source is already available in the browser
  /// or web-style `data:image/...;base64,...` format.
  ///
  /// Example:
  /// ```dart
  /// final annotation = CPDFImageAnnotation.fromDataUri(
  ///   page: 0,
  ///   rect: const CPDFRectF(
  ///     left: 80,
  ///     top: 120,
  ///     right: 220,
  ///     bottom: 260,
  ///   ),
  ///   dataUri: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA...',
  /// );
  /// ```
  factory CPDFImageAnnotation.fromDataUri({
    String? title,
    String? content,
    DateTime? createDate,
    required int page,
    String uuid = '',
    required CPDFRectF rect,
    required String dataUri,
  }) {
    return CPDFImageAnnotation(
      title: title ?? '',
      content: content ?? '',
      createDate: createDate,
      page: page,
      uuid: uuid,
      rect: rect,
      imageData: CPDFImageData.fromDataUri(dataUri),
    );
  }

  /// Creates an image annotation from a local file path.
  ///
  /// Use this when the image already exists on the device file system, such as
  /// a cached export or a user-selected file.
  ///
  /// Example:
  /// ```dart
  /// final annotation = CPDFImageAnnotation.fromPath(
  ///   page: 1,
  ///   rect: const CPDFRectF(
  ///     left: 60,
  ///     top: 100,
  ///     right: 240,
  ///     bottom: 280,
  ///   ),
  ///   filePath: '/data/user/0/com.example.app/cache/signature.png',
  /// );
  /// ```
  factory CPDFImageAnnotation.fromPath({
    String? title,
    String? content,
    DateTime? createDate,
    required int page,
    String uuid = '',
    required CPDFRectF rect,
    required String filePath,
  }) {
    return CPDFImageAnnotation(
      title: title ?? '',
      content: content ?? '',
      createDate: createDate,
      page: page,
      uuid: uuid,
      rect: rect,
      imageData: CPDFImageData.fromPath(filePath),
    );
  }

  /// Creates an image annotation from a Flutter asset path.
  ///
  /// Use this factory when the image is bundled with the application and
  /// declared in `pubspec.yaml`.
  ///
  /// Example:
  /// ```dart
  /// final annotation = CPDFImageAnnotation.fromAsset(
  ///   page: 0,
  ///   rect: const CPDFRectF(
  ///     left: 40,
  ///     top: 80,
  ///     right: 200,
  ///     bottom: 220,
  ///   ),
  ///   assetPath: 'assets/images/stamp.png',
  /// );
  /// ```
  factory CPDFImageAnnotation.fromAsset({
    String? title,
    String? content,
    DateTime? createDate,
    required int page,
    String uuid = '',
    required CPDFRectF rect,
    required String assetPath,
  }) {
    return CPDFImageAnnotation(
      title: title ?? '',
      content: content ?? '',
      createDate: createDate,
      page: page,
      uuid: uuid,
      rect: rect,
      imageData: CPDFImageData.fromAsset(assetPath),
    );
  }

  /// Creates an image annotation from a platform URI string.
  ///
  /// This is typically used with Android content URIs returned by the system
  /// picker or another app.
  ///
  /// Example:
  /// ```dart
  /// final annotation = CPDFImageAnnotation.fromUri(
  ///   page: 2,
  ///   rect: const CPDFRectF(
  ///     left: 32,
  ///     top: 96,
  ///     right: 196,
  ///     bottom: 260,
  ///   ),
  ///   uri: 'content://media/external/images/media/1000',
  /// );
  /// ```
  factory CPDFImageAnnotation.fromUri({
    String? title,
    String? content,
    DateTime? createDate,
    required int page,
    String uuid = '',
    required CPDFRectF rect,
    required String uri,
  }) {
    return CPDFImageAnnotation(
      title: title ?? '',
      content: content ?? '',
      createDate: createDate,
      page: page,
      uuid: uuid,
      rect: rect,
      imageData: CPDFImageData.fromUri(uri),
    );
  }

  /// Creates an image annotation from serialized JSON data.
  ///
  /// Use this to restore annotations returned by ComPDFKit APIs or loaded from
  /// a previously persisted payload.
  ///
  /// Example:
  /// ```dart
  /// final annotation = CPDFImageAnnotation.fromJson({
  ///   'type': 'pictures',
  ///   'page': 0,
  ///   'uuid': 'annotation-id',
  ///   'rect': {
  ///     'left': 80.0,
  ///     'top': 120.0,
  ///     'right': 220.0,
  ///     'bottom': 260.0,
  ///   },
  ///   'imageData': {
  ///     'type': 'asset',
  ///     'data': 'assets/images/stamp.png',
  ///   },
  /// });
  /// ```
  factory CPDFImageAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    final imageDataJson = json['imageData'];
    return CPDFImageAnnotation(
      title: common.title,
      content: common.content,
      createDate: common.createDate,
      page: common.page,
      uuid: common.uuid,
      rect: common.rect,
      image: json['image'],
      imageData: imageDataJson is Map<String, dynamic>
          ? CPDFImageData.fromJson(imageDataJson)
          : imageDataJson is Map
              ? CPDFImageData.fromJson(Map<String, dynamic>.from(imageDataJson))
              : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'image': image,
      'imageData': imageData?.toJson(),
      'stampType': 'image',
    };
  }
}
