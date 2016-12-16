//
//  SearchCategorySectionDecoration.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/10.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class SearchCategorySectionDecoration: UICollectionReusableView {
    
    let leftView: UIView = UIView();
    var leftColor: UIColor = UIColor.clear {
        didSet {
            self.leftView.backgroundColor = leftColor;
        }
    };
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes);
        let att = layoutAttributes as! CollectionViewDecorationLayoutAttributes;
        leftColor = att.leftColor;
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.layer.cornerRadius = 4;
        self.backgroundColor = Color_white;
        self.clipsToBounds = true;
        self.addSubview(leftView)
        leftView.backgroundColor = Color_Subway_NUM_7_BG;
        leftView.snp.makeConstraints { (constraint) in
            constraint.left.equalToSuperview();
            constraint.top.equalToSuperview();
            constraint.bottom.equalToSuperview();
            constraint.width.equalTo(10);
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
