//
//  BackAnimateOpacity.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/1.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class BackAnimateOpacity: NSObject, UIViewControllerAnimatedTransitioning {

    var transitionContext: UIViewControllerContextTransitioning? = nil;
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext;
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from);
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to);
        
        let contView = transitionContext.containerView;
        
        
        contView.addSubview((toVC?.view)!);
        contView.addSubview((fromVC?.view)!);
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromVC?.view.alpha = 0;
            
        }, completion: {(complete) in
            self.transitionContext?.completeTransition(true);
            
        });
    }
    
}
