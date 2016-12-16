//
//  SearchResultViewController.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/11.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController, MAMapViewDelegate {

    
    let mapView: MAMapView = MAMapView();;
    let searchView: SearchView = SearchView();
    var dataArray = [AMapPOI]();
    var currentSelected: CustomAnnotationView?;
    let detailView: ShowDetailView = ShowDetailView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigatorBar.isHidden = true;
        
        self.view.addSubview(self.mapView);
        self.mapView.snp.makeConstraints { (constraint) in
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.bottom.equalToSuperview();
            constraint.top.equalToSuperview();
        }
        mapView.delegate = self;
        mapView.showsUserLocation = true;
        mapView.userTrackingMode = .follow;
        mapView.setCenter((AppSingleton.sharedInstance.userLocation?.maUserLocation?.location.coordinate)!, animated: true);
        
        searchView.iconButton .setImage(ToolModule.getImagePath(imageName: "navi/back.png"), for: .normal);
        searchView.iconButton.setImage(ToolModule.getImagePath(imageName: "navi/back_h  .png"), for: .highlighted);
        searchView.iconButton.backgroundColor = UIColor.clear;
        searchView.iconTouchAction = {() in
            self.navigationController?.popViewController(animated: true);
        };
        self.view.addSubview(searchView);
        searchView.snp.makeConstraints { (constraint) in
            constraint.top.equalToSuperview().inset(30);
            constraint.left.equalToSuperview().inset(20);
            constraint.right.equalToSuperview().inset(20);
            constraint.height.equalTo(45);
        }
        
        self.view.addSubview(detailView);

//        detailView.frame = CGRect(x: 0, y: scHeight - 320, width: scWidth, height: scHeight - NavigationBar_HEIGHT);
        detailView.snp.makeConstraints { (constraint) in
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.top.equalTo(scHeight - 320);
        }
        detailView.moveActionCallback = {(distance) in
//            self.detailView.frame = CGRect(x: 0, y: scHeight - 320 - distance, width: scWidth, height: scHeight - NavigationBar_HEIGHT);
            self.detailView.transform = CGAffineTransform(translationX: 0, y: scHeight - 320 - distance);
        };
        detailView.moveActionEndCallback = {() in
            
        };
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
//        delay(time: 5, complete: {() in
            var points = [MAPointAnnotation]();
            
            for poi: AMapPOI in self.dataArray {
                let point: MAPointAnnotation = MAPointAnnotation();
                point.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(poi.location.latitude), CLLocationDegrees(poi.location.longitude));
                point.title = poi.name;
                point.subtitle = poi.address;
                points.append(point);
            }
            self.mapView.addAnnotations(points);
//        delay(time: 3, complete: {() in
        self.mapView.showAnnotations(self.mapView.annotations, edgePadding: UIEdgeInsetsMake(10, 10, 10, 10), animated: true);
    }
    let kArrorHeight: CGFloat = 10;
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if (annotation.isKind(of: MAPointAnnotation.classForCoder())) {
            var annoView = mapView.dequeueReusableAnnotationView(withIdentifier: "anno");
            if (annoView == nil) {
                annoView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "anno");
            }
            let view = annoView as! CustomAnnotationView;
            view.canShowCallout = false;
            view.isDraggable = true;
            view.image = ToolModule.getImagePath(imageName: "map/default_groupbuying_number.png");
            let center = view.center;
            
            return annoView;
        }
        return nil;
    }
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        if (currentSelected != nil) {
            
            mapView.deselectAnnotation(currentSelected?.annotation, animated: true)
            currentSelected?.image = ToolModule.getImagePath(imageName: "map/default_groupbuying_number.png")
        }
        self.mapView.setCenter(view.annotation.coordinate, animated: true);
        view.image = ToolModule.getImagePath(imageName: "map/mapPicker_poi_icon.png");
        currentSelected = view as! CustomAnnotationView?;
        view.centerOffset = CGPoint(x: 0, y: -18);
    }
}
