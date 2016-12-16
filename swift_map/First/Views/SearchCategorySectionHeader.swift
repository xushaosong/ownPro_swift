//
//  SearchCategorySectionHeader.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/10.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class SearchCategorySectionHeader: UICollectionReusableView {
    
    
    let titleLabel: UILabel = UILabel();
    let bgImg: UIImageView = UIImageView();
    let img: UIImageView = UIImageView();
    
    var bgImgWidth: CGFloat = 15;
    var imgWidth: CGFloat = 10;
    
    var title: String? {
        didSet {
            titleLabel.text = title;
        }
    };
    var color: String? {
        didSet {
            self.bgImg.backgroundColor = UIColor.colorWidthHex(hexString: color as! NSString, alpha: 0.5);
            self.img.backgroundColor = UIColor.colorWidthHex(hexString: color as! NSString, alpha: 1);
//            self.titleLabel.textColor = UIColor.colorWidthHex(hexString: color as! NSString, alpha: 1);
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.addSubview(titleLabel);
        self.addSubview(bgImg);
        self.addSubview(img);
        
        titleLabel.font = UIFont.systemFont(ofSize: 15);
        titleLabel.textColor = Color_150;
        bgImg.alpha = 0.5;
        
        self.bgImg.layer.cornerRadius = bgImgWidth / 2;
        self.bgImg.layer.masksToBounds = true;

        self.img.layer.cornerRadius = imgWidth / 2;
        self.img.layer.masksToBounds = true;

        bgImg.snp.makeConstraints { (constraint) in
            constraint.left.equalToSuperview();
            constraint.centerY.equalToSuperview();
            constraint.width.equalTo(bgImgWidth);
            constraint.height.equalTo(bgImgWidth);
        };
        img.snp.makeConstraints { (constraint) in
            constraint.centerY.equalTo(self.bgImg.snp.centerY);
            constraint.centerX.equalTo(self.bgImg.snp.centerX);
            constraint.width.equalTo(imgWidth);
            constraint.height.equalTo(imgWidth);
        };
        
        titleLabel.snp.makeConstraints { (constraint) in
            constraint.left.equalTo(self.bgImg.snp.right).offset(10);
            constraint.centerY.equalToSuperview();
        };
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
