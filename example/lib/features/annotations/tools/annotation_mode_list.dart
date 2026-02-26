/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/constants/asset_paths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final List<Map<String, Object>> annotationModeList = [
  {'type': CPDFAnnotationType.note, 'icon': AppAssets.icNote},
  {'type': CPDFAnnotationType.highlight, 'icon': AppAssets.icHighlight},
  {'type': CPDFAnnotationType.underline, 'icon': AppAssets.icUnderline},
  {'type': CPDFAnnotationType.strikeout, 'icon': AppAssets.icStrikeout},
  {'type': CPDFAnnotationType.squiggly, 'icon': AppAssets.icWavyline},
  {'type': CPDFAnnotationType.ink, 'icon': AppAssets.icInk},
  {'type': CPDFAnnotationType.ink_eraser, 'icon': AppAssets.icEraser},
  if (defaultTargetPlatform == TargetPlatform.iOS)
    {'type': CPDFAnnotationType.pencil, 'icon': AppAssets.icPencil},
  {'type': CPDFAnnotationType.circle, 'icon': AppAssets.icOval},
  {'type': CPDFAnnotationType.square, 'icon': AppAssets.icRec},
  {'type': CPDFAnnotationType.arrow, 'icon': AppAssets.icArrow},
  {'type': CPDFAnnotationType.line, 'icon': AppAssets.icLine},
  {'type': CPDFAnnotationType.freetext, 'icon': AppAssets.icText},
  {'type': CPDFAnnotationType.signature, 'icon': AppAssets.icSign},
  {'type': CPDFAnnotationType.stamp, 'icon': AppAssets.icStamp},
  {'type': CPDFAnnotationType.pictures, 'icon': AppAssets.icImage},
  {'type': CPDFAnnotationType.link, 'icon': AppAssets.icLink},
  {'type': CPDFAnnotationType.sound, 'icon': AppAssets.icSound},
];

class AnnotationModeList extends StatefulWidget {
  final List<CPDFAnnotationType> availableAnnotationTypes;

  final CPDFReaderWidgetController controller;

  const AnnotationModeList(
      {super.key,
      required this.controller,
      this.availableAnnotationTypes = CPDFAnnotationType.values});

  @override
  State<AnnotationModeList> createState() => _AnnotationModeListState();
}

class _AnnotationModeListState extends State<AnnotationModeList> {
  late CPDFAnnotationType currentAnnotationType = CPDFAnnotationType.unknown;

  @override
  void initState() {
    super.initState();
    _initializeCurrentAnnotationType();
  }

  void _initializeCurrentAnnotationType() async {
    final type = await widget.controller.getAnnotationMode();
    if (!mounted) return;
    setState(() {
      currentAnnotationType = type;
    });
  }

  List<Map<String, Object>> get filteredAnnotationModeList {
    return annotationModeList
        .where((item) => widget.availableAnnotationTypes
            .contains(item['type'] as CPDFAnnotationType))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: filteredAnnotationModeList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final item = filteredAnnotationModeList[index];
        final type = item['type'] as CPDFAnnotationType;
        final iconPath = item['icon'] as String;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: currentAnnotationType == type
                ? colorScheme.primaryContainer
                : null,
          ),
          child: IconButton(
            onPressed: () async {
              if (currentAnnotationType == type) {
                await widget.controller
                    .setAnnotationMode(CPDFAnnotationType.unknown);
              } else {
                await widget.controller.setAnnotationMode(type);
              }
              final annotType = await widget.controller.getAnnotationMode();
              debugPrint('ComPDFKit-Flutter: mode:$annotType');
              if (!mounted) return;
              setState(() {
                currentAnnotationType = annotType;
              });
            },
            icon: SvgPicture.asset(iconPath, width: 24, height: 24),
          ),
        );
      },
    );
  }
}
