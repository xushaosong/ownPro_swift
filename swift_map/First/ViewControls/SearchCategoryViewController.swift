//
//  SearchCategoryViewController.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/7.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

typealias SearchCategoryItemClickBlock = (String) -> ();

let itemSectionLeft: CGFloat = 25;

class SearchCategoryViewController: BaseViewController, SBCollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    var collectionView: UICollectionView?;
    var dataSourceArray:NSArray = NSArray();
    var categoryItemCallback: SearchCategoryItemClickBlock?;
    
    let cellIdentify: String = "searchCategoryCell";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundlePath = Bundle.main.path(forResource: "file", ofType: "bundle");
        self.dataSourceArray = NSArray(contentsOfFile: bundlePath! + "/category.plist")!;
        
        let title = ToolModule.setNavigationTitle(title: "更多");
        title.textColor = Color_black;
        self.navigatorBar.addTitleContent(childView: title);
        
        self.navigatorBar.backgroundColor = Color_fafafa;
        let flowLayout = SearchCategoryLayout();
        flowLayout.sectionLeft = itemSectionLeft;
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20);
        flowLayout.itemSize = CGSize(width: 0, height: 50);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.headerReferenceSize = CGSize(width: 10, height: 35);
        
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout);
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        collectionView?.backgroundColor = Color_f4f4f4;
        
        self.view.addSubview(collectionView!);
        
        collectionView?.snp.makeConstraints { (constraint) in
            constraint.top.equalTo(self.navigatorBar.snp.bottom);
            constraint.left.equalToSuperview();
            constraint.right.equalToSuperview();
            constraint.bottom.equalToSuperview();
        }
        
        collectionView?.register(SearchCategoryCell.self, forCellWithReuseIdentifier: cellIdentify);
        collectionView?.register(SearchCategorySectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header");
        flowLayout.register(SearchCategorySectionDecoration.self, forDecorationViewOfKind: "DecorationView");
    }
    
    // uicollectionView代理
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSourceArray.count;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arr = (self.dataSourceArray[section] as AnyObject)["content"] as! NSArray;
        return arr.count;
    }
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentify, for: indexPath) as! SearchCategoryCell;
        let arr = (self.dataSourceArray[indexPath.section] as AnyObject)["content"] as! NSArray;
        let dict = arr[indexPath.row] as! Dictionary<String, String>;
        searchCell.data = dict;
        
        let col = indexPath.row % 3;
        let row = indexPath.row / 3;
        
        if (col ==  0) {
            searchCell.leftLine.isHidden = true;
            searchCell.rightLine.isHidden = false;
        } else if (col == 1) {
            searchCell.leftLine.isHidden = true;
            searchCell.rightLine.isHidden = false;
        } else if (col == 2) {
            searchCell.leftLine.isHidden = true;
            searchCell.rightLine.isHidden = true;
        }
        if (row == 0) {
            searchCell.topLine.isHidden = true;
            searchCell.bottomLine.isHidden = false;
        } else if (arr.count % 3 != 0 && row == (arr.count / 3)) {
            searchCell.topLine.isHidden = true;
            searchCell.bottomLine.isHidden = true;
        } else if (arr.count % 3 == 0 && row == (arr.count / 3 - 1)) {
            searchCell.topLine.isHidden = true;
            searchCell.bottomLine.isHidden = true;
        } else {
            
            searchCell.topLine.isHidden = true;
            searchCell.bottomLine.isHidden = false;
        }
        
        
        return searchCell;
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! SearchCategorySectionHeader;
            
            let dict = self.dataSourceArray[indexPath.section] as! Dictionary<String, Any>;
            header.title = dict["title"] as! String?;
            header.color = dict["color"] as! String?;
            return header;
        } else {
            return UIView() as! UICollectionReusableView;
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        let dict = self.dataSourceArray[section] as! Dictionary<String, Any>;
        return UIColor.colorWidthHex(hexString: dict["color"] as! NSString, alpha: 1);
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.dataSourceArray[indexPath.section] as! Dictionary<String, Any>;
        let contents = dict["content"] as! Array<Dictionary<String, Any>>;
        
        self.navigationController?.popViewController(animated: true);
        
        if (self.categoryItemCallback != nil) {
            self.categoryItemCallback!((contents[indexPath.item] as! Dictionary)["type"]!);
        }
        
    }
}



