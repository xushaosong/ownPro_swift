//
//  BaseViewController.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/29.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    
    let navigatorBar: APPNavigationBarView = APPNavigationBarView();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color_white;
        
        self.view.addSubview(navigatorBar);
        navigatorBar.snp.makeConstraints { (contraint) in
            contraint.left.equalToSuperview();
            contraint.right.equalToSuperview();
            contraint.top.equalToSuperview();
            contraint.height.equalTo(64);
        };
        navigatorBar.backgroundColor = Color_17BB92;
        navigatorBar.backItemClick = { () in
            self.leftBackItemClick();
        };
    }
    
    func leftBackItemClick() {
        self.navigationController?.popViewController(animated: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (self.navigationController?.viewControllers.count == 1) {
            return false;
        } else {
            return true;
        }
    }
}
