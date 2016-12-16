//
//  CustomAnnotationView.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/12.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

let kCalloutWidth = 200.0;
let kCalloutHeight = 70.0;

class CustomAnnotationView: MAAnnotationView {

    var calloutView: CustomCalloutView?;
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        0x151950870
//        0x151914120
        if (self.isSelected == selected) {
            return;
        }
        if (selected) {
            if (self.calloutView == nil) {
                self.calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: kCalloutWidth, height: kCalloutHeight));
                
                self.calloutView?.center = CGPoint(x: self.bounds.width / 2 + self.calloutOffset.x, y: self.calloutOffset.y - (self.calloutView?.bounds.height)! / 2);
            }
            self.calloutView?.iconImageString = "default_account_main_qqbtnicon.png";
            self.calloutView?.title = self.annotation.title;
            self.calloutView?.subTitle = self.annotation.subtitle;
            
            self.addSubview(self.calloutView!);
            self.calloutView?.alpha = 0;
            UIView.animate(withDuration: 0.25, animations: { 
                self.calloutView?.alpha = 1;
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: { 
                self.calloutView?.alpha = 0;
            }, completion: { (comp) in
                self.calloutView?.removeFromSuperview();
            })
            
        }
        super.setSelected(selected, animated: animated);
    }
    
}
