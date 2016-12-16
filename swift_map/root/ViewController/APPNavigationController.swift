//
//  APPNavigationController.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/10.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class APPNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count >= 1) {
            viewController.navigationItem.leftBarButtonItem = createBackItem();
        }
        super.pushViewController(viewController, animated: animated);
    }

    func createBackItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom);
        button.setImage(ToolModule.getImagePath(imageName: "navi/back.png"), for: .normal);
        button.setImage(ToolModule.getImagePath(imageName: "navi/back_h.png"), for: .highlighted);
        button.addTarget(self, action: #selector(APPNavigationController.pop), for: .touchUpInside);
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 40);
        let backItem = UIBarButtonItem(customView: button);
        return backItem;
        
    }
    func pop() {
        self.popViewController(animated: true)
    }
}
