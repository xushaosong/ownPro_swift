//
//  CustomCalloutView.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/12.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

let kPortraitMargin: CGFloat = 5
let kPortraitWidth: CGFloat = 70
let kPortraitHeight: CGFloat = 50

let kTitleWidth: CGFloat = 120
let kTitleHeight: CGFloat = 20

class CustomCalloutView: UIView {

    var iconImageString: String? {
        didSet {
            self.portraitView.image = ToolModule.getImagePath(imageName: iconImageString!)
        }
    }
    var title: String? {
        didSet {
            self.titleLabel.text = title;
        }
    }
    var subTitle: String? {
        didSet {
            self.subTitleLabel.text = subTitle;
        }
    }
    
    private let portraitView: UIImageView = UIImageView();
    private let titleLabel: UILabel = UILabel();
    private let subTitleLabel: UILabel = UILabel();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        initSubViews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        
        self.portraitView.frame = CGRect(x: kPortraitMargin, y: kPortraitMargin, width: kPortraitWidth, height: kPortraitHeight);
        self.portraitView.backgroundColor = Color_black;
        self.addSubview(self.portraitView);
        
        self.titleLabel.frame = CGRect(x: kPortraitMargin * 2 + kPortraitWidth, y: kPortraitMargin, width: kTitleWidth, height: kTitleHeight)
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 14);
        self.titleLabel.textColor = Color_white;
        self.titleLabel.text = "title";
        self.addSubview(self.titleLabel);
        
        self.subTitleLabel.frame = CGRect(x: kPortraitMargin * 2 + kPortraitWidth, y: kPortraitMargin * 2 + kTitleHeight, width: kTitleWidth, height: kTitleHeight);
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 12);
        self.subTitleLabel.textColor = UIColor.lightGray;
        self.subTitleLabel.text = "subtitle";
        self.addSubview(self.subTitleLabel);
    }
    
    override func draw(_ rect: CGRect) {
        
        drawInContext(context: UIGraphicsGetCurrentContext()!);
        self.layer.shadowColor = Color_black.cgColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSize(width: 0, height: 0);
    }
    func drawInContext(context: CGContext) {
        
        context.setLineWidth(2);
        context.setFillColor(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8).cgColor);
        self.getDrawPath(context: context);
        context.fillPath();
    }
    
    let kArrorHeight: CGFloat = 10;
    func getDrawPath(context: CGContext) {
        let rrect = self.bounds;
        let radius: CGFloat = 6.0;
        let minx = rrect.minX;
        let midx = rrect.midX;
        let maxx = rrect.maxX;
        let miny: CGFloat = rrect.minY;
        let maxy: CGFloat = rrect.maxY - kArrorHeight;
        
        context.move(to: CGPoint(x: midx+kArrorHeight, y: maxy));
        context.addLine(to: CGPoint(x: midx, y: maxy+kArrorHeight));
        context.addLine(to: CGPoint(x: midx-kArrorHeight, y: maxy));
        
        context.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: miny), radius: radius);
        context.addArc(tangent1End: CGPoint(x: minx, y: minx), tangent2End: CGPoint(x: maxx, y: miny), radius: radius);
        context.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: maxx), radius: radius);
        context.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: midx, y: maxy), radius: radius);
        context.closePath();
    }
}
