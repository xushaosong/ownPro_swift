//
//  SearchAddrViewController.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/29.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class SearchAddrViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate {

    var tableView: UITableView!;
    var searchView: SearchAddrTextFieldView!;
    
    var searchResult: Array<SearchAddrResultFrame>?;
    var searchHistory: Array<Any>?;
    var tableViewHeaderView: SearchHeadView?;
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?;
    
    // 手势返回
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (animationController.isKind(of: RootViewController.classForCoder())) {
            return self.interactiveTransition;
        }
        return nil;
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (operation == .pop && toVC.isKind(of: RootViewController.classForCoder())) {
            return BackAnimateOpacity();
        } else {
            return nil;
        }
    }
    
    func handlePan(pangesture: UIPanGestureRecognizer) {
        if (pangesture.translation(in: self.view).x >= 0) {
            var per = pangesture.translation(in: self.view).x / scWidth;
            per = min(1.0, (max(0.0, per)));
            if (pangesture.state == .began) {
                self.interactiveTransition = UIPercentDrivenInteractiveTransition();
                self.navigationController?.popViewController(animated: true);
            } else if (pangesture.state == .changed) {
                if (pangesture.translation(in: self.view).x == 0) {
                    self.interactiveTransition?.update(0.01);
                } else {
                    self.interactiveTransition?.update(per);
                }
            } else if (pangesture.state == .ended || pangesture.state == .cancelled) {
                if (pangesture.translation(in: self.view).x == 0) {
                    self.interactiveTransition?.cancel();
                    self.interactiveTransition = nil;
                } else if (per > 0.5) {
                    self.interactiveTransition?.finish();
                    
                } else {
                    self.interactiveTransition?.cancel();
                }
                self.interactiveTransition = nil;
            }
        }
    }
   
    // 系统初始
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.navigationController?.delegate = self;
        searchView.searchTextField.becomeFirstResponder();
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        self.navigationController?.delegate = AppSingleton.sharedInstance.rootVC;
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigatorBar.backgroundColor = Color_Navigator_Gray;
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(pangesture:)));
        self.view.addGestureRecognizer(gestureRecognizer);
        
        self.tableView = UITableView(frame: CGRect.zero, style: .plain);
        self.view.addSubview(self.tableView);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = Color_f4f4f4;
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        tableView.snp.makeConstraints { (constraint) in
            constraint.top.equalTo(self.navigatorBar.snp.bottom).offset(0);
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.bottom.equalToSuperview();
        };
        self.tableView.register(SearchAddrResultCell.classForCoder(), forCellReuseIdentifier: "cell");
        self.view.addSubview(self.tableView);
        self.tableView.tableFooterView = UIView();
        
        tableViewHeaderView = SearchHeadView();
        tableViewHeaderView?.itemClick = { (index, title) in
            print(index);
            print(title);
            if (index != 6 && index != 7) {
                self.clickItem(name: title);
            } else if (index == 7) {
                let cate = SearchCategoryViewController();
                cate.categoryItemCallback = { (itemTitle) in
                    self.clickItem(name: itemTitle);
                };
                self.navigationController?.pushViewController(cate, animated: true);
            }
        };
        
        self.tableView.contentInset = UIEdgeInsets(top: (tableViewHeaderView?.selfHeight)! + 10, left: 0, bottom: 0, right: 0);
        tableViewHeaderView?.frame = CGRect(x: 0, y: -((tableViewHeaderView?.selfHeight)! + 10), width: scWidth, height: (tableViewHeaderView?.selfHeight)!)
        self.tableView.addSubview(tableViewHeaderView!);
        
        searchView = SearchAddrTextFieldView(frame: CGRect(x: 0, y: 0, width: scWidth - 70, height: 33), needSearchButton: true);
        searchView.searchTextField.setLeftViewWithImageName(imageName: "search/search_sign", mode: .always);
        searchView.searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchView.searchTextField.returnKeyType = .search;
        searchView.searchTextField.delegate = self;
        searchView.searchBlock = { 
            self.beginSearch(name: self.searchView.searchTextField.text!);
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notice:)), name: .UITextFieldTextDidChange, object: searchView.searchTextField)
        self.navigatorBar.navigatorBarMain = .NavigatorBar_Right;
        self.navigatorBar.addRightContent(childView: searchView);
        
        data(tips: (DatabaseOperate.querySearchData(predicate: nil).queryConvert!).reversed());
        
    }
    
    // tableView代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResult == nil ? 0 : self.searchResult!.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchAddrResultCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchAddrResultCell;
        cell.data = self.searchResult?[indexPath.row];
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let searchResultFrame: SearchAddrResultFrame = self.searchResult![indexPath.row];
        return searchResultFrame.searchResultCellHeight;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        let tipFrame: SearchAddrResultFrame = self.searchResult![indexPath.row];
        let dict = [
            "district" : tipFrame.tip?.district,
            "uid" : tipFrame.tip?.uid,
            "address" : tipFrame.tip?.address,
            "name" : tipFrame.tip?.name,
//            "location": tipFrame.tip?.location,
            "adcode": tipFrame.tip?.adcode
        ] as [String : Any];
        if (DatabaseOperate.insertSearchData(dict: dict)) {
            self.beginSearch(name: (tipFrame.tip?.name)!);
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchView.searchTextField.resignFirstResponder();
    }
    // textfield代理
    func textFieldDidChange(notice: NSNotification) {
       
        
        if (searchView.searchTextField.text != nil && searchView.searchTextField.text != "") {
            searchView.showSearchButton();
            UIView.animate(withDuration: 0.25, animations: { 
                self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0);
            }, completion: { (complete) in
                self.tableViewHeaderView?.isHidden = true;
            })
        } else {
            searchView.hideSearchButton();
            self.tableViewHeaderView?.isHidden = false;
            UIView.animate(withDuration: 0.25, animations: {
                self.tableView.contentInset = UIEdgeInsets(top: (self.tableViewHeaderView?.selfHeight)! + 10, left: 0, bottom: 0, right: 0);
            });
        }
        
        DispatchQueue(label: "dispatch").async {

            let pre = NSPredicate(format: "name CONTAINS %@", self.searchView.searchTextField.text!)
            let tipHistory = (DatabaseOperate.querySearchData(predicate: pre).queryConvert)?.reversed();
            MapUtil.sharedInstance.searchInputTip(input: self.searchView.searchTextField.text!, limitCity: (AppSingleton.sharedInstance.userLocation?.reGeoCodeData?.addressComponent.citycode)!, success: { (count, tips: Array<AMapTip>) in
                var tipsArr = Array(tips);
                
                for tipH in tipHistory! {
                    var isHas = false;
                    for tipN in tipsArr {
                        if (tipN.name == tipH.name) {
                            isHas = true;
                        }
                    }
                    if (!isHas) {
                        tipsArr.insert(tipH, at: 0);
                    }
                }
                self.data(tips: tipsArr);
                
            }, fail: { (error) in
                DispatchQueue.main.async(execute: {
                    print("error: SearchAddrViewController-textFieldDidChange:\(error.localizedDescription)")
                });
            });
        };
    }
    func data(tips: Array<AMapTip>) {
        if (data == nil) {
            return;
        }
        
        self.searchResult = Array();
        for tip in tips {
            let searchResultFrame = SearchAddrResultFrame();
            searchResultFrame.tip = tip;
            searchResultFrame.searchText = self.searchView.searchTextField.text;
            self.searchResult?.append(searchResultFrame);
        }
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData();
        });
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.clickItem(name: textField.text!)
        return true;
    }
    
    func clickItem(name: String) {
        let dict = [
            "district" : "",
            "uid" : "",
            "address" : "",
            "name" : name,
            //            "location": tipFrame.tip?.location,
            "adcode": ""
            ] as [String : Any];
        if (DatabaseOperate.insertSearchData(dict: dict)) {
            self.searchArroud(name: name);
        }
    }
    func cancel() {
        
    }
    func beginSearch(name: String) {
        
        ActionHUD.showHUD(withAnimate: true, closeBack: {() in
            MapUtil.sharedInstance.mapSearchAPI.cancelAllRequests();
        });
        
        MapUtil.sharedInstance.searchPOIKeyword(keyword: name, city: "", limitCity: nil, success: { (count, suggestion, pois: Array<AMapPOI>) in
            if (pois.count == 0) {
                self.searchArroud(name: name);
            } else {
                ActionHUD.hideHUD();
                if (count > 0) {
                    let detail = SearchResultViewController();
                    detail.dataArray = pois;
                    self.navigationController?.pushViewController(detail, animated: true);
                }
            }
            
        }, fail: {(error) -> () in
            ActionHUD.hideHUD();
        });
    }
    func searchArroud(name: String) {
        
        ActionHUD.showHUD(withAnimate: true, closeBack: {() in
            MapUtil.sharedInstance.mapSearchAPI.cancelAllRequests();
        });
        
        
        let point = AMapGeoPoint.location(
            withLatitude: CGFloat((AppSingleton.sharedInstance.userLocation?.maUserLocation?.location.coordinate.latitude)!),
            longitude: CGFloat((AppSingleton.sharedInstance.userLocation?.maUserLocation?.location.coordinate.longitude)!));
        
        MapUtil.sharedInstance.searchPOIAround(keywords: name, location: point, radius: 10000, success: {(count, suggestion, pois: Array<AMapPOI>) in
            ActionHUD.hideHUD();
            if (count > 0) {
                let detail = SearchResultViewController();
                detail.dataArray = pois;
                self.navigationController?.pushViewController(detail, animated: true);
            } else {
                print("未搜索到结果");
            }
        }, fail: {(error) in
            ActionHUD.hideHUD();
        });
    }
}
