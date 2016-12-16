//
//  SearchCategoryLayout.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/7.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

protocol SBCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
}

extension SBCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.clear
    }
}

class CollectionViewDecorationLayoutAttributes: UICollectionViewLayoutAttributes {
    var leftColor = UIColor.clear
}

class SearchCategoryLayout: UICollectionViewFlowLayout {

    var layoutInfoArr: Array<Array<UICollectionViewLayoutAttributes>>?;
    var layoutSuppleArr: Array<UICollectionViewLayoutAttributes>?;
    var decorationViewArr: Array<UICollectionViewLayoutAttributes>?;
    var contentSize: CGSize?;
    
    var sectionLeft: CGFloat = 0;
    
    override init() {
        super.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let rowCount: Int = 3;
    
    override func prepare() {
        super.prepare();
        
        let delegate = self.collectionView?.delegate as! SBCollectionViewDelegateFlowLayout;
        
        layoutInfoArr = Array();
        layoutSuppleArr = Array();
        self.decorationViewArr = Array();
        var maxNumberOfItems = 0;
        var maxContentSizeHeight: CGFloat = 0;
        var maxHeightArray: Array<CGFloat> = Array();
        var maxHeight: CGFloat = 0;
        let numberOfSecions: Int = (self.collectionView?.numberOfSections)!;
        var decorationViewY: CGFloat = 0;
        var decorationViewHeight: CGFloat = 0;
        for section in 0..<numberOfSecions {
            
            let indexPath = IndexPath(item: 0, section: section);
            let decorationViewAttri = self.layoutAttributesForDecorationView(ofKind: "DecorationView", at: indexPath) as! CollectionViewDecorationLayoutAttributes;
            let supplementAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath);
            var supplementY: CGFloat = 0;
            if (maxHeight == 0.0) {
                supplementY = self.sectionInset.top;
                maxHeight = self.sectionInset.top;
            } else {
                supplementY = maxHeight;
            }
            
            supplementAttri?.frame = CGRect(x: self.sectionInset.left, y: supplementY, width: scWidth - self.sectionInset.left - self.sectionInset.right, height: self.headerReferenceSize.height);
            layoutSuppleArr?.append(supplementAttri!);
            maxHeight += self.headerReferenceSize.height;
            
            decorationViewY = maxHeight + self.minimumLineSpacing;
            
            let numberOfItems: Int = (self.collectionView?.numberOfItems(inSection: section))!;
            var subArr: Array<UICollectionViewLayoutAttributes> = Array();
            for item in 0..<numberOfItems {
                let indexPath = NSIndexPath(item: item, section: section);
                let attributes = self.layoutAttributesForItem(at: indexPath as IndexPath);
            
                var col = item % rowCount;
//                maxHeight = self.sectionInset.top;
                let height = getHeight();
                
                if (maxHeightArray.count == rowCount) {
                    maxHeight = maxHeightArray[0];
                    for (index, minH) in maxHeightArray.enumerated() {
                        if (maxHeight > minH) {
                            maxHeight = minH;
                            col = index;
                        }
                    }
                    maxHeightArray.remove(at: col);
                    maxHeightArray.insert(maxHeight + height + self.minimumLineSpacing, at: col);
                    
                } else {
                    maxHeightArray.append(maxHeight + height + self.minimumLineSpacing);
                }
                
                attributes?.frame = CGRect(x: getX(col: col) + sectionLeft, y: maxHeight + self.minimumLineSpacing, width: getWidth(), height: height);
                
                subArr.append(attributes!);
                if (item == numberOfItems - 1) {
//                    maxHeight += self.sectionInset.bottom;
                }
            }
            

            if (decorationViewAttri != nil) {
                self.decorationViewArr?.append(decorationViewAttri);
            }
            
//            maxHeight = 0;
            for maxH in maxHeightArray {
                if (maxHeight < maxH) {
                    maxHeight = maxH;
                }
            }
            
            decorationViewHeight = maxHeight - decorationViewY;
            decorationViewAttri.frame = CGRect(x: getX(col: 0), y: decorationViewY, width: scWidth - self.sectionInset.left - sectionInset.right, height: decorationViewHeight);
            decorationViewAttri.leftColor = delegate.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section);
            
            for maxH in maxHeightArray {
                if (maxContentSizeHeight <= maxH) {
                    maxContentSizeHeight = maxH;
                }
            }
            maxHeightArray.removeAll();
            layoutInfoArr?.append(subArr);
        }
        self.contentSize = CGSize(width: scWidth, height: maxContentSizeHeight + self.sectionInset.bottom);
    }
    
    
    
    override var collectionViewContentSize: CGSize {
        get {
            return self.contentSize!;
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArr: Array<UICollectionViewLayoutAttributes> = Array();
        for subArr in self.layoutInfoArr! {
            for obj in subArr {
                if (obj.frame.intersects(rect)) {
                    layoutAttributesArr.append(obj);
                }
            }
        }
        for sub in layoutSuppleArr! {
            if (sub.frame.intersects(rect)) {
                layoutAttributesArr.append(sub)
            }
        }
        for sub in self.decorationViewArr! {
            if (sub.frame.intersects(rect)) {
                layoutAttributesArr.append(sub);
            }
        }
        return layoutAttributesArr;
    }
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(elementKind);
        let at = CollectionViewDecorationLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath);
        at.zIndex = -1;
        return at;
    }
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)! as UICollectionViewLayoutAttributes;
        
        return attribute;
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        return attributes;
    }
    
    func getX(col: Int) -> CGFloat {
        return self.sectionInset.left + CGFloat(Float(col)) * (getWidth() + self.minimumInteritemSpacing);
    }
    func getHeight() -> CGFloat {
        return 40;
    }
    func getWidth() -> CGFloat {
        return (scWidth - sectionLeft - self.sectionInset.left - self.sectionInset.right - (CGFloat(Float(rowCount)) - 1.0) * self.minimumInteritemSpacing) / CGFloat(Float(rowCount));
        
    }
}
