//
//  UIColor+Category.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/10.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func colorWidthHex(hexString: NSString, alpha: CGFloat) -> UIColor {
        
        var cString: NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        
        if (cString.length < 6) {
            return UIColor.clear;
        }
        
        // 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if (cString.hasPrefix("0X") || cString.hasPrefix("0x")) {
            cString = cString.substring(from: 2) as NSString;
        }
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: 1) as NSString;
        }
        if (cString.length != 6) {
            return UIColor.clear
        }
        
        var range = NSMakeRange(0, 2);
        
        let rString = cString.substring(with: range);
        
        range.location = 2;
        let gString = cString.substring(with: range);
        
        range.location = 4;
        let bString = cString.substring(with: range);
        
        var r: UInt64 = 0;
        var g: UInt64 = 0;
        var b: UInt64 = 0;
        Scanner.init(string: rString).scanHexInt64(&r);
        Scanner.init(string: gString).scanHexInt64(&g);
        Scanner.init(string: bString).scanHexInt64(&b);
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }

}
