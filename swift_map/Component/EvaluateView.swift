//
//  EvaluateView.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/2.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//  用星星图标显示评价信息

import UIKit

typealias Value_ChangedBlock = (CGFloat, String) -> ()

class EvaluateView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let firstStartLeftPadding: CGFloat = 0;
    var valueChanged: Value_ChangedBlock?;
    
    private let startCount: NSInteger = 5;
    // 最大值为5
    private var currentValue: CGFloat = 0;
    private let evaluateName: Array<String> = [
        "非常差",
        "很差",
        "一般",
        "很好",
        "非常好"
    ];
    var value: CGFloat = 0 {
        didSet {
            setValue();
            currentValue = value;
        }
    };
    var startArray: Array<UIImageView> = Array();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.clipsToBounds = true;
        for index in 0...startCount {
            let start = createImageView();
            addAnimate(imageView: start, key: index);
            self.addSubview(start);
            
            if (index == 0) {
               start.snp.makeConstraints({ (constraint) in
                constraint.left.equalToSuperview().inset(firstStartLeftPadding);
                constraint.top.equalToSuperview();
                constraint.bottom.equalToSuperview();
                
               });
            } else if (index == startCount - 1) {
                start.snp.makeConstraints({ (constraint) in
                    constraint.left.equalTo(self.startArray[index - 1].snp.right).offset(0)
                    constraint.top.equalToSuperview();
                    constraint.bottom.equalToSuperview();
                    constraint.width.equalTo(self.startArray[0].snp.width);
                    constraint.right.equalToSuperview();
                });
            } else {
                start.snp.makeConstraints({ (constraint) in
                    constraint.left.equalTo(self.startArray[index - 1].snp.right).offset(0)
                    constraint.bottom.equalToSuperview();
                    constraint.top.equalToSuperview();
                    constraint.width.equalTo(self.startArray[0].snp.width);
                });
            }
            self.startArray.append(start);
        }
        
    }
    func addAnimate(imageView: UIImageView, key: Int) {
        /*
         CATransition *transition = [CATransition animation];
         transition.duration = 0.3;
         transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
         transition.type = kCATransitionFade;
         [self.backgroundImage.layer addAnimation:transition forKey:@"a"];
         [self.backgroundImage setImage:self.basicImage];
         */
        
        let transition = CATransition();
        transition.duration = 1;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        transition.type = kCATransitionFade;
        imageView.layer.add(transition, forKey: String(key));
    }
    func setValue() {
        if (value > 5.0) {
            return
        }
//        setCurrentValueTo0();
        
        if (value - currentValue < 0) {
            // 减少
            reduceEvaluate(from: currentValue, to: value);
        } else if (value - currentValue > 0) {
            // 增加
            addEvaluate(from: currentValue, to: value);
            
        }
        currentValue = value;
        if (self.valueChanged != nil) {
            self.valueChanged!(currentValue, value == 0.0 ? "" : evaluateName[Int(value) - 1]);
        }
    }
    
    func addEvaluate(from: CGFloat, to: CGFloat) {
        let difference = to - from;
        if (difference == 0.5) {
            if (from == CGFloat(floor(from))) {
                setStartStatus(index: Int(ceil(to)) - 1, status: .Half);
            } else {
                setStartStatus(index: Int(ceil(from)) - 1, status: .Full);
            }
        } else {
            if (from == CGFloat(floor(from))) {
                // 开始是整数
                for index in Int(floor(from))...Int(ceil(to)) - 1 {
                    if (to != CGFloat(ceil(to)) && index == Int(ceil(to)) - 1) {
                        setStartStatus(index: index, status: .Half);
                    } else {
                        setStartStatus(index: index, status: .Full);
                    }
                }
            } else {
                // 开始是小数
                for index in Int(floor(from))...Int(ceil(to)) - 1 {
                    if (to != CGFloat(ceil(to)) && index == Int(ceil(to)) - 1) {
                        setStartStatus(index: index, status: .Half);
                    } else {
                        setStartStatus(index: index, status: .Full);
                    }
                }
            }
        }
    }
    func reduceEvaluate(from: CGFloat, to: CGFloat) {
        let difference = from - to;
        if (difference == 0.5) {
            if (from == CGFloat(floor(from))) {
                setStartStatus(index: Int(floor(to)), status: .Half);
            } else {
                setStartStatus(index: Int(floor(from)), status: .Empty);
            }
        } else {
            if (from == CGFloat(floor(from))) {
                for index in Int(floor(to))...Int(from) - 1 {
                    if (to != CGFloat(floor(to)) && index == Int(floor(to))) {
                        setStartStatus(index: index, status: .Half);
                    } else {
                        setStartStatus(index: index, status: .Empty);
                    }
                }
            } else {
                for index in Int(floor(to))...Int(ceil(from)) - 1 {
                    if (to != CGFloat(floor(to)) && index == Int(floor(to))) {
                        setStartStatus(index: index, status: .Half);
                    } else {
                        setStartStatus(index: index, status: .Empty);
                    }
                }
            }
        }
    }
    
    
    let transition = CATransition();
    func setStartStatus(index: Int, status: EvaluateStartStatus) {
        let start = self.startArray[index];
        switch status {
        case .Empty:
            start.image = ToolModule.getImagePath(imageName: "evaluate/empty_start.png");
            break;
        case .Half:
            start.image = ToolModule.getImagePath(imageName: "evaluate/half_start.png");
            break;
        case .Full:
            start.image = ToolModule.getImagePath(imageName: "evaluate/full_start.png");
            break;
        }
        
        
        
        transition.duration = 0.2;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        transition.type = kCATransitionFade;
        start.layer.add(transition, forKey: "x");
        
    }
    
    
    // currentValue = 0
    func setCurrentValueTo0() {
        for start in self.startArray {
            start.image = ToolModule.getImagePath(imageName: "evaluate/empty_start.png");
        }
        currentValue = 0;
    }
    
    func createImageView() -> UIImageView {
        let startView = UIImageView();
        startView.image = ToolModule.getImagePath(imageName: "evaluate/empty_start.png");
        startView.contentMode = .scaleAspectFit;
        return startView;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first != nil) {
            touchGetValue(touches: touches);
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first != nil) {
            touchGetValue(touches: touches);
        }
    }
    func touchGetValue (touches: Set<UITouch>){
        let point = touches.first?.location(in: self);
        
        if ((point?.x)! < firstStartLeftPadding) {
            value = 0;
            return;
        }
        
        let startWidth = (self.frame.size.width - firstStartLeftPadding) / CGFloat(Float(startCount));
        let index = Int(((point?.x)! - firstStartLeftPadding) / startWidth);
        let other = (point?.x)! - firstStartLeftPadding - startWidth * CGFloat(Float(index));
        if (other > startWidth / 2) {
            value = CGFloat(Float(index + 1));
        } else {
            value = CGFloat(Float(index));
        }
        
    }
}
