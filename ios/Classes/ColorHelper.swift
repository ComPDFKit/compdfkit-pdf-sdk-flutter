//
//  ColorHelper.swift
//  compdfkit_flutter
//
//  Created by Xiaolong Liu on 2024/7/15.
//


import UIKit

class ColorHelper {
    static func colorWithHexString (hex:String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                

                if hexString.hasPrefix("#") {
                    hexString.remove(at: hexString.startIndex)
                }
                

                if hexString.count == 8 {
                    var rgba: UInt64 = 0
                    Scanner(string: hexString).scanHexInt64(&rgba)
                    
                    let a = CGFloat((rgba >> 24) & 0xFF) / 255.0
                    let r = CGFloat((rgba >> 16) & 0xFF) / 255.0
                    let g = CGFloat((rgba >> 8) & 0xFF) / 255.0
                    let b = CGFloat(rgba & 0xFF) / 255.0
                    
                    return UIColor(red: r, green: g, blue: b, alpha: a)
                } else {

                    return UIColor(white: 0.0, alpha: 0.0)
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
