//
//  POIAroundSearchRequest.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/2.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class POIAroundSearchRequest: AMapPOIAroundSearchRequest {
    
    var successCallback: POIAround_searchResultBlock?;
    var failCallback: Fail_searchResultBlock?;
    
}
