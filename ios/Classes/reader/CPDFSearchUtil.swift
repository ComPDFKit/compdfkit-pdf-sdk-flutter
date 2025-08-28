//
//  CPDFSearchUtil.swift
//  Pods
//
//  Created by kdanmobile on 2025/7/23.
//

import Foundation
import ComPDFKit
import Flutter
import ComPDFKit_Tools


class CPDFSearchUtil {
    
    static func searchText(from document : CPDFDocument?, keywords : String , options : CPDFSearchOptions) -> [[String: Any]] {
        var searchResults : [Dictionary<String, Any>] = []
        if(document == nil){
            return searchResults;
        }
        if let resultArray = document?.find(keywords, with: options) as? [[CPDFSelection]] {
            
            for array in resultArray {
                for selection in array {
                    var dict: [String : Any] = [:]
                    dict["page_index"] = selection.page.pageIndexInteger
                    dict["location"] = selection.range.location
                    dict["length"] = selection.range.length
                    dict["text_range_index"] = array.firstIndex(of: selection)
                    searchResults.append(dict)

                }
            }
        }
        return searchResults;
    }
    
    
    static func selection(from document : CPDFDocument?, info : [String : Any]) -> CPDFSelection? {
        guard
            let pageIndex = info["page_index"] as? Int,
            let location = info["location"] as? Int,
            let length = info["length"] as? Int
        else {
            return nil
        }
        
        guard let page = document?.page(at: UInt(pageIndex)) else {
            return nil
        }
        
        let range = NSRange(location: location, length: length)
        return page.selection(for: range)
    }
    
    static func getSearchText(from document: CPDFDocument?, info: [String : Any]) -> String? {
        guard
            let pageIndex = info["page_index"] as? Int,
            let location = info["location"] as? Int,
            let length = info["length"] as? Int
        else {
            return nil
        }
        guard let page = document?.page(at: UInt(pageIndex)) else {
            return nil
        }
        
        let range = NSRange(location: location, length: length)
        let selection = page.selection(for: range)
        return selection?.string();
    }
}
