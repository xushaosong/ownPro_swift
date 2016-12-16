//
//  MapUtil.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/1.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit


typealias Fail_searchResultBlock                = (Error) -> ()
typealias InputTip_searchResultBlock            = (Int, Array<AMapTip >) -> ()
typealias GeocodeCity_searchResultBlock         = (Int, Array<AMapGeocode>) -> ()
typealias ReGeocodeLocation_searchResultBlock   = (AMapReGeocode) -> ()
typealias POIKeyword_searchResultBlock          = (Int, AMapSuggestion, Array<AMapPOI>) -> ()
typealias POIAround_searchResultBlock           = (Int, AMapSuggestion, Array<AMapPOI>) -> ()

class MapUtil: NSObject, AMapSearchDelegate {

    static let sharedInstance = MapUtil();
    private override init(){
        super.init();
        self.mapSearchAPI.delegate = self;
    }
    
    let mapSearchAPI: AMapSearchAPI = AMapSearchAPI();
    
    // 关键字搜索请求
    func searchPOIKeyword(keyword: String, city: String?, limitCity: String?, success: @escaping POIKeyword_searchResultBlock, fail: @escaping Fail_searchResultBlock) {
        let mapserchKeywordRequest: POIKeywordsSearchRequest = POIKeywordsSearchRequest();
        mapserchKeywordRequest.successCallback = success;
        mapserchKeywordRequest.failCallback = fail;
        mapserchKeywordRequest.keywords = keyword;
        if (limitCity != nil) {
            mapserchKeywordRequest.city = limitCity;
        }
        
        mapserchKeywordRequest.sortrule = 1;
        mapserchKeywordRequest.requireExtension = true;
        mapserchKeywordRequest.requireSubPOIs = true;
        self.mapSearchAPI.aMapPOIKeywordsSearch(mapserchKeywordRequest);
    }
    
    // 周边搜索请求
    func searchPOIAround(keywords: String, location: AMapGeoPoint?, radius: NSInteger?, success: @escaping POIAround_searchResultBlock, fail:  @escaping Fail_searchResultBlock) {
        
        let mapSearchAroundRequest: POIAroundSearchRequest = POIAroundSearchRequest();
        mapSearchAroundRequest.successCallback = success;
        mapSearchAroundRequest.failCallback = fail;
        mapSearchAroundRequest.keywords = keywords;
        if (location != nil) {
            mapSearchAroundRequest.location = location;
        }
        if (radius != nil) {
            mapSearchAroundRequest.radius = radius!;
        }
        mapSearchAroundRequest.sortrule = 0;
        mapSearchAroundRequest.requireSubPOIs = true;
        mapSearchAroundRequest.requireExtension = true;
        self.mapSearchAPI.aMapPOIAroundSearch(mapSearchAroundRequest);
    }
    
    // 输入提示请求
    func searchInputTip(input: String, limitCity: String, success: @escaping InputTip_searchResultBlock, fail: @escaping Fail_searchResultBlock) {
        
        let mapSearchTipRequest: InputTipsSearchRequest = InputTipsSearchRequest();
        mapSearchTipRequest.successCallback = success;
        mapSearchTipRequest.failCallback = fail;
        mapSearchTipRequest.keywords = input;
        mapSearchTipRequest.city = limitCity;
        self.mapSearchAPI.aMapInputTipsSearch(mapSearchTipRequest);
    }
    
    // 地理编码请求
    func geocodeCity(city: String, address: String, success: @escaping GeocodeCity_searchResultBlock, fail: @escaping Fail_searchResultBlock) {
        let geocodeSearchRequest = GeocodeSearchRequest();
        geocodeSearchRequest.successCallback = success;
        geocodeSearchRequest.failCallback = fail;
        geocodeSearchRequest.city = city;
        geocodeSearchRequest.address = address;
        self.mapSearchAPI.aMapGeocodeSearch(geocodeSearchRequest);
    }
    
    // 地理反编码请求
    func reGoecodeLocation(location: CLLocationCoordinate2D, success: @escaping ReGeocodeLocation_searchResultBlock, fail: @escaping Fail_searchResultBlock) {
        
        
        
        let regoecodeRequest = ReGeocodeSearchRequest();
        regoecodeRequest.successCallback = success;
        regoecodeRequest.failCallback = fail;
        regoecodeRequest.location = AMapGeoPoint.location(withLatitude: CGFloat(location.latitude), longitude: CGFloat(location.longitude));
        regoecodeRequest.requireExtension = true;
        self.mapSearchAPI.aMapReGoecodeSearch(regoecodeRequest);
    }
    
    // 代理-----------------
    // 关键字搜索POSkeyword \ 周边搜索 代理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        print(response.formattedDescription());
        
        if (request.isKind(of: POIKeywordsSearchRequest.classForCoder())) {
            let poiRequest: POIKeywordsSearchRequest = request as! POIKeywordsSearchRequest;
            if (poiRequest.successCallback != nil) {
                poiRequest.successCallback!(response.count, response.suggestion, response.pois);
            }
            
        }else if (request.isKind(of: POIAroundSearchRequest.classForCoder())) {
            let poiAroundRequest: POIAroundSearchRequest = request as! POIAroundSearchRequest;
            if (poiAroundRequest.successCallback != nil) {
                poiAroundRequest.successCallback!(response.count, response.suggestion, response.pois);
            }
        }
    }
    // 输入提示代理
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        print(response.formattedDescription());
        let inputTipsRequest: InputTipsSearchRequest = request as! InputTipsSearchRequest;
        if (inputTipsRequest.successCallback != nil) {
            inputTipsRequest.successCallback!(response.count, response.tips);
        }
    }
 
    // 地理编码代理
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        
        let geocodeRequest: GeocodeSearchRequest = request as! GeocodeSearchRequest;
        if (geocodeRequest.successCallback != nil) {
            geocodeRequest.successCallback!(response.count, response.geocodes);
        }
    }
    // 地理反编码代理代理
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        let reGeocodeRequest: ReGeocodeSearchRequest = request as! ReGeocodeSearchRequest;
        if (reGeocodeRequest.successCallback != nil) {
            reGeocodeRequest.successCallback!(response.regeocode);
        }
    }
    
    
    
    // 搜索错误时代理
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        if (request != nil) {
            let request: AMapSearchObject = request as! AMapSearchObject;
            
            
            if (request.isKind(of: POIKeywordsSearchRequest.classForCoder())) {
                let req = request as! POIKeywordsSearchRequest;
                req.failCallback!(error);
            } else if (request.isKind(of: POIAroundSearchRequest.classForCoder())) {
                let req = request as! POIAroundSearchRequest;
                req.failCallback!(error);
            } else if (request.isKind(of: InputTipsSearchRequest.classForCoder())) {
                let req = request as! InputTipsSearchRequest;
                req.failCallback!(error);
            } else if (request.isKind(of: GeocodeSearchRequest.classForCoder())) {
                let req = request as! GeocodeSearchRequest;
                req.failCallback!(error);
            } else if (request.isKind(of: ReGeocodeSearchRequest.classForCoder())) {
                let req = request as! ReGeocodeSearchRequest;
                req.failCallback!(error);
            }
            
        }
    }
    
    
    
    // ----------- 工具
    func calculateTwoLocationDistance(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
//        根据用户指定的两个经纬度坐标点，计算这两个点间的直线距离，单位为米
        
        let p1: MAMapPoint = MAMapPointForCoordinate(point1);
        let p2: MAMapPoint = MAMapPointForCoordinate(point2);
        let distance: CLLocationDistance = MAMetersBetweenMapPoints(p1, p2);
        return distance;
    }
}
