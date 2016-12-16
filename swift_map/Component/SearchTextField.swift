//
//  SearchTextField.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/1.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = Color_white;
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.size.height));
        self.leftView = leftView;
        self.leftViewMode = .always;
        
        self.clearButtonMode = .always;
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = Color_searchTextFieldBor_Line.cgColor;
        
        self.font = UIFont.systemFont(ofSize: 14);
        
        
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = true;
    }
    
    func setLeftView(leftView: UIView, mode: UITextFieldViewMode) {
        self.leftView = leftView;
        self.leftViewMode = mode;
    }
    func setLeftViewWithImageName(imageName: String, mode: UITextFieldViewMode) {
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: self.frame.size.height + 10, height: self.frame.size.height - 10));
        imageView.contentMode = .scaleAspectFit;
        imageView.image = ToolModule.getImagePath(imageName: imageName);
        self.leftView = imageView;
        self.leftViewMode = mode;
    }
    func setRightView(rightView: UIView, mode: UITextFieldViewMode) {
        self.rightView = rightView;
        self.rightViewMode = mode;
    }
    
}
