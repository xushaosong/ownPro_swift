//
//  Enum.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/23.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import Foundation

enum TabbarItemType {
    case TABBAR_ITEM_FIRST
    case TABBAR_ITEM_SECOND
    case TABBAR_ITEM_THIRD
    case TABBAR_ITEM_FORTH
    case TABBAR_ITEM_FIFTH
    case CUSTOM
}

// 导航栏中 左、中、右 占主导的是哪个（默认是中）
enum NavigatorBarMain {
    case NavigatorBar_Center
    case NavigatorBar_Left
    case NavigatorBar_Right
}

// 评价中-星星的状态
enum EvaluateStartStatus {
    case Empty
    case Half
    case Full
}

// ActionHUD 背景颜色
enum ActionHUD_BgMode {
    case Clear
    case Gray
}
