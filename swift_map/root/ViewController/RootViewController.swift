//
//  RootViewController.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/9.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController, UINavigationControllerDelegate {

    
    let tabbar: UIView = UIView();
    let tabBarSelectedItemColor: UIColor = UIColor.red;
    
    var tabbarItems: Array<TabbarItem> = Array();
    
    var currentSelectedItemType: TabbarItemType?;
    var currentShowVC: UIViewController?;
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self;
        
        self.view.addSubview(tabbar);
        self.navigatorBar.isHidden = true;
        tabbar.layer.shadowColor = Color_black.cgColor;
        tabbar.layer.shadowOffset = CGSize(width: 0, height: -1);
        tabbar.layer.shadowOpacity = 0.3;
        tabbar.snp.makeConstraints { (constraint) in
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.bottom.equalToSuperview();
            constraint.height.equalTo(Tabbar_HEIGHT);
        }
        tabbar.backgroundColor = Color_white;
        let topBorder = CALayer();
        topBorder.frame = CGRect(x: 0.0, y: 0, width: scWidth, height: 1.0);
        topBorder.backgroundColor = Color_Line.cgColor;
        tabbar.layer.addSublayer(topBorder);
        
        addItem(target: FirstViewController(), title: "第一个", normalImg: "", selectedImg: "", type: .TABBAR_ITEM_FIRST);
        addItem(target: SecondViewController(), title: "第二个", normalImg: "", selectedImg: "", type: .TABBAR_ITEM_SECOND);
        addItem(target: ThirdViewController(), title: "第三个", normalImg: "", selectedImg: "", type: .TABBAR_ITEM_THIRD);
        addItem(target: ForthViewController(), title: "第四个", normalImg: "", selectedImg: "", type: .TABBAR_ITEM_FORTH);
        addItem(target: FifthViewController(), title: "第五个", normalImg: "", selectedImg: "", type: .TABBAR_ITEM_FIFTH);
        AppSingleton.sharedInstance.selecteTabbarItem(index: .TABBAR_ITEM_FIRST);
        
        
    }
    
    func addItem<T>(target: T, title: String, normalImg: String, selectedImg: String, type: TabbarItemType) {
      
        let tabbarItem = TabbarItem(title: title, normalColor: Tabbar_Normal_Color, selectedColor: Tabbar_Selected_Color, normalIMG: normalImg, selectedIMG: selectedImg, itemType: type);
        tabbar.addSubview(tabbarItem);
        tabbarItems.append(tabbarItem);
        
        tabbarItem.tabbarSelectedAction = {(type) in
            self.setSelectedItem(index: type)
        };
        self.addChildViewController(target as! UIViewController);
        setTabbarLayout();
        
    }
    
    func setTabbarLayout() {
        var lastItem: TabbarItem?
        for item in tabbarItems {
            item.snp.remakeConstraints({ (constraint) in
                if (lastItem == nil) {
                    constraint.left.equalToSuperview();
                } else {
                    constraint.left.equalTo(lastItem!.snp.right);
                    constraint.width.equalTo(lastItem!.snp.width);
                }
                constraint.top.equalToSuperview();
                constraint.bottom.equalToSuperview();
                if (item == tabbarItems.last) {
                    constraint.right.equalToSuperview();
                }
                
            })
            lastItem = item;
        }
    }
    
    func setSelectedItem(index: TabbarItemType) {
        
        if (self.currentSelectedItemType == index) {
            return;
        }
        self.currentSelectedItemType = index;
        
        for item in tabbarItems {
            item.itemCancelSelected()
        }
//        if ((self.currentShowVC) != nil) {
//            self.currentShowVC?.view .removeFromSuperview();
//        }
        
        switch index {
        case .TABBAR_ITEM_FIRST:
            tabbarItems[0].itemSelected();
            currentShowVC = self.childViewControllers[0];
            break;
        case .TABBAR_ITEM_SECOND:
            tabbarItems[1].itemSelected();
            currentShowVC = self.childViewControllers[1];
            break;
        case .TABBAR_ITEM_THIRD:
            tabbarItems[2].itemSelected();
            currentShowVC = self.childViewControllers[2];
            break;
        case .TABBAR_ITEM_FORTH:
            tabbarItems[3].itemSelected();
            currentShowVC = self.childViewControllers[3];
            break;
        case .TABBAR_ITEM_FIFTH:
            tabbarItems[4].itemSelected();
            currentShowVC = self.childViewControllers[4];
            break;
        case .CUSTOM:
            
            break;
        }
        
        self.view.addSubview((currentShowVC?.view)!);
        currentShowVC?.view.snp.updateConstraints({ (cons) in
            cons.left.equalToSuperview();
            cons.top.equalToSuperview();
            cons.right.equalToSuperview();
            if (index == .TABBAR_ITEM_FIRST) {
                cons.bottom.equalToSuperview();
            } else {
                cons.bottom.equalToSuperview().offset(-Tabbar_HEIGHT);
            }
        })
        self.view.bringSubview(toFront: tabbar)
    }
    
    
    func showTabbar() {
        tabbarShow = true;
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.tabbar.transform = .identity;
            if (self.currentSelectedItemType == .TABBAR_ITEM_FIRST) {
                
            } else {
               self.currentShowVC?.view.snp.updateConstraints({ (const) in
                    const.bottom.equalToSuperview().offset(-Tabbar_HEIGHT)
               })
            }
            self.tabbar.layoutIfNeeded()
            self.view.layoutIfNeeded();
        })
    }
    func hideTabbar() {
        tabbarShow = false;
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.tabbar.transform = CGAffineTransform(translationX: 0, y: Tabbar_HEIGHT)
            
            if (self.currentSelectedItemType == .TABBAR_ITEM_FIRST) {
                
            } else {
                self.currentShowVC?.view.snp.updateConstraints({ (const) in
                    const.bottom.equalToSuperview().offset(0)
                })
            }
            
            
            self.tabbar.layoutIfNeeded();
            self.view.layoutIfNeeded();
        })
    }
    var tabbarShow: Bool = true;
    func toggleTabbar() {
        if (tabbarShow == true) {
            hideTabbar();
        } else {
            showTabbar();
        }
    }
    
}
