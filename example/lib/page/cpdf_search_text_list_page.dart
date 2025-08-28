/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter_example/model/cpdf_search_item.dart';
import 'package:flutter/material.dart';
/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

class CpdfSearchTextListPage extends StatelessWidget {
  final List<CPDFSearchItem> results;

  const CpdfSearchTextListPage({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(color: Colors.black12),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];
          return ListTile(
            onTap: (){
              Navigator.pop(context, item);
            },
            title: Text(
              "Page: ${item.keywordsTextRange.pageIndex}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            subtitle: _highlightKeyword(item),
          );
        },
      ),
    );
  }

  Widget _highlightKeyword(CPDFSearchItem item) {
    final content = item.content;
    final keyword = item.keywords;
    final keywordStartInPage = item.keywordsTextRange.location;
    final contentStartInPage = item.contentTextRange.location;

    final relativeKeywordStart = keywordStartInPage - contentStartInPage;

    if (relativeKeywordStart < 0 ||
        relativeKeywordStart + keyword.length > content.length) {
      return RichText(
        text: TextSpan(text: content, style: const TextStyle(color: Colors.black)),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(text: content.substring(0, relativeKeywordStart)),
          TextSpan(
            text: content.substring(
                relativeKeywordStart, relativeKeywordStart + keyword.length),
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: content.substring(relativeKeywordStart + keyword.length)),
        ],
      ),
    );
  }
}
