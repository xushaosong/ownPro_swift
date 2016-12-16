//
//  SearchCategoryCell.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/8.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class SearchCategoryCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let contentButton: UIButton = UIButton(type: .custom);
    let topLine: UIView = UIView();
    let leftLine: UIView = UIView();
    let rightLine: UIView = UIView();
    let bottomLine: UIView = UIView();
    
    var data: Dictionary<String, String>? {
        didSet {
            self.contentButton.setTitle(data?["type"], for: .normal);
        }
    };
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.contentView.addSubview(contentButton);
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(leftLine)
        self.contentView.addSubview(rightLine)
        
        contentButton.setTitleColor(Color_black, for: .normal);
        contentButton.isUserInteractionEnabled = false;
        contentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        topLine.backgroundColor = Color_Line_light;
        bottomLine.backgroundColor = Color_Line_light;
        leftLine.backgroundColor = Color_Line_light;
        rightLine.backgroundColor = Color_Line_light;
        
        let bgView = UIView();
        bgView.backgroundColor = Color_SearchCategory_Item_Highlight;
        
        self.selectedBackgroundView = bgView;
        
//        contentButton.setBackgroundImage(ToolModule.createImageWithColor(color: Color_SearchCategory_Item_Highlight), for: .highlighted)
        
        
        contentButton.snp.makeConstraints { (constraint) in
            constraint.top.equalToSuperview();
            constraint.bottom.equalToSuperview();
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
        };
        topLine.snp.makeConstraints { (constraint) in
            constraint.top.equalToSuperview();
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.height.equalTo(1);
        };
        bottomLine.snp.makeConstraints { (constraint) in
            constraint.bottom.equalToSuperview();
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.height.equalTo(1);
        };
        leftLine.snp.makeConstraints { (constraint) in
            constraint.left.equalToSuperview();
            constraint.top.equalToSuperview().inset(5);
            constraint.bottom.equalToSuperview().inset(5);
            constraint.width.equalTo(1);
        };
        rightLine.snp.makeConstraints { (constraint) in
            constraint.right.equalToSuperview();
            constraint.top.equalToSuperview().inset(5);
            constraint.bottom.equalToSuperview().inset(5);
            constraint.width.equalTo(1);
        }
        
    }
    
    
    
}
