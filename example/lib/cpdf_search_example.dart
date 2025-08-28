/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:math' as math;

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/page/cpdf_text_range.dart';
import 'package:compdfkit_flutter/page/cpdf_text_searcher.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/model/cpdf_search_item.dart';
import 'package:compdfkit_flutter_example/page/cpdf_search_text_list_page.dart';
import 'package:flutter/material.dart';

// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

class CpdfSearchExample extends StatefulWidget {
  final String documentPath;

  const CpdfSearchExample({super.key, required this.documentPath});

  @override
  State<CpdfSearchExample> createState() => _CpdfSearchExampleState();
}

class _CpdfSearchExampleState extends State<CpdfSearchExample> {
  late CPDFReaderWidgetController? _controller;
  TextEditingController textEditingController = TextEditingController();
  List<CPDFTextRange> searchResults = List.empty(growable: true);
  int currentResultIndex = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: buildSearchWidget(),
          actions: buildActions(),
        ),
        body: CPDFReaderWidget(
            document: widget.documentPath,
            configuration: CPDFConfiguration(),
            onCreated: (controller) {
              setState(() {
                _controller = controller;
              });
            }));
  }

  Widget buildSearchWidget() {
    return TextField(
      controller: textEditingController,
      textInputAction: TextInputAction.search,
      onEditingComplete: () {
        startSearch();
      },
      maxLines: 1,
      focusNode: _focusNode,
      onChanged: (text){
        if(searchResults.isNotEmpty){
          setState(() {
            searchResults.clear();
          });
        }
      },
    );
  }

  List<Widget> buildActions() {
    if (searchResults.isEmpty) {
      return [
        IconButton(
            onPressed: () {
              startSearch();
            },
            icon: const Icon(Icons.search))
      ];
    } else {
      return [
        IconButton(
            onPressed: () {
              if (searchResults.isNotEmpty) {
                CPDFTextSearcher? textSearcher =
                    _controller?.document.getTextSearcher();
                if (currentResultIndex <= 0) {
                  currentResultIndex = searchResults.length - 1;
                } else {
                  currentResultIndex--;
                }
                textSearcher?.selection(searchResults[currentResultIndex]);
              }
            },
            icon: Transform.rotate(
              angle: math.pi,
              child: const Icon(Icons.navigate_next),
            )),
        IconButton(
            onPressed: () {
              if (searchResults.isNotEmpty) {
                CPDFTextSearcher? textSearcher =
                    _controller?.document.getTextSearcher();
                currentResultIndex++;
                if (currentResultIndex >= searchResults.length) {
                  currentResultIndex = 0;
                }
                textSearcher?.selection(searchResults[currentResultIndex]);
              }
            },
            icon: const Icon(Icons.navigate_next)),
        IconButton(
            onPressed: () {
              toSearchTextListPage();
            },
            icon: const Icon(Icons.list))
      ];
    }
  }

  void startSearch() async {
    FocusScope.of(context).unfocus();
    currentResultIndex = 0;
    String keywords = textEditingController.text.trim();
    debugPrint('Searching for: $keywords');
    CPDFTextSearcher? textSearcher = _controller?.document.getTextSearcher();

    if(keywords.isEmpty){
      await textSearcher?.clearSearch();
      return;
    }
    await textSearcher?.searchText(keywords).then((results) {
      setState(() {
        searchResults = results;
      });
      if (results.isNotEmpty) {
        textSearcher.selection(results[currentResultIndex]);
      }
    }).catchError((error) {
      debugPrint('Search error: $error');
    });
  }

  void toSearchTextListPage() async {
    if (searchResults.isNotEmpty) {
      final list = await Future.wait(searchResults.map((e) async {
        CPDFPage page = _controller!.document.pageAtIndex(e.pageIndex);
        CPDFTextRange newRange = e.expanded(before: 20, after: 20);
        String content = await page.getText(newRange);
        return CPDFSearchItem(
          keywordsTextRange: e,
          contentTextRange: newRange,
          keywords: textEditingController.text.trim(),
          content: content,
        );
      }));
      Future.delayed(Duration.zero, () {
        _focusNode.unfocus();
      });

      CPDFSearchItem? item = await Navigator.push<CPDFSearchItem?>(
        context,
        MaterialPageRoute(
          builder: (context) => CpdfSearchTextListPage(results: list),
        ),
      );
      if(item != null){
        CPDFTextSearcher? textSearcher = _controller?.document.getTextSearcher();
        textSearcher?.selection(item.keywordsTextRange);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No search results found')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }
}
