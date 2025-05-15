/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_markup_annotation.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

class CpdfAnnotationsListPage extends StatelessWidget {
  final List<CPDFAnnotation> annotations;

  const CpdfAnnotationsListPage(
      {super.key, required this.annotations});

  @override
  Widget build(BuildContext context) {
    Map<int, List<CPDFAnnotation>> groupedAnnotations = {};
    for (var annotation in annotations) {
      if (groupedAnnotations.containsKey(annotation.page)) {
        groupedAnnotations[annotation.page]?.add(annotation);
      } else {
        groupedAnnotations[annotation.page] = [annotation];
      }
    }

    // 生成分页标题列表
    List<int> pageNumbers = groupedAnnotations.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text('Annotations',
                style: Theme.of(context).textTheme.titleLarge)),
        Expanded(
            child: ListView.builder(
                itemCount: pageNumbers.length * 2,
                itemBuilder: (context, index) {
                  final pageNumber = pageNumbers[index ~/ 2]; // 页码
                  final isHeader = index.isEven; // 判断是否为分页头部
                  if (isHeader) {
                    return _buildPageHeader(pageNumber);
                  } else {
                    final annotationsForPage = groupedAnnotations[pageNumber]!;
                    return _buildAnnotationList(annotationsForPage);
                  }
                }))
      ],
    );
  }

  // 构建分页头部
  Widget _buildPageHeader(int pageNumber) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDDE9FF),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        'Page ${pageNumber + 1}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 构建单页注释列表
  Widget _buildAnnotationList(List<CPDFAnnotation> annotationsForPage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: annotationsForPage
          .map((annotation) => _buildAnnotationItem(annotation))
          .toList(),
    );
  }

  // 构建单个注释项
  Widget _buildAnnotationItem(CPDFAnnotation annotation) {
    return Builder(builder: (context) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
            onTap: () {
              printJsonString(annotation.toString());
              Navigator.pop(context, {
                'type': 'jump',
                'annotation': annotation,
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                            text: 'Title:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: annotation.title)
                      ])),
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                            text: 'Type:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: annotation.type.name)
                      ])),
                      if (annotation is CPDFMarkupAnnotation) ...[
                        Text(annotation.markedText)
                      ]
                    ],
                  )),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'type': 'remove',
                          'annotation': annotation,
                        });
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
            ),
          ));
    });
  }
}
