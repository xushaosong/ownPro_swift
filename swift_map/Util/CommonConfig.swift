//
//  CommonConfig.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/10.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import Foundation
//delay(second, completion)  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, second * NSEC_PER_SEC), dispatch_get_main_queue(), completion)

func delay(time: TimeInterval, complete: @escaping ()->Void) {
    
    let deadlineTime = DispatchTime.now() + .seconds(Int(time));
    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {() -> Void in
        complete();
    })
}

// 高德API
let AMap_AppKey: String = "255ad130c1beb4bec084767baf6cda5d";

/// 屏幕高宽
let scWidth = UIApplication.shared.keyWindow!.bounds.size.width;
let scHeight = UIApplication.shared.keyWindow!.bounds.size.height;

// tabbar高度
let Tabbar_HEIGHT: CGFloat = 60;
let NavigationBar_HEIGHT: CGFloat = 64;

// tabbar选中的颜色
let Tabbar_Selected_Color: UIColor = Color_17BB92;
// tabbar未选中的颜色
let Tabbar_Normal_Color: UIColor = Color_black;
