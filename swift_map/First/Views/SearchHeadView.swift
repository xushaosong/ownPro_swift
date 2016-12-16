//
//  SearchHeadView.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/7.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

let resource = [
    [
        "title" : "美食",
        "image" : "search/default_generalsearch_keyword_food.png",
        "hightLight" : "search/default_generalsearch_keyword_food_highlighted.png",
        "index" : 0
    ],
    [
        "title" : "酒店",
        "image" : "search/default_generalsearch_keyword_hotel.png",
        "hightLight" : "search/default_generalsearch_keyword_hotel_highlighted.png",
        "index" : 1
    ],
    [
        "title" : "公交站",
        "image" : "search/default_generalsearch_keyword_bus.png",
        "hightLight" : "search/default_generalsearch_keyword_bus_highlighted.png",
        "index" : 2
    ],
    [
        "title" : "银行",
        "image" : "search/default_generalsearch_keyword_bank.png",
        "hightLight" : "search/default_generalsearch_keyword_bank_highlighted.png",
        "index" : 3
    ],
    [
        "title" : "景点",
        "image" : "search/default_generalsearch_keyword_scen.png",
        "hightLight" : "search/default_generalsearch_keyword_scen_highlighted.png",
        "index" : 4
    ],
    [
        "title" : "加油站",
        "image" : "search/default_generalsearch_keyword_gas.png",
        "hightLight" : "search/default_generalsearch_keyword_gas_highlighted.png",
        "index" : 5
    ],
    [
        "title" : "收藏夹",
        "image" : "search/default_generalsearch_keyword_collect.png",
        "hightLight" : "search/default_generalsearch_keyword_collect_highlighted.png",
        "index" : 6
    ],
    [
        "title" : "更多",
        "image" : "search/default_generalsearch_keyword_more.png",
        "hightLight" : "search/default_generalsearch_keyword_more_highlighted.png",
        "index" : 7
    ],
    
];

let itemWidth: CGFloat = 60;
let itemHeight: CGFloat = 70;
let itemViewHorPadding: CGFloat = 15;
let itemHorPadding: CGFloat = (scWidth - 4 * itemWidth - 2 * itemViewHorPadding) / 3;
let itemViewVerPadding: CGFloat = 10;
let itemVerPadding: CGFloat = 5;

typealias SearchItemClickBlock = (Int, String) -> ()

class SearchHeadView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var itemClick: SearchItemClickBlock?;
    var selfHeight: CGFloat = 0;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = Color_white;
        for (index, itemData) in resource.enumerated() {
            let col = Int(index % 4); // 列
            let row = Int(index / 4); // 行
            
            let searchItem: SearchHeaderItem = SearchHeaderItem(title: itemData["title"] as! String?, normalColor: Color_100, selectedColor: nil, normalIMG: itemData["image"] as! String?, selectedIMG: itemData["hightLight"] as! String?, itemType: nil);
            self.addSubview(searchItem);
            searchItem.snp.makeConstraints({ (constraint) in
                constraint.left.equalTo(itemViewHorPadding + CGFloat(Float(col)) * (itemWidth + itemHorPadding));
                constraint.top.equalTo(itemViewVerPadding + CGFloat(Float(row)) * (itemHeight + itemVerPadding));
                constraint.width.equalTo(itemWidth);
                constraint.height.equalTo(itemHeight);
            });
            searchItem.clickAction = { () in
                if (self.itemClick != nil) {
                    self.itemClick!(itemData["index"] as! Int, itemData["title"] as! String);
                }
            }
            
        }
        var line = resource.count / 4;
        if (resource.count % 4 > 0) {
            line += 1;
        }
        let height: CGFloat = CGFloat(Float((line))) * (itemHeight + itemVerPadding) + 2 * itemViewVerPadding;
        self.frame = CGRect(x: 0, y: 0, width: scWidth, height: height);
        selfHeight = height;
    }
}
