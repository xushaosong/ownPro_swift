//
//  AppUserLocation.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/1.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class AppUserLocation: NSObject {
    
    var maUserLocation: MAUserLocation?;
    var reGeoCodeData: AMapReGeocode?
    var userCurrentCity: String?;
    
    /*
     ----------------
     formattedAddress:Optional("上海市浦东新区康桥镇川周公路3119号汤巷雅苑")
     ----------------
     province:Optional("上海市")
     city:Optional("")
     district:Optional("浦东新区")
     township:Optional("康桥镇")
     building:Optional("")
     street:Optional("川周公路")
     number:Optional("3119号")
     商圈列表--------------
     business:Optional("康桥")
     道路信息--------------
     road:Optional("环桥路")
     road:Optional("秀沿路")
     road:Optional("川周公路")
     道路路口信息--------------
     firstName:Optional("环桥路"), secondName:Optional("秀沿路")
     兴趣点信息--------------
     name:Optional("上海农商银行(横沔支行)"), address:Optional("秀沿路2579-2581号")
     name:Optional("汤巷雅苑"), address:Optional("环桥路1136弄")
     name:Optional("汤巷中心村东区"), address:Optional("创业路78弄1-153号汤巷中心村")
     name:Optional("全季酒店(上海康桥秀沿路店)"), address:Optional("秀沿路2682号附近")
     name:Optional("锦江之星酒店(上海国际旅游度假区秀沿路地铁站店)"), address:Optional("秀沿路2546号")
     name:Optional("麦当劳(秀沿路店)"), address:Optional("秀沿路2552-2562号")
     name:Optional("上海迪康酒店(浦东机场迪斯尼店)"), address:Optional("康桥镇秀沿路2571号")
     name:Optional("复美大药房(祝桥秀沿店)"), address:Optional("秀沿路2573号")
     name:Optional("火锅传奇(秀沿路店)"), address:Optional("康桥镇秀沿路2578号")
     name:Optional("文怡苑1期"), address:Optional("秀沿路2585弄1-30号")
     name:Optional("文怡苑"), address:Optional("秀沿路2547弄1-30号")
     name:Optional("玛茜达(秀沿路店)"), address:Optional("秀沿路2548-5号")
     name:Optional("阿牛嫂(秀沿路店)"), address:Optional("秀沿路2548-2号")
     name:Optional("文怡苑居委会"), address:Optional("康桥镇秀沿路2551号")
     name:Optional("华联超市(秀沿店)"), address:Optional("康桥秀沿路2567号")
     name:Optional("糖小姐甜品(秀沿路店)"), address:Optional("秀沿路2588号")
     name:Optional("汉釜宫韩国料理(秀沿路店)"), address:Optional("秀沿路2593号(近乐嘟嘟ktv)")
     name:Optional("秀怡苑"), address:Optional("环桥路1137弄")
     name:Optional("汤巷五街坊"), address:Optional("秀浦路3999弄1号")
     name:Optional("大宋御膳坊"), address:Optional("环桥路1128号")
     name:Optional("通海大酒店(秀沿店)"), address:Optional("秀沿路2533号")
     name:Optional("三湘人家(秀沿店)"), address:Optional("秀沿路2513号(近华硕)")
     name:Optional("桥迪旅馆(川周公路店)"), address:Optional("川周公路3158号(近秀沿路)")
     name:Optional("康叶菜市场"), address:Optional("康桥镇秀沿路2751号")
     name:Optional("上海Big Dream大梦国际青年旅社(迪士尼店)"), address:Optional("环桥路1137弄")
     name:Optional("如家快捷酒店(康桥镇秀沿路工业园区店)"), address:Optional("秀沿路路2495号靠近环桥路")
     name:Optional("汤巷馨村"), address:Optional("秀沿路2501弄1-41号")
     name:Optional("好药师大药房(金合欢药店)"), address:Optional("秀沿路2497号")
     name:Optional("汤巷馨村南区"), address:Optional("")
     name:Optional("沙县小吃(浦东新区康桥镇大前村西南)"), address:Optional("康桥镇秀沿路2751号康叶菜场a18-a19号")
     兴趣区域信息--------------
     name:Optional("汤巷雅苑")
     */
    
}
