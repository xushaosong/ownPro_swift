//
//  APPNavigationBarView.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/11/29.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

typealias backItemClickBlock = () -> ()

class APPNavigationBarView: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var navigatorBarMain: NavigatorBarMain = .NavigatorBar_Center {
        didSet {
            updateViewsConstraint();
        }
    };
    
    let contentView: UIView = UIView();
    
    let titleView: UIView = UIView();
    let leftView: UIView = UIView();
    let rightView: UIView = UIView();
    var backItemClick: backItemClickBlock?;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = Color_Navigator;
        
        
        self.addSubview(contentView);
        contentView.backgroundColor = UIColor.clear;
        
        contentView.addSubview(leftView);
        contentView.addSubview(titleView);
        contentView.addSubview(rightView);
        
        leftView.clipsToBounds = true;
        rightView.clipsToBounds = true;
        titleView.clipsToBounds = true;
        
        contentView.snp.makeConstraints { (constraint) in
            constraint.top.equalToSuperview().inset(20);
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.bottom.equalToSuperview();
        };
        
        leftView.snp.makeConstraints { (constraint) in
            constraint.left.equalToSuperview().inset(10);
            constraint.centerY.equalToSuperview();
        };
        titleView.snp.makeConstraints { (constraint) in
            constraint.centerX.equalToSuperview();
            constraint.centerY.equalToSuperview();
        };
        rightView.snp.makeConstraints { (constraint) in
            constraint.right.equalToSuperview().inset(10);
            constraint.centerY.equalToSuperview();
        };
        
        self.leftView.addSubview(createDefaultBackButton());
        
        let bottomLine = UIView();
        bottomLine.backgroundColor = Color_Navigator_Bottom_Line;
        self.addSubview(bottomLine);
        bottomLine.snp.makeConstraints { (contraint) in
            contraint.left.equalToSuperview();
            contraint.right.equalToSuperview();
            contraint.bottom.equalTo(self.snp.bottom).inset(0);
            contraint.height.equalTo(1);
        }
     
        self.addLeftContent(childView: createDefaultBackButton())
    }
    
    func createDefaultBackButton() -> UIButton {
        let button = UIButton(type: .custom);
        button.setImage(ToolModule.getImagePath(imageName: "navi/back.png"), for: .normal);
        button.setImage(ToolModule.getImagePath(imageName: "navi/back_h.png"), for: .highlighted);
        button.addTarget(self, action: #selector(pop), for: .touchUpInside);
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
        return button;
    }
    func pop() {
        if (self.backItemClick != nil) {
            self.backItemClick!();
        }
    }
    
    func removeSub(view: UIView) {
        for subView in view.subviews {
            subView.removeFromSuperview();
        }
    }
    func addLeftContent(childView: UIView) {
        removeSub(view: self.leftView);
        self.leftView.addSubview(childView);
        childView.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
        updateViewsConstraint()
    }
    func addTitleContent(childView: UIView) {
        removeSub(view: self.titleView);
        self.titleView.addSubview(childView);
        childView.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
        updateViewsConstraint();
    }
    func addRightContent(childView: UIView) {
        removeSub(view: self.rightView);
        self.rightView.addSubview(childView);
        childView.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
        updateViewsConstraint();
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "frame") {
            updateViewsConstraint();
        }
    }
    
    func updateViewsConstraint() {
        
        
        
        if (navigatorBarMain == .NavigatorBar_Center) {
            // 先计算title
            if (self.titleView.subviews.count == 0) {
                self.titleView.isHidden = true;
                if (self.leftView.subviews.count > 0) {
                    let leftChild = self.leftView.subviews.first;
                    self.leftView.isHidden = false;
                    self.leftView.snp.remakeConstraints({ (constraint) in
                        constraint.left.equalToSuperview().inset(10);
                        constraint.centerY.equalToSuperview();
                        constraint.height.equalTo((leftChild?.bounds.size.height)!);
                        constraint.width.equalTo((leftChild?.bounds.size.width)!);
                    })
                } else {
                    self.leftView.isHidden = true;
                }
                if (self.rightView.subviews.count > 0) {
                    let rightChild = self.rightView.subviews.first;
                    self.rightView.isHidden = false;
                    self.rightView.snp.remakeConstraints({ (constraint) in
                        constraint.right.equalToSuperview().inset(10);
                        constraint.centerY.equalToSuperview();
                        constraint.height.equalTo((rightChild?.bounds.size.height)!);
                        constraint.width.equalTo((rightChild?.bounds.size.width)!)
                    })
                } else {
                    self.rightView.isHidden = true;
                }
            } else {
                self.titleView.isHidden = false;
                
                let titleChild = self.titleView.subviews.first;
                if ((titleChild?.bounds.size.width)! < scWidth - 2 * 60) {
                    self.titleView.snp.remakeConstraints({ (constraint) in
                        constraint.centerX.equalToSuperview();
                       constraint.centerY.equalToSuperview();
                        constraint.height.equalTo((titleChild?.bounds.size.height)!);
                        constraint.width.equalTo((titleChild?.bounds.size.width)!).priority(1000);
                    });
                    
                } else {
                    self.titleView.snp.remakeConstraints({ (constraint) in
                        constraint.centerX.equalToSuperview();
                        constraint.centerY.equalToSuperview();
                        constraint.height.equalTo((titleChild?.bounds.size.height)!);
                        constraint.width.equalTo(scWidth - 2 * 60).priority(1000);
                    });
                }
                self.leftView.snp.remakeConstraints({ (constraint) in
                    constraint.left.equalToSuperview().inset(10);
                    constraint.centerY.equalToSuperview();
                    if (self.leftView.subviews.count > 0) {
                        constraint.height.equalTo((self.leftView.subviews.first?.bounds.size.height)!);
                    }
                    constraint.right.equalTo(self.titleView.snp.left).offset(10);
                });
                
                self.rightView.snp.remakeConstraints({ (constraint) in
                    constraint.right.equalToSuperview().inset(10);
                    constraint.centerY.equalToSuperview();
                    if (self.rightView.subviews.count > 0) {
                        constraint.height.equalTo((self.rightView.subviews.first?.bounds.size.height)!)
                    }
                    
                    constraint.left.equalTo(self.titleView.snp.right).offset(10);
                })
            }
        } else if (navigatorBarMain == .NavigatorBar_Left) {
            if (self.leftView.subviews.count > 0) {
                self.leftView.isHidden = false;
                let leftChild = self.leftView.subviews.first;
                
                if ((leftChild?.bounds.size.width)! > scWidth / 2 - 10) {
                    self.titleView.isHidden = true;
                    if ((leftChild?.bounds.size.width)! > scWidth - 70) {
                        self.rightView.isHidden = true;
                        self.leftView.snp.remakeConstraints({ (constraint) in
                            constraint.left.equalToSuperview().inset(10);
                            constraint.centerY.equalToSuperview();
                            constraint.height.equalTo((leftChild?.bounds.size.height)!)
                            constraint.right.equalToSuperview().inset(10);
                        })
                    } else {
                        self.rightView.isHidden = false;
                        
                        self.leftView.snp.remakeConstraints({ (constraint) in
                            constraint.left.equalToSuperview().inset(10);
                            constraint.centerY.equalToSuperview();
                            constraint.height.equalTo((leftChild?.bounds.size.height)!)
                        });
                        self.rightView.snp.remakeConstraints({ (constraint) in
                            constraint.left.equalTo(self.leftView.snp.right).offset(10);
                            if (self.rightView.subviews.count > 0) {
                                constraint.height.equalTo((self.rightView.subviews.first?.bounds.size.height)!);
                            }
                            constraint.right.equalToSuperview().inset(10);
                            constraint.centerY.equalToSuperview();
                        })
                    }
                } else {
                    self.titleView.isHidden = false;
                    self.leftView.snp.remakeConstraints({ (constraint) in
                        constraint.left.equalToSuperview().inset(10);
                        constraint.centerY.equalToSuperview();
                        constraint.height.equalTo((leftChild?.bounds.size.height)!)
                        
                        constraint.width.equalTo((leftChild?.bounds.size.width)!);
                        constraint.right.equalTo(self.titleView.snp.left).offset(10);
                    });
                    self.titleView.snp.remakeConstraints({ (constraint) in
                        constraint.top.equalToSuperview().inset(20);
                        constraint.bottom.equalToSuperview();
                        if (self.titleView.subviews.count > 0) {
                            constraint.height.equalTo((self.titleView.subviews.first?.bounds.size.height)!);
                        }
                    });
                    self.rightView.snp.remakeConstraints({ (constraint) in
                    constraint.left.equalTo(self.titleView.snp.right).offset(10);
                        if (self.rightView.subviews.count > 0) {
                            constraint.height.equalTo((self.rightView.subviews.first?.bounds.size.height)!);
                        }
                        constraint.right.equalToSuperview().inset(10);
                        constraint.centerY.equalToSuperview();
                        constraint.width.equalTo((leftChild?.bounds.size.width)!)
                    })
                }
            }
        } else if (navigatorBarMain == .NavigatorBar_Right) {
            if (self.rightView.subviews.count > 0) {
                self.rightView.isHidden = false;
                let rightChild = self.rightView.subviews.first;
                
                if ((rightChild?.bounds.size.width)! > scWidth / 2 - 10) {
                    
                    self.titleView.isHidden = true;
                    if ((rightChild?.bounds.size.width)! > scWidth - 70) {
                        self.leftView.isHidden = true;
                        self.rightView.snp.remakeConstraints({ (constraint) in
                            constraint.left.equalToSuperview().inset(10);
                            constraint.centerY.equalToSuperview();
                            constraint.right.equalToSuperview().inset(10);
                            constraint.height.equalTo((rightChild?.bounds.size.height)!);
                        })
                    } else {
                        self.leftView.isHidden = false;
                        
                        self.leftView.snp.remakeConstraints({ (constraint) in
                            constraint.right.equalTo(self.rightView.snp.left).offset(10);
                            constraint.left.equalToSuperview().inset(10);
                            constraint.centerY.equalToSuperview();
                            if (self.leftView.subviews.count > 0) {
                                constraint.height.equalTo((self.leftView.subviews.first?.bounds.size.height)!);
                            }
                        });
                        
                        self.rightView.snp.remakeConstraints({ (constraint) in
                            constraint.right.equalToSuperview().inset(10);
                            constraint.centerY.equalToSuperview();
                            constraint.width.equalTo((rightChild?.bounds.size.width)!);
                            constraint.height.equalTo((rightChild?.bounds.size.height)!);
                        });
                        
                    }
                } else {
                    print("--------")
                    self.titleView.isHidden = false;
                    self.rightView.snp.remakeConstraints({ (constraint) in
                        constraint.right.equalToSuperview().inset(10);
                        constraint.top.equalToSuperview().inset(20);
                        constraint.bottom.equalToSuperview();
                        constraint.width.equalTo((rightChild?.bounds.size.width)!);
                        constraint.left.equalTo(self.titleView.snp.right).offset(10);
                    });
                    self.titleView.snp.remakeConstraints({ (constraint) in
                        constraint.centerY.equalToSuperview();
                        if (self.titleView.subviews.count > 0) {
                            constraint.height.equalTo((self.titleView.subviews.first?.bounds.size.height)!);
                        }
                    });
                    self.leftView.snp.remakeConstraints({ (constraint) in
                    
                        if (self.leftView.subviews.count > 0) {
                            constraint.height.equalTo((self.leftView.subviews.first?.bounds.size.height)!);
                        }
                        constraint.right.equalTo(self.titleView.snp.left).offset(10);
                        constraint.left.equalToSuperview().inset(10);
                        constraint.top.equalToSuperview().inset(20);
                        constraint.bottom.equalToSuperview();
                        constraint.width.equalTo((rightChild?.bounds.size.width)!)
                    })
                }
            }
        }
    }
}
