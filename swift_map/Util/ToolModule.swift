//
//  ToolModule.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/10.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class ToolModule: NSObject {

    // 获取图片
    // 获取图片路径
    class func getImagePath( imageName: String) -> UIImage {
        if (imageName == nil || imageName == "") {
            return UIImage();
        }
        var imageName = imageName
        let bundlePath = Bundle.main.path(forResource: "images", ofType: "bundle");
        
        if (!imageName.hasSuffix(".png") && !imageName.hasSuffix(".jpg")) {
            imageName = imageName + ".png";
        }
        let imgPath = bundlePath! + "/" + imageName;
        let image = UIImage(contentsOfFile: imgPath);
        if (image == nil) {
            return UIImage();
        }
        return image!;
    }

    // 设置导航栏标题
    class func setNavigationTitle(title: NSString) -> UILabel {
        let font = UIFont.boldSystemFont(ofSize: 18);
        let size = ToolModule.getString(stringName: title, font: font, maxSize: CGSize(width: 10000, height: 25));
        
        let navTitle = UILabel();
        navTitle.text = title as String;
        navTitle.textColor = Color_white;
        navTitle.font = font;
        navTitle.frame = CGRect(x: 0, y: 0, width: size.width, height: 40);
        return navTitle;
    }
    
    // 计算字符串长度
    class func getString(stringName: NSString, font: UIFont, maxSize: CGSize) -> CGSize {
        let dictFont = [
            NSFontAttributeName : font
        ];
        let paragraphStyle = NSMutableParagraphStyle();
        paragraphStyle.lineBreakMode = .byWordWrapping;
        var labelSize = stringName.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: dictFont, context: nil).size;
        labelSize.height = ceil(labelSize.height);
        labelSize.width = ceil(labelSize.width);
        return labelSize;
    }
    // 通过颜色生成图片
    class func createImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return theImage!;
    }
    
    
}
