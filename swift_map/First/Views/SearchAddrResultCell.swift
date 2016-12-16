//
//  SearchAddrResultCell.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/2.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

let resultNameFont: UIFont = UIFont.systemFont(ofSize: 14);
let resultSubNameFont: UIFont = UIFont.systemFont(ofSize: 14);
let resultAddrFont: UIFont = UIFont.systemFont(ofSize: 12);
let resultTypeFont: UIFont = UIFont.systemFont(ofSize: 12);
let distanceFont: UIFont = UIFont.systemFont(ofSize: 12);
let costFont: UIFont = UIFont.systemFont(ofSize: 12);
let routeFont: UIFont = UIFont.systemFont(ofSize: 12);

let iconWidthAndHeight: CGFloat = 20;
let contentLeftPadding: CGFloat = 15;
let contentRightPadding: CGFloat = 15;
let iconPaddingRightContentView: CGFloat = 15;
class SearchAddrResultCell: UITableViewCell {
    
    
    let iconImageView: UIImageView  = UIImageView();
    let rightContentView: UIView    = UIView();
    let resultName: UILabel         = UILabel();
    let resultSubName: UILabel      = UILabel();
    let resultAddr: UILabel         = UILabel();
    let evaluateView: EvaluateView  = EvaluateView();
    let cosLabel: UILabel           = UILabel();
    var routeLabelArray: Array<UILabel> = Array();
    let routeLabelView: UIView      = UIView();
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);


        self.selectedBackgroundView = UIView();
        self.selectedBackgroundView?.backgroundColor = Color_Line;
        
        self.contentView.addSubview(iconImageView);
        self.contentView.addSubview(rightContentView);
        self.resultAddr.numberOfLines = 0;
        self.rightContentView.clipsToBounds = true;
        self.rightContentView.addSubview(resultName);
        self.rightContentView.addSubview(resultSubName);
        self.rightContentView.addSubview(resultAddr);
        self.rightContentView.addSubview(evaluateView);
        self.rightContentView.addSubview(cosLabel);
        self.rightContentView.addSubview(self.routeLabelView);
        
        self.resultName.font = resultNameFont;
        self.resultSubName.font = resultSubNameFont;
        self.resultAddr.font = resultAddrFont;
        self.resultAddr.textColor = Color_SearchResult_Type_Address;
        self.cosLabel.font = costFont;
        self.cosLabel.textColor = Color_SearchResult_Type_Address;
        
        self.resultSubName.sizeToFit();
        self.resultAddr.sizeToFit();
        self.cosLabel.sizeToFit();
    }
    
    var data: SearchAddrResultFrame? {
        
        didSet {
            removeAllRouteLabel();
            
            if (data?.location != nil) {
                // 位置
                iconImageView.image = ToolModule.getImagePath(imageName: "map/express_address_detail_location.png");
            } else {
                // 搜索
                iconImageView.image = ToolModule.getImagePath(imageName: "search/ufo_search_icon.png");
            }
            iconImageView.snp.remakeConstraints { (constraint) in
                constraint.height.equalTo(iconWidthAndHeight);
                constraint.width.equalTo(iconWidthAndHeight);
                constraint.left.equalToSuperview().inset(contentLeftPadding);
                constraint.centerY.equalToSuperview();
            };
        
            self.rightContentView.snp.remakeConstraints { (constraint) in
                constraint.left.equalTo(iconImageView.snp.right).offset(iconPaddingRightContentView);
                constraint.right.equalToSuperview().inset(contentRightPadding);
                constraint.top.equalToSuperview();
                constraint.bottom.equalToSuperview();
                
            }
            
            self.resultName.text = data?.name;
            
            self.resultName.snp.remakeConstraints { (constraint) in
                constraint.left.equalToSuperview();
                if (data?.subName == nil) {
                    constraint.right.equalToSuperview();
                }
                constraint.width.equalTo(ToolModule.getString(stringName: (data?.name)! as NSString, font: resultNameFont, maxSize: CGSize(width: 1000, height: (data?.searchResult_NameHeight)!)).width);
                constraint.top.equalToSuperview().inset((data?.topBottomPadding)!);
                constraint.height.equalTo((data?.searchResult_NameHeight)!);
                
            };
            
            self.resultName.textColor = Color_black;
            
            if (data?.searchText != nil && data?.searchText != "") {
                let attributeStr = NSMutableAttributedString(string: (data?.name)!)
                if ((data?.name?.range(of: (data?.searchText)!)) != nil) {
                    
                    let attr1 = [NSForegroundColorAttributeName : Color_SearchText_Match_Text];
                    let range: NSRange = ((data?.name)! as NSString).range(of: (data?.searchText)!);
                    attributeStr.addAttributes(attr1, range: range);
                    
                }
                
                self.resultName.attributedText = attributeStr;
            }
            if (data?.subName != nil) {
                self.resultSubName.isHidden = false;
                self.resultSubName.snp.remakeConstraints({ (constraint) in
                    constraint.left.equalTo(self.resultName.snp.right).offset(0);
                    constraint.centerY.equalTo(self.resultName.snp.centerY);
                    constraint.right.equalToSuperview();
                });
                
                self.resultSubName.text = " - \((data?.subName)!)";
                if (data?.subName == "地铁站") {
                    self.resultSubName.textColor = Color_SearchText_Match_Subway_Text;
                } else if (data?.subName == "公交站") {
                    self.resultSubName.textColor = Color_SearchText_Match_BusStation_Text;
                } else {
                    self.resultSubName.textColor = Color_black;
                }
            } else {
                self.resultSubName.isHidden = true;
            }
            var isHaveTypeOrAddress: Bool = false;
            self.routeLabelView.isHidden = true;
            self.resultAddr.isHidden = true;
            if ((data?.type) != nil) {
                
                isHaveTypeOrAddress = true;
                
                if (((data?.type?.range(of: "地铁站")) != nil) || ((data!.type?.range(of: "公交车站")) != nil) ||
                    ((data!.type?.range(of: "公交站")) != nil)) {

                    self.routeLabelView.isHidden = false;
                    if ((data?.type?.range(of: "地铁站")) != nil) {
                        self.iconImageView.image = ToolModule.getImagePath(imageName: "map/default_generalsearch_magicbox_icon_09.png");
                    }
                    if ((data?.type?.range(of: "公交车站")) != nil || ((data!.type?.range(of: "公交站")) != nil)) {
                        self.iconImageView.image = ToolModule.getImagePath(imageName: "map/default_generalsearch_tips_bus_icon_normal.png");
                    }
                    
                    setRouteData();
                    
                } else {
                    
                    if (data?.detailAddress != nil) {
                        if (data?.detailAddress != "") {
                            self.resultAddr.isHidden = false;
                            self.resultAddr.text = data?.detailAddress;
                            self.resultAddr.snp.remakeConstraints({ (constraint) in
//                                constraint.left.equalTo(self.resultType.snp.right).offset(5)
                                constraint.left.equalToSuperview();
                                constraint.right.equalToSuperview();
//                                constraint.centerY.equalTo(self.resultType.snp.centerY);
                                constraint.height.equalTo((data?.searchResult_AddrHeight)!)
                                constraint.top.equalTo(self.resultName.snp.bottom).offset((data?.contentMargin)!);
                            })
                        }
                    }
                }
            } else {
                
                if (data?.detailAddress != nil) {
                    if (data?.detailAddress != "") {
                        isHaveTypeOrAddress = true;
                        self.resultAddr.isHidden = false;
                        self.resultAddr.text = data?.detailAddress;
                        self.resultAddr.snp.remakeConstraints({ (constraint) in
                            constraint.left.equalToSuperview();
                            constraint.right.equalToSuperview();
                            constraint.top.equalTo(self.resultName.snp.bottom).offset((data?.contentMargin)!);
                            constraint.height.equalTo((data?.searchResult_AddrHeight)!)
                        })
                    }
                }
            }
            var label: UIView? = nil;
            
            if (isHaveTypeOrAddress) {
                if (!self.routeLabelView.isHidden) {
                    label = self.routeLabelView;
                }
                if (!self.resultAddr.isHidden) {
                    label = self.resultAddr;
                }
            }
            
            self.evaluateView.isHidden = true;
            self.cosLabel.isHidden = true;
            if (data?.evaluateData != 0.0 || data?.cost != nil) {
                if (data?.evaluateData != 0.0) {
                    self.evaluateView.isHidden = false;
                    self.evaluateView.value = (data?.evaluateData)!;
                    self.evaluateView.snp.remakeConstraints({ (constraint) in
                        constraint.left.equalToSuperview();
                        if (label != nil) {
                            constraint.top.equalTo((label?.snp.bottom)!).offset((data?.contentMargin)!);
                        } else {
                            constraint.top.equalTo(self.resultName.snp.bottom).offset((data?.contentMargin)!);
                        }
                        constraint.height.equalTo((data?.searchResult_evaluateHeight)!);
                    });
                    if (self.data?.cost != nil) {
                        
                        self.cosLabel.isHidden = false;
                        self.cosLabel.text = self.data?.cost;
                        self.cosLabel.snp.remakeConstraints({ (constraint) in
                            constraint.left.equalTo(self.evaluateView.snp.right).offset(5);
                            constraint.centerY.equalTo(self.evaluateView.snp.centerY);
                        })
                    }
                } else {
                    self.cosLabel.isHidden = false;
                    self.cosLabel.snp.remakeConstraints({ (constraint) in
                        constraint.left.equalToSuperview();
                        if (label != nil) {
                            constraint.top.equalTo((label?.snp.bottom)!).offset((data?.contentMargin)!);
                        } else {
                            constraint.height.equalTo((data?.searchResult_evaluateHeight)!);
                            
                            constraint.top.equalTo(self.resultName.snp.bottom).offset((data?.contentMargin)!);
                        }
                    })
                }
            }
        }
    }
    
    func setRouteData() {
        
        var lastLabel: UILabel?;
        self.routeLabelView.snp.remakeConstraints { (constraint) in
            constraint.top.equalTo(self.resultName.snp.bottom).offset((data?.contentMargin)!);
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.height.equalTo((data?.searchResult_routeViewHeight)!);
        };
        var y: CGFloat = 0;
        var x: CGFloat = 0;
        var lastRouteWidth: CGFloat = 0;
        for (index, routeData) in (data?.routeArray)!.enumerated() {
            let label = createLabel(index: index);
            label.text = routeData.routeName;
            label.layer.backgroundColor = setRouteColor(route: routeData.routeName.replacingOccurrences(of: " ", with: "")).cgColor;
            
            self.routeLabelView.addSubview(label);
            
            let routeWidth = routeData.routeLength;
            if (lastLabel == nil) {
                label.snp.remakeConstraints({ (constraint) in
                    constraint.top.equalToSuperview();
                    constraint.height.equalTo((data?.searchResult_oneRouteHeight)!);
                    constraint.width.equalTo(routeData.routeLength);
                    constraint.left.equalToSuperview();
//                    if (index == (route?.count)! - 1) {
//                        label.snp.updateConstraints({ (constraint) in
//                            constraint.right.equalToSuperview();
//                        })
//                    }
                })
            } else {
                if (lastRouteWidth + routeWidth > scWidth - contentLeftPadding - iconWidthAndHeight - iconPaddingRightContentView - contentRightPadding) {
                    x = 0;
                    y = y + (data?.searchResult_oneRouteHeight)! + 5;
                    lastRouteWidth = 0;
                } else {
                    x = lastRouteWidth;
                }
                
                label.snp.remakeConstraints({ (constraint) in
                    constraint.top.equalToSuperview().inset(y);
                    constraint.height.equalTo((data?.searchResult_oneRouteHeight)!);
                    constraint.width.equalTo(routeData.routeLength);
                    constraint.left.equalToSuperview().inset(x);
//                    if (index == (route?.count)! - 1) {
//                        label.snp.updateConstraints({ (constraint) in
//                            constraint.right.equalToSuperview();
//                        })
//                    }
                });
            }
            
            lastLabel = label;
            lastRouteWidth += routeWidth + 5;
        }
//        self.routeLabelView.contentSize = CGSize(width: (lastLabel?.frame.maxX)!, height: 0);
    }
    func createLabel(index: Int) -> UILabel {
        var returnLabel: UILabel;
        if (routeLabelArray.count - 1 >= index) {
            returnLabel = routeLabelArray[index];
        } else {
            returnLabel = UILabel();
            returnLabel.font = routeFont;
            returnLabel.textColor = Color_white;
            returnLabel.layer.cornerRadius = 2;
            returnLabel.layer.masksToBounds = true;
            routeLabelArray.append(returnLabel);
        }
        return returnLabel;
    }
    func removeAllRouteLabel() {
        for label in routeLabelArray {
            label.removeFromSuperview();
        }
    }
    
    
    func setRouteColor(route: String) -> UIColor {
        
        if (route.range(of: "1号线") != nil) {
            return Color_Subway_NUM_1_BG;
        } else if (route.range(of: "2号线") != nil) {
            return Color_Subway_NUM_2_BG;
        } else if (route.range(of: "3号线") != nil) {
            return Color_Subway_NUM_3_BG;
        } else if (route.range(of: "4号线") != nil) {
            return Color_Subway_NUM_4_BG;
        } else if (route.range(of: "5号线") != nil) {
            return Color_Subway_NUM_5_BG;
        } else if (route.range(of: "6号线") != nil) {
            return Color_Subway_NUM_6_BG;
        } else if (route.range(of: "7号线") != nil) {
            return Color_Subway_NUM_7_BG;
        } else if (route.range(of: "8号线") != nil) {
            return Color_Subway_NUM_8_BG;
        } else if (route.range(of: "9号线") != nil) {
            return Color_Subway_NUM_9_BG;
        } else if (route.range(of: "10号线") != nil) {
            return Color_Subway_NUM_10_BG;
        } else if (route.range(of: "11号线") != nil) {
            return Color_Subway_NUM_11_BG;
        } else if (route.range(of: "12号线") != nil) {
            return Color_Subway_NUM_12_BG;
        } else if (route.range(of: "13号线") != nil) {
            return Color_Subway_NUM_13_BG;
        } else if (route.range(of: "16号线") != nil) {
            return Color_Subway_NUM_16_BG;
        } else if (route.range(of: "磁悬浮") != nil) {
            return Color_Subway_NUM_CXF_BG;
        } else {
            return Color_BusStation_BG;
        }
    }
}

class SearchAddrResultFrame: NSObject {
    
    override init() {
        super.init();
    }
    
    var name: String?;
    var subName: String?;
    var type: String?;
//    var address: String?; // 详细地址/路线信息
//    var province: String?;
//    var city: String? // note：直辖市的city和province是同一个值
//    var district: String? // 区
    var detailAddress: String? // 地址
    var location: AMapGeoPoint?; // 坐标计算距离
    var evaluateData: CGFloat = 0; // 评价分数
    var cost: String?; // 人均消费
    var searchText: String?; // 搜索的内容
    var searchResultCellHeight: CGFloat = 0;
    var routeArray: Array<Route> = Array();
    
    
    var tip: AMapTip? {
        
        didSet {
            
            if (tip?.name.range(of: "(") != nil && tip?.name.range(of: ")") != nil) {
                do {
                    let regex = try NSRegularExpression(pattern: "\\((.*?)\\)", options: .caseInsensitive);
                    let res = regex.matches(in: (tip?.name)!, options: .init(rawValue: 0), range: NSMakeRange(0, (tip?.name)!.characters.count))
                    for (index, result) in res.enumerated() {
                        if (index == res.count - 1) {
                            self.name = ((tip?.name)! as NSString).substring(to: result.range.location);
                            self.subName = ((tip?.name)! as NSString).substring(with: NSMakeRange(result.range.location + 1, result.range.length - 2));
                        }
                    }
                } catch {
                    print(error.localizedDescription);
                }
            } else {
                self.name = tip?.name;
                self.subName = nil;
            }
            
            if (tip?.name.range(of: "公交站") != nil) {
                self.type = "公交站";
            }
            if (tip?.name.range(of: "地铁站") != nil) {
                self.type = "地铁站";
            }
            
//            self.district = tip?.district;
//            self.address = tip?.address;
            self.location = tip?.location;
//            self.evaluateData = 3.5;
//            self.cost = "3.4/元"
            self.detailAddress = getAddress();
            calculateHeight();
            /*
            district="上海市黄浦区",
            uid="B00157H7AH",
            address="西藏中路268号来福士广场1F层",
            name="肯德基(来福士广场)",
            location=<31.232876, 121.476285>,
            adcode="310101"
             */
        }
    }
    
    var topBottomPadding: CGFloat = 15; // 内容区域距离上下边框的间距
    let contentMargin: CGFloat = 10; // 垂直方向内容之间的间距
    let searchResult_NameHeight: CGFloat = 15; // 搜索结果标题高度
    var searchResult_AddrHeight: CGFloat = 15; // 搜索结果类型高度
    let searchResult_evaluateHeight: CGFloat = 15; // 评价信息高度
    var searchResult_routeViewHeight: CGFloat = 15; // 线路View的高度
    let searchResult_oneRouteHeight: CGFloat = 15;
    
    func calculateHeight() {
        searchResultCellHeight = topBottomPadding * 2 + searchResult_NameHeight;
        if ((self.detailAddress != nil && self.detailAddress != "") || (self.type != nil && self.type != "" && tip?.address != nil && tip?.address != "" )) {
            
            if (self.type != nil && self.type != "") {
                
                calculateRouteAllow();
                
                var width: CGFloat = 0.0;
                var latestLine: Int = 1;
                for routeData in self.routeArray {
                    width += routeData.routeLength;
                    
                    let line = Int(width / (scWidth - contentLeftPadding - iconWidthAndHeight - iconPaddingRightContentView - contentRightPadding)) + 1;
                    
                    searchResult_routeViewHeight = searchResult_oneRouteHeight * CGFloat(Float(line)) + (CGFloat(Float(line)) - 1) * 5;
                    if (latestLine != line) {
                        
                    } else {
                        width = width + 5;
                    }
                    latestLine = line;
                }
                searchResultCellHeight += (contentMargin +
                    searchResult_routeViewHeight);
            } else if (self.detailAddress != nil && self.detailAddress != ""){
                let size: CGSize = ToolModule.getString(stringName: (self.detailAddress! as NSString), font: distanceFont, maxSize: CGSize(width: scWidth - contentLeftPadding - iconWidthAndHeight - iconPaddingRightContentView - contentRightPadding, height: 10000));
                
                searchResultCellHeight += (contentMargin +
                    size.height);
                searchResult_AddrHeight = size.height;
            }
        }
        if (self.evaluateData != 0.0 || self.cost != nil) {
            searchResultCellHeight += (contentMargin + searchResult_evaluateHeight);
        }
        if (searchResultCellHeight == 2 * topBottomPadding + searchResult_NameHeight) {
            topBottomPadding += 10;
            searchResultCellHeight = 2 * topBottomPadding + searchResult_NameHeight;
        }
    }
    
    func getAddress() -> String? {
        var name: String = "";
        name += (tip?.district == nil && tip?.district == "") ? "" : (tip?.district)!;
        name += (tip?.address == nil && tip?.address == "") ? "" : (tip?.address)!;
        return name == "" ? nil : name;
    }
    
    func calculateRouteAllow() {
        let routeArray = tip?.address?.components(separatedBy: ";");
        for routeName in routeArray! {
            let routeData: Route = Route();
            routeData.routeName = " \(routeName) ";
            routeData.routeLength = ToolModule.getString(stringName: routeData.routeName as NSString, font: routeFont, maxSize: CGSize(width: 1000, height: 15)).width;
            
            if (self.routeArray.count == 0) {
                self.routeArray.append(routeData);
            } else {
                for (index, route) in self.routeArray.enumerated() {
                    if (route.routeLength >= routeData.routeLength) {
                        self.routeArray.insert(routeData, at: index);
                        break;
                    }
                    if (self.routeArray.count - 1 == index) {
                        self.routeArray.append(routeData);
                    }
                }
            }
        }
    }
}

class Route: NSObject {
    
    var routeName: String = "";
    var routeLength: CGFloat = 0;
    
}

