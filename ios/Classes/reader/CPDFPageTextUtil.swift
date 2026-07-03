//
//  CPDFPageTextUtil.swift
//  compdfkit_flutter
//
//  Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.

import Foundation
import ComPDFKit

class CPDFPageTextUtil {

    static func getPageText(from document: CPDFDocument?, pageIndex: Int) -> String {
        guard let page = page(from: document, pageIndex: pageIndex) else {
            return ""
        }
        return fullText(from: page)
    }

    static func getPageTextInRect(
        from document: CPDFDocument?,
        pageIndex: Int,
        rectInfo: [String: Any]?
    ) -> String {
        guard let page = page(from: document, pageIndex: pageIndex),
              let rect = rect(from: rectInfo) else {
            return ""
        }
        return page.string(for: rect) ?? ""
    }

    static func getPageTextLines(
        from document: CPDFDocument?,
        pageIndex: Int
    ) -> [[String: Any]] {
        guard let page = page(from: document, pageIndex: pageIndex) else {
            return []
        }
        let length = Int(page.numberOfCharacters)
        guard length > 0,
              let selection = page.selection(for: NSRange(location: 0, length: length)) else {
            return []
        }

        var lines: [[String: Any]] = []
        for lineSelection in selection.selectionsByLine {
            lines.append(lineMap(
                pageIndex: pageIndex,
                lineIndex: lines.count,
                selection: lineSelection
            ))
        }
        return lines
    }

    private static func page(from document: CPDFDocument?, pageIndex: Int) -> CPDFPage? {
        guard let document = document,
              pageIndex >= 0,
              pageIndex < document.pageCount else {
            return nil
        }
        return document.page(at: UInt(pageIndex))
    }

    private static func fullText(from page: CPDFPage) -> String {
        let length = Int(page.numberOfCharacters)
        if length == 0 {
            return ""
        }
        return page.string(for: NSRange(location: 0, length: length)) ?? ""
    }

    private static func rect(from info: [String: Any]?) -> CGRect? {
        guard let info = info else {
            return nil
        }
        let left = doubleValue(info["left"])
        let top = doubleValue(info["top"])
        let right = doubleValue(info["right"])
        let bottom = doubleValue(info["bottom"])
        let width = right - left
        let minY = min(top, bottom)
        let maxY = max(top, bottom)
        let height = maxY - minY
        guard abs(width) > 0.1, abs(height) > 0.1 else {
            return nil
        }
        return CGRect(x: left, y: minY, width: width, height: height)
    }

    private static func doubleValue(_ value: Any?) -> Double {
        if let value = value as? NSNumber {
            return value.doubleValue
        }
        if let value = value as? Double {
            return value
        }
        if let value = value as? CGFloat {
            return Double(value)
        }
        if let value = value as? String {
            return Double(value) ?? 0.0
        }
        return 0.0
    }

    private static func lineMap(
        pageIndex: Int,
        lineIndex: Int,
        selection: CPDFSelection
    ) -> [String: Any] {
        return [
            "page_index": pageIndex,
            "line_index": lineIndex,
            "location": selection.range.location,
            "length": selection.range.length,
            "rect": rectMap(from: selection.bounds)
        ]
    }

    private static func rectMap(from rect: CGRect) -> [String: Double] {
        return [
            "left": rect.minX,
            "top": rect.minY,
            "right": rect.maxX,
            "bottom": rect.maxY
        ]
    }
}
