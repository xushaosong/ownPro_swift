//
//  SearchHeaderItem.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/7.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

typealias clickActionBlock = () -> ()

class SearchHeaderItem: UIView {

    // 图片所占比例
    private let IMAGE_SCALE: CGFloat = 0.6;
    
    var clickAction: clickActionBlock?;
    
    var titleLable: UILabel?
    var iconImageView: UIImageView?
    
    var title: String?
    var selectedColor: UIColor?
    var normalColor: UIColor?
    var normalIMG: String?
    var selectedIMG: String?
    var itemType: TabbarItemType?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, normalColor: UIColor?, selectedColor: UIColor?, normalIMG: String?, selectedIMG: String?, itemType: TabbarItemType?) {
        super.init(frame: CGRect.zero);
        self.title = title;
        self.selectedColor = selectedColor;
        self.normalColor = normalColor;
        self.normalIMG = normalIMG == nil ? "" : normalIMG;
        self.selectedIMG = selectedIMG == nil ? "" : selectedIMG;
        self.itemType = itemType == nil ? .CUSTOM : itemType;
        createView();
    }
    
    func createView() {
        
        self.iconImageView = UIImageView();
        self.iconImageView?.contentMode = .scaleAspectFit;
        if (self.normalIMG != nil) {
            self.iconImageView?.image = ToolModule.getImagePath(imageName: self.normalIMG!)
        }
        self.addSubview(self.iconImageView!);
        
        if (self.title != nil) {
            self.titleLable = UILabel();
            self.titleLable?.font = UIFont.systemFont(ofSize: 14)
            self.titleLable?.textAlignment = .center;
            if (self.normalColor != nil) {
                self.titleLable?.textColor = normalColor;
            }
            self.titleLable?.text = self.title;
            self.addSubview(self.titleLable!);
            
            self.iconImageView?.snp.makeConstraints({ (constraint) in
                constraint.top.equalToSuperview();
                constraint.left.equalToSuperview();
                constraint.right.equalToSuperview();
                //                constraint.height.equalTo(Tabbar_HEIGHT * IMAGE_SCALE);
                constraint.height.equalTo(self.snp.height).multipliedBy(IMAGE_SCALE);
            });
            
            self.titleLable?.snp.makeConstraints({ (constraint) in
                constraint.top.equalTo(self.iconImageView!.snp.bottom).offset(0);
                constraint.left.equalToSuperview();
                constraint.right.equalToSuperview();
                constraint.bottom.equalToSuperview();
            });
            
        } else {
            self.iconImageView?.snp.makeConstraints({ (constraint) in
                constraint.top.equalToSuperview();
                constraint.left.equalToSuperview();
                constraint.right.equalToSuperview();
                constraint.bottom.equalToSuperview();
            });
        }
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (self.selectedIMG != nil) {
            self.iconImageView?.image = ToolModule.getImagePath(imageName: self.selectedIMG!);
        }
        if (self.selectedColor != nil) {
            self.titleLable?.textColor = self.selectedColor
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.iconImageView?.image = ToolModule.getImagePath(imageName: self.normalIMG!);
        self.titleLable?.textColor = self.normalColor;
        
        if (clickAction != nil) {
            clickAction!();
        }
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.iconImageView?.image = ToolModule.getImagePath(imageName: self.normalIMG!);
        self.titleLable?.textColor = self.normalColor;
    }
}
