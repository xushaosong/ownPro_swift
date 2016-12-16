//
//  SearchAddrTextFieldView.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/4.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

typealias ClickSearchBlock = () -> ()
class SearchAddrTextFieldView: UIView {
    
    let searchTextField: SearchTextField = SearchTextField();
    let searchButton: UIButton = UIButton(type: .custom);
    var searchBlock: ClickSearchBlock?;
    
    private var needSearchButton: Bool = false;
    private var searchButtonIsShow: Bool = false;
    private let searchButtonWidth: CGFloat = 50;
    
    private override init(frame: CGRect) {
        super.init(frame: frame);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame:CGRect{
        didSet {
            
        }
    }
    
    init(frame: CGRect, needSearchButton: Bool) {
        super.init(frame: frame);
        self.clipsToBounds = true;
        
        self.needSearchButton = needSearchButton;
        self.addSubview(self.searchTextField);
        self.addSubview(self.searchButton);
        self.searchButton.isHidden = true;
        
        self.searchTextField.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height);
        self.searchButton.frame = CGRect(x: frame.size.width, y: 0, width: searchButtonWidth, height: frame.size.height);
        
        self.searchButton.setTitle("搜索", for: .normal);
        self.searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        self.searchButton.setTitleColor(Color_white, for: .normal);
        self.searchButton.setBackgroundImage(ToolModule.getImagePath(imageName: "search/search_btn_bg.png"), for: .normal);
        self.searchButton.addTarget(self, action: #selector(beginSearch), for: .touchUpInside);
//        self.searchTextField.layer.anchorPoint = CGPoint(x: 0, y: 0.5);
//        self.searchTextField.layer.position = CGPoint(x: self.searchTextField.layer.position.x - self.searchTextField.frame.size.width / 2, y: self.searchTextField.layer.position.y);
    }
    
    
    
    func hideSearchButton() {
        
        if (self.needSearchButton == false) {
            return;
        }
        if (self.searchButtonIsShow == false) {
            return;
        }
        self.searchButtonIsShow = false;
        
        UIView.animate(withDuration: 0.25, animations: {Void in
            self.searchButton.transform = CGAffineTransform.identity;
            self.searchTextField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height);
        }, completion: {(complete) in
            self.searchButton.isHidden = !self.searchButtonIsShow;
        });
    }
    func showSearchButton() {
        
        if (self.needSearchButton == false) {
            return;
        }
        if (self.searchButtonIsShow == true) {
            return;
        }
        self.searchButtonIsShow = true;
        self.searchButton.isHidden = !self.searchButtonIsShow;
        UIView.animate(withDuration: 0.25, animations: { Void in
            self.searchButton.transform = CGAffineTransform(translationX: -self.searchButtonWidth, y: 0);
            self.searchTextField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - self.searchButtonWidth - 10, height: self.frame.size.height);
        })
    }
    func beginSearch() {
        if (searchBlock != nil) {
            searchBlock!();
        }
    }
}
