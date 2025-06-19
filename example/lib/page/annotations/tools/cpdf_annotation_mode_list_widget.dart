/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

var annotationModeList = [
  {'type': CPDFAnnotationType.note, 'icon': 'images/ic_note.svg'},
  {'type': CPDFAnnotationType.highlight, 'icon': 'images/ic_highlight.svg'},
  {'type': CPDFAnnotationType.underline, 'icon': 'images/ic_underline.svg'},
  {'type': CPDFAnnotationType.strikeout, 'icon': 'images/ic_strikeout.svg'},
  {'type': CPDFAnnotationType.squiggly, 'icon': 'images/ic_wavyline.svg'},
  {'type': CPDFAnnotationType.ink, 'icon': 'images/ic_ink.svg'},
  {'type': CPDFAnnotationType.ink_eraser, 'icon': 'images/ic_eraser.svg'},
  if (defaultTargetPlatform == TargetPlatform.iOS)
    {'type': CPDFAnnotationType.pencil, 'icon': 'images/ic_pencil.svg'},
  {'type': CPDFAnnotationType.circle, 'icon': 'images/ic_oval.svg'},
  {'type': CPDFAnnotationType.square, 'icon': 'images/ic_rec.svg'},
  {'type': CPDFAnnotationType.arrow, 'icon': 'images/ic_arrow.svg'},
  {'type': CPDFAnnotationType.line, 'icon': 'images/ic_line.svg'},
  {'type': CPDFAnnotationType.freetext, 'icon': 'images/ic_text.svg'},
  {'type': CPDFAnnotationType.signature, 'icon': 'images/ic_sign.svg'},
  {'type': CPDFAnnotationType.stamp, 'icon': 'images/ic_stamp.svg'},
  {'type': CPDFAnnotationType.pictures, 'icon': 'images/ic_image.svg'},
  {'type': CPDFAnnotationType.link, 'icon': 'images/ic_link.svg'},
  {'type': CPDFAnnotationType.sound, 'icon': 'images/ic_sound.svg'},
];

class CpdfAnnotationModeListWidget extends StatefulWidget {
  final CPDFReaderWidgetController controller;

  const CpdfAnnotationModeListWidget({super.key, required this.controller});

  @override
  State<CpdfAnnotationModeListWidget> createState() =>
      _CpdfAnnotationModeListWidgetState();
}

class _CpdfAnnotationModeListWidgetState extends State<CpdfAnnotationModeListWidget> {
  late CPDFAnnotationType currentAnnotationType = CPDFAnnotationType.unknown;

  @override
  void initState() {
    super.initState();
    _initializeCurrentAnnotationType();
  }

  void _initializeCurrentAnnotationType() async {
    CPDFAnnotationType type = await widget.controller.getAnnotationMode();
    setState(() {
      currentAnnotationType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(left: 8, right: 8),
        itemCount: annotationModeList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var item = annotationModeList[index];
          var type = item['type'] as CPDFAnnotationType;
          var iconPath = item['icon'] as String;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: currentAnnotationType == type
                  ? Colors.blue.withAlpha(128)
                  : null,
            ),
            child: IconButton(
                onPressed: () async {
                  if(currentAnnotationType == type){
                    await widget.controller.setAnnotationMode(CPDFAnnotationType.unknown);
                  }else{
                    await widget.controller.setAnnotationMode(type);
                  }
                  var annotType =
                  await widget.controller.getAnnotationMode();
                  debugPrint('ComPDFKit-Flutter: mode:$annotType');
                  setState(() {
                    currentAnnotationType = annotType;
                  });
                },
                icon:
                SvgPicture.asset(iconPath, width: 24, height: 24)),
          );
        });
  }
}
