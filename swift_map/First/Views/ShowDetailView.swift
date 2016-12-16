//
//  ShowDetailView.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/12.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit



class ShowDetailView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var moveActionCallback:((CGFloat) -> Void)?;
    var moveActionEndCallback:(() -> Void)?
    
    let POIDetail_Image_Height: CGFloat = 200
    
    var dataArray: Array<AMapPOI> = [];
    var headerImageView: UIImageView = UIImageView();
    
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
    var collectionView: UICollectionView?;
    let tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain);
    let goToThereView: UIView = UIView();
    let navigatorBarView: UIView = UIView();
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.red;
        
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout);
        self.addSubview(navigatorBarView);
        self.addSubview(tableView);
        self.addSubview(collectionView!);
        self.addSubview(goToThereView);
        self.addSubview(headerImageView);
        
        self.goToThereView.backgroundColor = Color_Subway_NUM_8_BG;
        self.navigatorBarView.backgroundColor = Color_Navigator;
        
        flowLayout.itemSize = CGSize(width: scWidth, height: 120);
        flowLayout.scrollDirection = .horizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        let up = UIPanGestureRecognizer(target: self, action: #selector(swipeUp(gestrue:)));
        up.maximumNumberOfTouches = 1;
        for res in (self.collectionView?.gestureRecognizers)! {
            res.isEnabled = false;
        }
        self.collectionView?.addGestureRecognizer(up);
        
        self.collectionView?.backgroundColor = Color_white;
        self.collectionView?.delegate = self;
        self.collectionView?.dataSource = self;
        self.collectionView?.isPagingEnabled = true;
        self.collectionView?.register(UINib(nibName: "PoiDataCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.headerImageView.snp.makeConstraints { (constraint) in
            constraint.top.equalToSuperview();
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.height.equalTo(POIDetail_Image_Height);
        }
        
        self.collectionView!.snp.makeConstraints { (constraint) in
            constraint.top.equalTo(self.headerImageView.snp.bottom).offset(0);
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.height.equalTo(120);
        };
        
        self.tableView.snp.makeConstraints { (constraint) in
            constraint.top.equalTo(self.headerImageView.snp.bottom).offset(0);
            constraint.right.equalToSuperview();
            constraint.left.equalToSuperview();
            constraint.bottom.equalToSuperview();
        };
        self.goToThereView.snp.makeConstraints { (constraint) in
            constraint.right.equalToSuperview().inset(30);
            constraint.centerY.equalTo(POIDetail_Image_Height);
            constraint.width.equalTo(50);
            constraint.height.equalTo(50);
        };
        self.navigatorBarView.snp.makeConstraints { (constraint) in
            constraint.top.equalTo(self.headerImageView.snp.bottom).offset(0);
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.height.equalTo(NavigationBar_HEIGHT);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PoiDataCell;
        
        return cell;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        }
        cell?.textLabel?.text = String(indexPath.row);
        return cell!;
    }
    
    
    var beginPoint: CGPoint?;
    
    var moveX: Int = 0;
    var contentOffset: CGPoint?;
    func swipeUp(gestrue: UIPanGestureRecognizer) {
        
        
        if (gestrue.state == .began) {
            contentOffset = self.collectionView?.contentOffset;
            beginPoint = gestrue.location(in: self.superview);
        } else if (gestrue.state == .changed) {
            
            let currentPoint = gestrue.location(in: self.superview);
            
            if (moveX == 0) {
                if (currentPoint.x != beginPoint?.x) {
                    moveX = 1;
                    let distance = currentPoint.x - (beginPoint?.x)!;
                    
                    self.collectionView?.contentOffset = CGPoint(x: (contentOffset?.x)! - distance, y: (contentOffset?.y)!)
                } else {
                    moveX = 2;
                    if (self.moveActionCallback != nil) {
                        self.moveActionCallback!((beginPoint?.y)! - currentPoint.y);
                    }
                }
                
            } else {
                if (moveX == 1) {
                    let distance = currentPoint.x - (beginPoint?.x)!;
                    self.collectionView?.contentOffset = CGPoint(x: (contentOffset?.x)! - distance, y: (contentOffset?.y)!)
                } else if (moveX == 2) {
                    if (self.moveActionCallback != nil) {
                        
                        self.moveActionCallback!((beginPoint?.y)! - currentPoint.y);
                    }
                }
            }
            
        } else if (gestrue.state == .ended || gestrue.state == .cancelled) {
            
            if (moveX == 1) {
                
                var page = Int((self.collectionView?.contentOffset.x)!) / Int(scWidth);
                if (gestrue.velocity(in: self.superview).x < 0.0 && gestrue.velocity(in: self.superview).x < -800.0) {
                    let countPage = Int((self.collectionView?.contentSize.width)! / scWidth);
                    if (page != countPage - 1) {
                        page += 1;
                    }
                    self.collectionView?.setContentOffset(CGPoint(x: Int(scWidth) * page, y: 0), animated: true);
                } else if(gestrue.velocity(in: self.superview).x < 0.0 && gestrue.velocity(in: self.superview).x > -800.0) {
                    self.collectionView?.setContentOffset(CGPoint(x: Int(scWidth) * page, y: 0), animated: true);
                } else if (gestrue.velocity(in: self.superview).x > 0.0 && gestrue.velocity(in: self.superview).x > 800) {
                    if (page == 0) {
                        page = 0;
                    }
                    self.collectionView?.setContentOffset(CGPoint(x: Int(scWidth) * page, y: 0), animated: true);
                } else {
                    self.collectionView?.setContentOffset(CGPoint(x: Int(scWidth) * page, y: 0), animated: true);
                }
            } else {
                if (self.moveActionEndCallback != nil) {
                    self.moveActionEndCallback!();
                }
                var selfFrame = self.frame;
                if ((selfFrame.origin.y + POIDetail_Image_Height) < scHeight / 2 && (selfFrame.origin.y + POIDetail_Image_Height) > 100) {
                    selfFrame.origin.y = 0;
                } else if ((selfFrame.origin.y + POIDetail_Image_Height) > scHeight / 2) {
                    selfFrame.origin.y = scHeight - (120 + POIDetail_Image_Height);
                } else if ((selfFrame.origin.y + POIDetail_Image_Height) < 100) {
                    selfFrame.origin.y = 64 - 200;
                }
                UIView.animate(withDuration: 0.25) {
                    super.frame = selfFrame;
                };
            }
            moveX = 0;
        }
    }
    
    override var frame: CGRect {
        didSet {
            print(frame);
        }
    }
    
}
