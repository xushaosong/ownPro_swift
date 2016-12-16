//
//  FirstViewController.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/23.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//



import UIKit

class FirstViewController: BaseViewController, MAMapViewDelegate, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {

    var search: AMapSearchAPI!
    var mapView: MAMapView!
    let searchView = SearchView(frame: .zero);
  
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if(operation == .push && toVC.isKind(of: SearchAddrViewController.classForCoder()))
        {
            return self;
        }
        else
        {
            return nil;
        }
        
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8;
    }
    var transitionContext: UIViewControllerContextTransitioning?;
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext;
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from);
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to);
        
        let contView = transitionContext.containerView;
        
        
        contView.addSubview((fromVC?.view)!);
        contView.addSubview((toVC?.view)!);
        
        toVC?.view.alpha = 0;
        UIView.animate(withDuration: 0.25, animations: {
            toVC?.view.alpha = 1;
        }, completion: {(complete) in
            self.transitionContext?.completeTransition(true);
            self.transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil;
            self.transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil;
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.navigationController?.delegate = self;
        mapView.delegate = self;
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow;
        mapView.isShowsLabels = true;
        mapView.isShowTraffic = true;
        mapView.isShowsBuildings = true;
        mapView.showsCompass = false; // 设置成NO表示关闭指南针；YES表示显示指南针
        mapView.isRotateCameraEnabled = false;
        
        mapView.distanceFilter = 100;
        mapView.headingFilter = 360;
        self.mapView.isShowTraffic = false;
        mapView.showsScale = true;
        mapView.scaleOrigin = CGPoint(x: 60, y: scHeight - Tabbar_HEIGHT - 40);
        mapView.logoCenter = CGPoint(x: scWidth - 35, y: scHeight - Tabbar_HEIGHT - 15);
        
//        delay(time: 2, complete: {() -> Void in
//            AppSingleton.sharedInstance.rootVC.hideTabbar()
//        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        self.navigationController?.delegate = AppSingleton.sharedInstance.rootVC;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigatorBar.isHidden = true;
        initMapView();
    }

    func initMapView() {
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView!)
        
        // 搜索框
        self.view.addSubview(searchView);
        searchView.snp.makeConstraints { (const) in
            const.top.equalToSuperview().inset(30);
            const.left.equalToSuperview().inset(20);
            const.right.equalToSuperview().inset(20);
            const.height.equalTo(45);
        }
        searchView.searchAction = {() in
            
            let searchAddr = SearchAddrViewController();
            AppSingleton.sharedInstance.rootNAVC?.pushViewController(searchAddr, animated: true);
        };
        searchView.backgroundColor = Color_white;
        
        // 回到“我的”位置
        let returnMyLocation = UIButton(type: .custom);
        returnMyLocation.setBackgroundImage(ToolModule.getImagePath(imageName: "map/returnDes.png"), for: .normal);
        returnMyLocation.setImage(ToolModule.getImagePath(imageName: "map/des.png"), for: .normal);
        self.view.addSubview(returnMyLocation);
        returnMyLocation.addTarget(self, action: #selector(FirstViewController.returnMyLocation), for: .touchUpInside);
        returnMyLocation.snp.makeConstraints { (const) in
            const.left.equalToSuperview().offset(10);
            const.bottom.equalTo(self.view.snp.bottom).inset(Tabbar_HEIGHT + 20);
            const.width.equalTo(40);
            const.height.equalTo(40);
        }
        
        // 路况开关按钮
        let trafficButton = TabbarItem(title: nil, normalColor: nil, selectedColor: nil, normalIMG: "map/default_newmain_traffic_normal.png", selectedIMG: "map/default_newmain_traffic_highlighted.png", itemType: .CUSTOM);
        trafficButton.titleLable?.font = UIFont.systemFont(ofSize: 12);
        trafficButton.backgroundColor = Color_white;
        trafficButton.itmeClickAction = {(item) in
            self.toggleTrafficAction(item: item);
        }
        self.view.addSubview(trafficButton);
        trafficButton.snp.makeConstraints { (constraint) in
            constraint.top.equalTo(self.searchView.snp.bottom).offset(20);
            constraint.right.equalToSuperview().inset(20);
            constraint.width.equalTo(40);
            constraint.height.equalTo(40);
        }
    }
    
    // 开启、关闭路况
    func toggleTrafficAction(item: TabbarItem) {
        if (self.mapView.isShowTraffic) {
            self.mapView.isShowTraffic = false;
            item.itemCancelSelected();
        } else {
            self.mapView.isShowTraffic = true;
            item.itemSelected();
        }
    }
    
    func returnMyLocation() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true);
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        print("定位成功");
        MapUtil.sharedInstance.reGoecodeLocation(location: userLocation.coordinate, success: { (result: AMapReGeocode) in
            AppSingleton.sharedInstance.userLocation = AppUserLocation();
            AppSingleton.sharedInstance.userLocation?.maUserLocation = userLocation;
            AppSingleton.sharedInstance.userLocation?.reGeoCodeData = result;
            AppSingleton.sharedInstance.userLocation?.userCurrentCity = result.addressComponent.city == "" ? result.addressComponent.province : result.addressComponent.city;
            
            return;
            
            print("----------------")
            print("formattedAddress:\(result.formattedAddress)");
            print("----------------")
            
            print("province:\(result.addressComponent.province)");
            print("city:\(result.addressComponent.city)");
            print("district:\(result.addressComponent.district)");
            print("township:\(result.addressComponent.township)");
            print("building:\(result.addressComponent.building)");
            print("street:\(result.addressComponent.streetNumber.street)");
            print("number:\(result.addressComponent.streetNumber.number)");
            print("商圈列表--------------");
            for business in result.addressComponent.businessAreas {
                print("business:\(business.name)");
            }
            print("道路信息--------------")
            for road in result.roads {
                print("road:\(road.name)");
            }
            print("道路路口信息--------------")
            for roadinter in result.roadinters {
                print("firstName:\(roadinter.firstName), secondName:\(roadinter.secondName)");
            }
            print("兴趣点信息--------------")
            for poi in result.pois {
                print("name:\(poi.name), address:\(poi.address)");
            }
            print("兴趣区域信息--------------")
            for aoi in result.aois {
                print("name:\(aoi.name)");
            }
            
        }, fail: { (error) in
            print("定位失败：\(error.localizedDescription)")
        })
    }
    // 地图代理
    func mapViewDidStopLocatingUser(_ mapView: MAMapView!) {

        
    }
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
        print("定位失败：\(error.localizedDescription)");
    }
    
}
