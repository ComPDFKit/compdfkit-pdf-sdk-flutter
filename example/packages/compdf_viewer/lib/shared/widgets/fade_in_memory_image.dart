// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:typed_data';
import 'package:flutter/material.dart';

/// A widget that displays a memory image with a fade-in animation.
///
/// This widget provides a smooth transition when displaying images loaded
/// from memory (Uint8List), useful for thumbnail previews and dynamically
/// loaded images.
///
/// **Animation:**
/// - 50ms delay before showing image
/// - 150ms fade-in duration
/// - EaseIn curve for smooth transition
/// - Gapless playback to prevent flickering
///
/// **Parameters:**
/// - [imageBytes] - Image data as Uint8List
/// - [fit] - How the image should fit within its container (default: cover)
///
/// **Usage:**
/// ```dart
/// FadeInMemoryImage(
///   imageBytes: thumbnailBytes,
///   fit: BoxFit.cover,
/// )
/// ```
class FadeInMemoryImage extends StatefulWidget {
  final Uint8List imageBytes;
  final BoxFit fit;

  const FadeInMemoryImage({
    super.key,
    required this.imageBytes,
    this.fit = BoxFit.cover,
  });

  @override
  State<FadeInMemoryImage> createState() => _FadeInMemoryImageState();
}

class _FadeInMemoryImageState extends State<FadeInMemoryImage> {
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _showImage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 150),
      switchInCurve: Curves.easeIn,
      child: _showImage
          ? Image.memory(
              widget.imageBytes,
              fit: widget.fit,
              key: ValueKey('image'),
              gaplessPlayback: true,
            )
          : Container(
              key: ValueKey('placeholder'),
              color: Colors.transparent,
            ),
    );
  }
}
