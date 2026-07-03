// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_options.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_provider.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_service.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_source.dart';
import 'package:flutter/material.dart';

/// Builds the image layer for [CPDFPageThumbnail].
@visibleForTesting
typedef CPDFPageThumbnailImageBuilder = Widget Function(
  CPDFPageThumbnailProvider provider,
  ImageErrorWidgetBuilder? errorBuilder,
);

/// Builds a PDF page thumbnail image with placeholder and error handling.
class CPDFPageThumbnail extends StatelessWidget {
  /// Thumbnail source.
  final CPDFPageThumbnailSource source;

  /// Page index to render.
  final int pageIndex;

  /// Render options.
  final CPDFPageThumbnailOptions options;

  /// Service used to load thumbnails.
  final CPDFPageThumbnailService? service;

  /// Whether Flutter's decoded image cache is used before SDK caches.
  final bool useFlutterImageCache;

  /// Placeholder shown before the first image frame.
  final WidgetBuilder? placeholderBuilder;

  /// Error widget builder.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Image fit.
  final BoxFit? fit;

  /// Image alignment.
  final AlignmentGeometry alignment;

  /// Image filter quality.
  final FilterQuality filterQuality;

  /// Semantic label.
  final String? semanticLabel;

  /// Excludes semantics when true.
  final bool excludeFromSemantics;

  final CPDFPageThumbnailImageBuilder? _imageBuilder;

  /// Creates a thumbnail widget.
  const CPDFPageThumbnail({
    super.key,
    required this.source,
    required this.pageIndex,
    this.options = const CPDFPageThumbnailOptions(),
    this.service,
    this.useFlutterImageCache = true,
    this.placeholderBuilder,
    this.errorBuilder,
    this.fit,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    CPDFPageThumbnailImageBuilder? imageBuilder,
  }) : _imageBuilder = imageBuilder;

  /// Creates a thumbnail widget for tests without starting image decoding.
  @visibleForTesting
  const CPDFPageThumbnail.test({
    super.key,
    required this.source,
    required this.pageIndex,
    this.options = const CPDFPageThumbnailOptions(),
    this.service,
    this.useFlutterImageCache = true,
    this.placeholderBuilder,
    this.errorBuilder,
    this.fit,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    required CPDFPageThumbnailImageBuilder imageBuilder,
  }) : _imageBuilder = imageBuilder;

  /// Creates a thumbnail widget from an existing document.
  CPDFPageThumbnail.document({
    Key? key,
    required CPDFDocument document,
    required int pageIndex,
    CPDFPageThumbnailOptions options = const CPDFPageThumbnailOptions(),
    Object? cacheVersion,
    CPDFPageThumbnailService? service,
    bool useFlutterImageCache = true,
    WidgetBuilder? placeholderBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    FilterQuality filterQuality = FilterQuality.low,
    String? semanticLabel,
    bool excludeFromSemantics = false,
  }) : this(
          key: key,
          source: CPDFPageThumbnailSource.document(
            document,
            cacheVersion: cacheVersion,
          ),
          pageIndex: pageIndex,
          options: options,
          service: service,
          useFlutterImageCache: useFlutterImageCache,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          fit: fit,
          alignment: alignment,
          filterQuality: filterQuality,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          imageBuilder: null,
        );

  /// Creates a thumbnail widget from a file path.
  CPDFPageThumbnail.file({
    Key? key,
    required String filePath,
    required int pageIndex,
    String password = '',
    CPDFPageThumbnailOptions options = const CPDFPageThumbnailOptions(),
    CPDFPageThumbnailService? service,
    bool useFlutterImageCache = true,
    WidgetBuilder? placeholderBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    FilterQuality filterQuality = FilterQuality.low,
    String? semanticLabel,
    bool excludeFromSemantics = false,
  }) : this(
          key: key,
          source: CPDFPageThumbnailSource.file(filePath, password: password),
          pageIndex: pageIndex,
          options: options,
          service: service,
          useFlutterImageCache: useFlutterImageCache,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          fit: fit,
          alignment: alignment,
          filterQuality: filterQuality,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          imageBuilder: null,
        );

  @override
  Widget build(BuildContext context) {
    final provider = CPDFPageThumbnailProvider(
      source: source,
      pageIndex: pageIndex,
      options: options,
      service: service,
      useFlutterImageCache: useFlutterImageCache,
    );
    final image = _imageBuilder?.call(provider, errorBuilder) ??
        Image(
          image: provider,
          fit: fit,
          alignment: alignment,
          filterQuality: filterQuality,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          errorBuilder: errorBuilder,
        );
    final placeholder = placeholderBuilder?.call(context);
    if (placeholder == null) {
      return image;
    }
    return Stack(
      fit: StackFit.passthrough,
      children: [
        placeholder,
        image,
      ],
    );
  }
}
