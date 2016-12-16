//
//  ActionHUD.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/11.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

typealias CloseActionBlock = () -> ()
var currentHUD: ActionHUD?;

class ActionHUD: UIView {

    var showActivityIndicator: Bool = true {
        didSet {
            updateFrame();
        }
    };
    var text: String = "正在搜索..." {
        didSet {
            self.textLabel.text = text;
            updateFrame();
        }
    };
    var contentText: String = ""{
        didSet {
            self.activityIndicatorContent.setTitle(contentText, for: .normal);
            updateFrame();
        }
    };
    var contentImage: String = "search/ufo_search_icon.png"{
        didSet {
            self.activityIndicatorContent.setImage(ToolModule.getImagePath(imageName: contentImage), for: .normal)
            updateFrame();
        }
    };
    var actionButtonText: String = ""{
        didSet {
            self.actionButton.setTitle(actionButtonText, for: .normal);
            updateFrame();
        }
    };
    var actionButtonImg: String = "search/actionHUD/close_normal.png"{
        didSet {
            self.actionButton.setImage(ToolModule.getImagePath(imageName: actionButtonImg), for: .normal);
            updateFrame();
        }
    };
    var bgMode: ActionHUD_BgMode = .Gray {
        didSet {
            updateFrame();
        }
    };
    
    private var closeCallback: CloseActionBlock?;
    private var activityIndicator: UIImageView = UIImageView();
    private var activityIndicatorContent: UIButton = UIButton(type: .custom);
    private var textLabel: UILabel = UILabel();
    private var line: UIView = UIView();
    private var actionButton: UIButton = UIButton(type: .custom);
    private var bgView: UIView = UIView();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = Color_white;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
        self.center = (UIApplication.shared.keyWindow?.center)!;
        self.bgView.frame = CGRect(x: 0, y: 0, width: scWidth, height: scHeight);
        UIApplication.shared.keyWindow?.addSubview(self.bgView);
        self.bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
        UIApplication.shared.keyWindow?.addSubview(self);
        
        self.addSubview(self.activityIndicatorContent);
        self.addSubview(self.activityIndicator);
        self.addSubview(self.textLabel);
        self.addSubview(self.line);
        self.addSubview(self.actionButton);
        
        self.line.backgroundColor = Color_Line;
        self.activityIndicator.image = ToolModule.getImagePath(imageName: "search/actionHUD/default_radiocamera_main_radarcross.png");
        self.textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.textLabel.textColor = Color_black;
        
        self.actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        
        self.actionButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside);
        self.textLabel.text = text;
        self.activityIndicatorContent.setImage(ToolModule.getImagePath(imageName: contentImage), for: .normal)
        self.actionButton.setTitle(actionButtonText, for: .normal);
        self.actionButton.setImage(ToolModule.getImagePath(imageName: actionButtonImg), for: .normal);
        updateFrame()
    }
    
    let activityIndicatorWidth: CGFloat = 25;
    func updateFrame() {
        var lastView: UIView?;
        var width: CGFloat = 0;
        
        if (self.showActivityIndicator) {
            self.activityIndicatorContent.isHidden = false;
            self.activityIndicator.isHidden = false;
            lastView = self.activityIndicator;
            self.activityIndicator.snp.remakeConstraints({ (constraint) in
                constraint.left.equalTo(10);
                constraint.centerY.equalToSuperview();
                constraint.height.equalTo(activityIndicatorWidth);
                constraint.width.equalTo(activityIndicatorWidth);
            });
            self.activityIndicatorContent.snp.remakeConstraints({ (constraint) in
                constraint.left.equalTo(self.activityIndicator.snp.left).inset(7);
                constraint.bottom.equalTo(self.activityIndicator.snp.bottom).inset(7)
                constraint.top.equalTo(self.activityIndicator.snp.top).inset(7)
                constraint.right.equalTo(self.activityIndicator.snp.right).inset(7);
            });
            width += activityIndicatorWidth + 10;
        } else {
            self.activityIndicatorContent.isHidden = true;
            self.activityIndicator.isHidden = true;
        }
        if (self.text != "") {
            self.textLabel.isHidden = false;
            
            let size = ToolModule.getString(stringName: self.text as NSString, font: UIFont.boldSystemFont(ofSize: 16), maxSize: CGSize(width: 1000, height: 15));
            self.textLabel.snp.remakeConstraints({ (constraints) in
                if (lastView == nil) {
                    constraints.left.equalToSuperview().inset(10);
                    constraints.top.equalToSuperview().inset(10);
                    constraints.bottom.equalToSuperview().inset(10);
//                    constraints.height.equalTo(size.height);
                    
                } else {
                    constraints.left.equalTo((lastView?.snp.right)!).offset(10);
                    constraints.centerY.equalTo((lastView?.snp.centerY)!);
                    constraints.width.equalTo(size.width);
                    constraints.top.equalToSuperview().inset(10);
                    constraints.bottom.equalToSuperview().inset(10);
                }
            });
            lastView = self.textLabel;
            width += size.width + 10;
        } else {
            self.textLabel.isHidden = true;
        }
        if (lastView == nil) {
            self.line.isHidden = true;
        } else {
            self.line.isHidden = false;
            self.line.snp.remakeConstraints { (constriant) in
                constriant.left.equalTo((lastView?.snp.right)!).offset(10);
                constriant.width.equalTo(1);
                constriant.height.equalTo(20);
                constriant.centerY.equalToSuperview();
            }
            width += 10 + 1;
            lastView = line;
        }
        if (self.actionButtonImg == "" && self.actionButtonText == "") {
            self.actionButton.isHidden = true;
        } else {
            self.actionButton.isHidden = false;
            
            
            if (self.actionButtonText == "") {
                self.actionButton.snp.remakeConstraints({ (constraint) in
                    if (lastView != nil) {
                        constraint.left.equalTo((lastView?.snp.right)!)
                        constraint.bottom.equalToSuperview();
                        constraint.top.equalToSuperview();
                        constraint.right.equalToSuperview();
                        constraint.width.equalTo(40);
                    } else {
//                        constraint.width.equalTo(20);
//                        constraint.height.equalTo(20);
                        constraint.left.equalToSuperview();
                        constraint.bottom.equalToSuperview();
                        constraint.top.equalToSuperview();
                        constraint.right.equalToSuperview();
                    }
                    
                })
                width += 40;
            } else {
                let size = ToolModule.getString(stringName: self.actionButtonText as NSString, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000, height: 15));
                self.actionButton.snp.remakeConstraints({ (constraint) in
                    if (lastView != nil) {
                        constraint.left.equalTo((lastView?.snp.right)!)
                        constraint.bottom.equalToSuperview();
                        constraint.top.equalToSuperview();
                        constraint.right.equalToSuperview();
                        constraint.width.equalTo(size.width + 10);
                    } else {
                        constraint.width.equalTo(size.width + 10);
                        constraint.height.equalTo(20);
                        constraint.left.equalToSuperview();
                        constraint.bottom.equalToSuperview();
                        constraint.top.equalToSuperview();
                        constraint.right.equalToSuperview();
                    }
                });
                width += size.width;
            }
        }
        
        self.snp.remakeConstraints { (constraint) in
            constraint.width.equalTo(width);
            constraint.height.equalTo(50);
            constraint.centerX.equalToSuperview();
            constraint.centerY.equalToSuperview();
        }
    }
    
    class func showHUD(withAnimate: Bool, closeAfter time: TimeInterval, closeBack: CloseActionBlock?) {
        
        
        ActionHUD.showHUD(withAnimate: withAnimate, closeBack: closeBack);

        delay(time: time, complete: {() in
            currentHUD?.closeAction();
        });
    }
    class func showHUD(withAnimate: Bool, closeBack: CloseActionBlock?) {
        if (currentHUD != nil) {
            return;
        }
        let hud = ActionHUD();
        currentHUD = hud;
        hud.closeCallback = closeBack;
        if (withAnimate) {
            hud.alpha = 0;
            hud.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
            
            UIView.animate(withDuration: 0.25, animations: { 
                hud.alpha = 1;
                hud.transform = CGAffineTransform.identity;
                hud.bgView.backgroundColor = hud.bgMode == .Clear ? UIColor(red: 0, green: 0, blue: 0, alpha: 0) : UIColor(red: 0, green: 0, blue: 0, alpha: 0.5);
            }, completion: { (complete) in
                hud.animate();
            });
        } else {
            hud.bgView.backgroundColor = hud.bgMode == .Clear ? UIColor(red: 0, green: 0, blue: 0, alpha: 0) : UIColor(red: 0, green: 0, blue: 0, alpha: 0.5);
        }
    }
    
    private func animate() {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z");
        rotationAnimation.toValue = NSNumber(value: M_PI * 2.0);
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear);
        rotationAnimation.duration = 1.5;
        rotationAnimation.repeatCount = 10000;
        rotationAnimation.isCumulative = false;
        rotationAnimation.isRemovedOnCompletion = false;
        rotationAnimation.fillMode = kCAFillModeForwards;
        self.activityIndicator.layer.add(rotationAnimation, forKey: "rotation");
    }
    
    private func closeAnimate(animate: Bool, end: ((Bool) -> ())?) {
        self.activityIndicator.layer.removeAllAnimations();
        if (!animate) {
            self.bgView.removeFromSuperview();
            self.removeFromSuperview();
            if (end != nil) {
                end!(true);
            }
            return;
        }
        UIView.animate(withDuration: 0.25, animations: {() in
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
            self.alpha = 0;
            self.bgView.alpha = 0;
        }, completion: { (complete) in
            self.bgView.removeFromSuperview();
            self.removeFromSuperview();
        });
        if (end != nil) {
            end!(true);
        }
    }
    @objc private func closeAction() {
        if (currentHUD != nil) {
            closeAnimate(animate: true, end: {(complete) in
                if (self.closeCallback != nil) {
                    self.closeCallback!();
                }
            });
        }
        currentHUD = nil;
    }
    class func hideHUD() {
        if (currentHUD != nil) {
            currentHUD?.closeAnimate(animate: true, end: nil);
            currentHUD?.closeCallback = nil;
        }
        currentHUD = nil;
    }
    private func closeNoAniate() {
        closeAnimate(animate: false, end: {(complete) in
            self.closeCallback = nil
        });
        currentHUD = nil;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
