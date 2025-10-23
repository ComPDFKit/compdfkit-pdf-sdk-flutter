//
//  ColorHelper.swift
//  compdfkit_flutter
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.

import UIKit

class ColorHelper {
    static func colorWithHexString (hex:String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // String should be 6 or 8 characters
        if cString.count < 6 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("0X") {
            cString = String(cString.dropFirst(2))
        }
        
        if cString.hasPrefix("#") {
            cString = String(cString.dropFirst())
        }
        
        if cString.count < 6 {
            return UIColor.clear
        }
        
        if cString.count == 6 {
            let rRange = cString.startIndex ..< cString.index(cString.startIndex, offsetBy: 2)
            let rString = cString.substring(with: rRange)

            let gRange = cString.index(cString.startIndex, offsetBy: 2) ..< cString.index(cString.startIndex, offsetBy: 4)
            let gString = cString.substring(with: gRange)

            let bRange = cString.index(cString.startIndex, offsetBy: 4) ..< cString.index(cString.startIndex, offsetBy: 6)
            let bString = cString.substring(with: bRange)

            
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0

            Scanner(string: rString).scanHexInt32(&r)

            Scanner(string: gString).scanHexInt32(&g)

            Scanner(string: bString).scanHexInt32(&b)
            
            var alpha: CUnsignedInt = 255
            
            return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha) / 255.0)
        } else if cString.count == 8 {
            let aRange = cString.startIndex ..< cString.index(cString.startIndex, offsetBy: 2)
            let aString = cString.substring(with: aRange)
            
            let rRange = cString.index(cString.startIndex, offsetBy: 2) ..< cString.index(cString.startIndex, offsetBy: 4)
            let rString = cString.substring(with: rRange)

            let gRange = cString.index(cString.startIndex, offsetBy: 4) ..< cString.index(cString.startIndex, offsetBy: 6)
            let gString = cString.substring(with: gRange)

            let bRange = cString.index(cString.startIndex, offsetBy: 6) ..< cString.index(cString.startIndex, offsetBy: 8)
            let bString = cString.substring(with: bRange)

            
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0, a:CUnsignedInt = 0

            Scanner(string: rString).scanHexInt32(&r)

            Scanner(string: gString).scanHexInt32(&g)

            Scanner(string: bString).scanHexInt32(&b)
            
            Scanner(string: aString).scanHexInt32(&a)
            
            return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
        } else {
            return UIColor.clear
        }
    }
}

extension UIColor {
    func toHexString() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
}
