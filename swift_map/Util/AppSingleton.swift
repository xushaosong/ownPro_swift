//
//  AppSingleton.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/9.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class AppSingleton: NSObject {
    
    let rootVC: RootViewController = RootViewController();
    var rootNAVC: APPNavigationController?
    
    static let sharedInstance = AppSingleton();
    var userLocation: AppUserLocation?;
    private override init(){}

    // 设置当前选中的tabbarItem
    func selecteTabbarItem(index: TabbarItemType) {
        self.rootVC.setSelectedItem(index: index);
    }

    // 当前用户的位置信息
    
}
