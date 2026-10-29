// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// A single optimization step that can be enabled while optimizing a document.
///
/// Each entry carries the bit used by the native `optimizeFlags` bit mask. A
/// set of flags is sent to the native side as the combined mask produced by
/// [CPDFOptimizeFlagSet.toMask]. The bits are identical on Android and iOS.
enum CPDFOptimizeFlag {
  // Object and structure cleanup.

  /// Removes objects that nothing else references.
  removeUnusedObjects(1 << 0),

  /// Removes empty objects.
  removeEmptyObjects(1 << 1),

  /// Removes special object attributes.
  removeSpecialAttributes(1 << 2),

  /// Removes embedded fonts. Text may render with substituted fonts
  /// afterwards, so this is disabled by default.
  removeEmbeddedFonts(1 << 3),

  // Navigation and annotations.

  /// Removes links whose destination cannot be resolved.
  removeInvalidLinks(1 << 4),

  /// Removes bookmarks whose destination cannot be resolved.
  removeInvalidBookmarks(1 << 5),

  /// Recompresses images using the color, grayscale and monochrome image
  /// options of `CPDFOptimizeOptions`.
  compressImages(1 << 6),

  /// Removes every bookmark, valid ones included.
  removeBookmarks(1 << 7),

  // Content removal.

  /// Removes every annotation.
  removeAnnotations(1 << 8),

  /// Removes every form.
  removeForms(1 << 9),

  /// Removes every multimedia object.
  removeMultimedia(1 << 10),

  /// Removes the document information dictionary.
  removeDocumentInfo(1 << 11),

  /// Removes the XMP metadata.
  removeMetadata(1 << 12),

  /// Removes object level data.
  removeObjectData(1 << 13),

  /// Removes embedded file attachments.
  removeFileAttachments(1 << 14),

  /// Removes external cross references.
  removeExternalCrossRefs(1 << 15),

  /// Removes data written by other applications.
  removeOtherAppData(1 << 16),

  // Optional content groups, i.e. layers.

  /// Removes hidden layers.
  removeHiddenLayers(1 << 17),

  /// Merges the remaining visible layers into the page content.
  mergeVisibleLayers(1 << 18),

  // Stream transforms.

  /// Applies Flate encoding to streams that are stored uncompressed.
  useFlateForUncompressedStreams(1 << 19),

  /// Re-encodes LZW compressed streams with Flate.
  replaceLzwWithFlate(1 << 20),

  // Miscellaneous.

  /// Removes named targets that nothing refers to.
  removeUnusedNamedTargets(1 << 21),

  /// Rewrites page content streams in a more compact form.
  optimizePageContent(1 << 22),

  /// Linearizes the document for fast web view.
  fastWebView(1 << 23),

  /// Removes form submit, import and reset actions.
  removeFormSubmitImportResetActions(1 << 24),

  /// Removes every JavaScript action.
  removeJavaScriptActions(1 << 25),

  /// Removes embedded page thumbnails.
  removePageThumbnails(1 << 26),

  /// Removes the alternate text of replaced images.
  removeReplacedImagesAltText(1 << 27),

  /// Removes page labels.
  removePageLabels(1 << 28),

  /// Removes print settings.
  removePrintSettings(1 << 29),

  /// Removes the embedded search index.
  removeSearchIndex(1 << 30);

  const CPDFOptimizeFlag(this.bit);

  /// The bit this flag occupies in the native `optimizeFlags` mask.
  final int bit;

  /// The default set used by `CPDFOptimizeOptions`.
  ///
  /// It mirrors the native `CPDFOptimizeOptions.DEFAULT_OPTIMIZE_FLAGS`
  /// expression bit for bit, which combines `0xFF` without
  /// [removeEmbeddedFonts] with [removeHiddenLayers],
  /// [removeUnusedNamedTargets], [useFlateForUncompressedStreams],
  /// [replaceLzwWithFlate], [removeJavaScriptActions],
  /// [removeReplacedImagesAltText] and [optimizePageContent].
  ///
  /// Note that the default set is lossy: [removeBookmarks] drops every
  /// bookmark and [removeJavaScriptActions] drops every script. Build a custom
  /// set when the document must keep them.
  static const Set<CPDFOptimizeFlag> defaults = {
    removeUnusedObjects,
    removeEmptyObjects,
    removeSpecialAttributes,
    removeInvalidLinks,
    removeInvalidBookmarks,
    compressImages,
    removeBookmarks,
    removeHiddenLayers,
    useFlateForUncompressedStreams,
    replaceLzwWithFlate,
    removeUnusedNamedTargets,
    optimizePageContent,
    removeJavaScriptActions,
    removeReplacedImagesAltText,
  };

  /// Expands a native bit mask into the matching set of flags.
  ///
  /// Bits that no known flag claims are ignored, so a newer native SDK cannot
  /// crash an older Dart layer.
  static Set<CPDFOptimizeFlag> fromMask(int mask) {
    return CPDFOptimizeFlag.values
        .where((flag) => mask & flag.bit != 0)
        .toSet();
  }
}

/// Combines a set of [CPDFOptimizeFlag] into the native bit mask.
extension CPDFOptimizeFlagSet on Set<CPDFOptimizeFlag> {
  /// The combined `optimizeFlags` value understood by the native SDK.
  int toMask() => fold(0, (mask, flag) => mask | flag.bit);
}
