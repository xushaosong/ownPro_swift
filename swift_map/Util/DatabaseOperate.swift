//
//  DatabaseOperate.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/11.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit
import CoreData
class DatabaseOperate: NSObject {

    static let sharedInstance = DatabaseOperate();
    private override init(){}
    
    class func data(data: Any?) -> String {
        if (data == nil) {
            return ""
        } else {
            return data as! String;
        }
    }
    
    ///------ 搜索历史
    // 查询数据
    class func querySearchData(predicate: NSPredicate?) -> (queryOrigi: Array<InputTipResult>?, queryConvert: Array<AMapTip>?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "InputTipResult");
        var results = [AMapTip]();
        if (predicate != nil) {
            fetchRequest.predicate = predicate;
        }
        do {
            let res = try appDelegate.cdh.managedObjectContext?.fetch(fetchRequest);
            print("结果：\(res?.count)")
            for result in (res as! [InputTipResult]) {
                let tip: AMapTip = AMapTip();
                tip.adcode = result.adcode;
                tip.address = result.address;
                tip.district = result.district;
                tip.location = result.location as! AMapGeoPoint!;
                tip.name = result.name;
                tip.uid = result.uid;
                results.append(tip);
            }
            return (res as! Array<InputTipResult>, results);
        } catch {
            print("搜索历史\\插入数据:query-error");
            return ([], [])
        }
        
    }
    // 插入数据
    class func insertSearchData(dict: Dictionary<String, Any>) -> Bool {
        
        if (!deleteSearchData(name: dict["name"] as! String)) {
            return false;
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let entr = NSEntityDescription.insertNewObject(forEntityName: "InputTipResult", into: appDelegate.cdh.managedObjectContext!) as! InputTipResult;
        entr.district = data(data: dict["district"]);
        entr.uid = data(data: dict["uid"]);
        entr.address = data(data: dict["address"]);
        entr.name = data(data: dict["name"]);
        entr.location = dict["location"] as! NSObject?;
        entr.adcode = data(data: dict["adcode"]);

        do {
            try appDelegate.cdh.managedObjectContext?.save()
            print("搜索历史\\插入数据:save-success")
            return true;
        } catch {
            print("搜索历史\\插入数据:save-error")
            return false;
        }
    }
    // 删除数据
    class func deleteSearchData(name: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        
        let pre = NSPredicate(format: "name = %@", name);
        let querys = querySearchData(predicate: pre).queryOrigi;
        if (querys?.count == 0) {
            return true;
        }
        for query in querys! {
            appDelegate.cdh.managedObjectContext?.delete(query);
        }
        do {
            try appDelegate.cdh.managedObjectContext?.save()
            print("搜索历史\\删除数据:delete-success");
            return true;
        } catch {
            print("搜索历史\\删除数据:delete-error");
            return false;
        }
    }
}
