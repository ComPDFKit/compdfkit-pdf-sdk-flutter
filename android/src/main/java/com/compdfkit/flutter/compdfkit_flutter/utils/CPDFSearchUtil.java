/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.utils;

import android.content.Context;
import androidx.annotation.Nullable;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.page.CPDFTextPage;
import com.compdfkit.core.page.CPDFTextRange;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.textsearch.CPDFTextSearcher;
import com.compdfkit.ui.textsearch.ITextSearcher;
import io.flutter.plugin.common.MethodCall;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class CPDFSearchUtil {


  /**
   * Searches for keywords in the given PDF document using the specified text searcher.
   *
   * @param document       The PDF document to search within.
   * @param iTextSearcher  The text searcher to use for searching.
   * @param keywords       The keywords to search for.
   * @param searchOptions  Options for the search, such as case sensitivity and whole word matching.
   * @see com.compdfkit.core.page.CPDFTextSearcher.PDFSearchOptions#PDFSearchCaseInsensitive
   * @see com.compdfkit.core.page.CPDFTextSearcher.PDFSearchOptions#PDFSearchCaseSensitive
   * @see com.compdfkit.core.page.CPDFTextSearcher.PDFSearchOptions#PDFSearchMatchWholeWord
   * @see com.compdfkit.core.page.CPDFTextSearcher.PDFSearchOptions#PDFSearchConsecutive
   */
  public static List<Map<String, Object>> search(CPDFDocument document, ITextSearcher iTextSearcher, String keywords, int searchOptions) {
    List<Map<String, Object>> searchResults = new ArrayList<>();
    iTextSearcher.setSearchConfig(keywords, searchOptions);
    for (int pageIndex = 0; pageIndex < document.getPageCount(); pageIndex++) {
      CPDFPage page = document.pageAtIndex(pageIndex);
      List<CPDFTextRange> textRanges = iTextSearcher.searchKeyword(pageIndex);
      for (int i = 0; i < textRanges.size(); i++) {
        CPDFTextRange textRange = textRanges.get(i);
        Map<String, Object> result = new HashMap<>();
        result.put("page_index", page.getPageNum());
        result.put("location", textRange.location);
        result.put("length", textRange.length);
        result.put("text_range_index", i);
        searchResults.add(result);
      }
    }
    return searchResults;
  }

  public static void selection(Context context,  @Nullable CPDFViewCtrl pdfView, CPDFDocument document, MethodCall call){
    ITextSearcher iTextSearcher = getTextSearcher(context, pdfView, document);
    int pageIndex = call.argument("page_index");
    int textRangeIndex = call.argument("text_range_index");
    iTextSearcher.searchBegin(pageIndex, textRangeIndex);
    if (pdfView != null) {
      pdfView.getCPdfReaderView().invalidateAllChildren();
    }
  }

  public static void clearSearch(Context context, @Nullable CPDFViewCtrl pdfView,  CPDFDocument document){
    ITextSearcher iTextSearcher = getTextSearcher(context, pdfView, document);
    iTextSearcher.cancelSearch();
    if (pdfView != null) {
      pdfView.getCPdfReaderView().invalidateAllChildren();
    }
  }

  public static String getText(CPDFDocument document, MethodCall call){
    int pageIndex = call.argument("page_index");
    int location = call.argument("location");
    int length = call.argument("length");
    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFTextPage textPage = page.getTextPage();
    CPDFTextRange range = new CPDFTextRange(location, length);
    return textPage.getText(range);
  }

  private static ITextSearcher getTextSearcher(Context context, @Nullable CPDFViewCtrl pdfView, CPDFDocument document) {
    if (pdfView != null) {
      return pdfView.getCPdfReaderView().getTextSearcher();
    } else {
      return new CPDFTextSearcher(context, document);
    }
  }

}
