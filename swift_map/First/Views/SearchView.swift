//
//  SearchView.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/24.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

typealias beginSearchBlock = () -> ()
typealias iconTouchBlock = () -> ()

class SearchView: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var iconButton: UIButton = UIButton(type: .custom);
    var iconRightLine: UIView = UIView();
    var searchTipTextField: UITextField = UITextField();
    var voiceButton: UIButton?;
    var searchAction: beginSearchBlock?
    var iconTouchAction: iconTouchBlock?;
    
    
    var topLine: UIView = UIView();
    var leftLine: UIView = UIView();
    var rightLine: UIView = UIView();
    var bottomLine: UIView = UIView();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
//        iconButton.image = ToolModule.getImagePath(imageName: "iconPlacehold@2x.png");
        iconButton.setImage(ToolModule.getImagePath(imageName: "default_share_interest_picsel1.png"), for: .normal)
        iconButton.layer.cornerRadius = 30 / 2;
        iconButton.layer.masksToBounds = true;
        iconButton.backgroundColor = Color_17BB92;
        iconButton.addTarget(self, action: #selector(touchIcon), for: .touchUpInside);
        iconButton.isUserInteractionEnabled = true;
        self.addSubview(iconButton);
        
        iconRightLine.backgroundColor = Color_golden_line;
        self.addSubview(iconRightLine);
        
        searchTipTextField = UITextField();
        searchTipTextField.isUserInteractionEnabled = false;
        searchTipTextField.placeholder = "搜“出租车”享专属优惠~";
        searchTipTextField.font = UIFont.systemFont(ofSize: 14);
        searchTipTextField.textColor = Color_120;
        self.addSubview(searchTipTextField);
        
        voiceButton = UIButton(type: .custom);
        voiceButton?.setImage(ToolModule.getImagePath(imageName: "voice/voice.png"), for: .normal);
        self.addSubview(voiceButton!);
        
        topLine.backgroundColor = Color_light_golden_line;
        bottomLine.backgroundColor = Color_light_golden_line;
        rightLine.backgroundColor = Color_light_golden_line;
        leftLine.backgroundColor = Color_light_golden_line;
        self.addSubview(topLine);
        self.addSubview(bottomLine);
        self.addSubview(rightLine);
        self.addSubview(leftLine);
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = Color_golden_line.cgColor;
        
        iconButton.snp.makeConstraints { (constrain) in
            constrain.height.equalTo(30);
            constrain.width.equalTo(30);
            constrain.left.equalToSuperview().inset(10);
            constrain.centerY.equalToSuperview();
        };
        iconRightLine.snp.makeConstraints { (constrain) in
            constrain.top.equalToSuperview().inset(10);
            constrain.bottom.equalToSuperview().inset(10);
            constrain.left.equalTo(self.iconButton.snp.right).offset(10)
            constrain.width.equalTo(1);
        };
        
        searchTipTextField.snp.makeConstraints { (constrain) in
            constrain.left.equalTo(self.iconRightLine.snp.right).offset(10);
            constrain.top.equalToSuperview();
            constrain.bottom.equalToSuperview();
            constrain.right.equalTo(self.voiceButton!.snp.left).offset(10);
        };
        
        voiceButton?.snp.makeConstraints({ (constraint) in
            constraint.right.equalToSuperview().inset(10);
            constraint.centerY.equalToSuperview();
            constraint.height.equalTo(40);
            constraint.width.equalTo(40)
        });
        
        topLine.snp.makeConstraints { (constraint) in
            constraint.top.equalToSuperview().inset(2);
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.height.equalTo(1);
        };
        leftLine.snp.makeConstraints { (constraint) in
            constraint.top.equalToSuperview();
            constraint.bottom.equalToSuperview();
            constraint.left.equalToSuperview().inset(2);
            constraint.width.equalTo(1);
        };
        rightLine.snp.makeConstraints { (constraint) in
            constraint.top.equalToSuperview();
            constraint.bottom.equalToSuperview();
            constraint.right.equalToSuperview().inset(2);
            constraint.width.equalTo(1);
        };
        bottomLine.snp.makeConstraints { (constraint) in
            constraint.bottom.equalToSuperview().inset(2);
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.height.equalTo(1);
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(beginSearch));
        self.addGestureRecognizer(tap);
    }
    func beginSearch() {
        if (self.searchAction != nil) {
            self.searchAction?();
        }
    }
    func touchIcon() {
        if (self.iconTouchAction != nil) {
            self.iconTouchAction!();
        }
    }
}
