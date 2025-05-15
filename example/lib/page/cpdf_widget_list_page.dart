/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/annotation/form/cpdf_text_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

class CpdfWidgetListPage extends StatelessWidget {
  final List<CPDFWidget> widgets;

  const CpdfWidgetListPage(
      {super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    Map<int, List<CPDFWidget>> groupedWidgets = {};
    for (var widget in widgets) {
      if (groupedWidgets.containsKey(widget.page)) {
        groupedWidgets[widget.page]?.add(widget);
      } else {
        groupedWidgets[widget.page] = [widget];
      }
    }

    // 生成分页标题列表
    List<int> pageNumbers = groupedWidgets.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text('Widgets',
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
                    final widgetsForPage = groupedWidgets[pageNumber]!;
                    return _buildWidgetList(widgetsForPage);
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
  Widget _buildWidgetList(List<CPDFWidget> widgetsForPage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgetsForPage
          .map((widget) => _buildWidgetItem(widget))
          .toList(),
    );
  }

  // 构建单个注释项
  Widget _buildWidgetItem(CPDFWidget widget) {
    return Builder(builder: (context) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
            onTap: () {
              printJsonString(widget.toString());
              Navigator.pop(context, {
                'type': 'jump',
                'widget': widget,
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
                        TextSpan(text: widget.title)
                      ])),
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                            text: 'Type:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: widget.type.name)
                      ])),
                      if (widget is CPDFTextWidget) ...[
                        Text(widget.text)
                      ]
                    ],
                  )),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'type': 'remove',
                          'widget': widget,
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
