//
//  IMEFlowLayout.swift
//  IphoneMessageEffect
//
//  Created by 刘晓晨 on 2017/5/9.
//  Copyright © 2017年 刘晓晨. All rights reserved.
//

import UIKit

class IMEFlowLayout: UICollectionViewFlowLayout {
    
    
    override init() {
        super.init()
        springDamping = 0.5;
        springFrequency = 0.8;
        resistanceFactor = 500;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var animator:UIDynamicAnimator?
    
    lazy var collision:UICollisionBehavior = {
        
        let behavior:UICollisionBehavior = UICollisionBehavior()
        
        return behavior
    
    }()

    var springDamping:CGFloat? {
        didSet{
            
            if springDamping! >= CGFloat(0) && oldValue != springDamping {
                
                for spring:UIDynamicBehavior in (self.animator?.behaviors)! {
                    
                    let spr:UIAttachmentBehavior = spring as! UIAttachmentBehavior
                    
                    spr.damping = springDamping!;
                }
            }
            
        }
    }
    
    var springFrequency:CGFloat? {
        didSet{
            
            if springFrequency! >= CGFloat(0) && oldValue != springFrequency {
                
                for spring:UIDynamicBehavior in (self.animator?.behaviors)! {
                    
                    let spr:UIAttachmentBehavior = spring as! UIAttachmentBehavior
                    
                    spr.frequency = springDamping! * 5;
                }
            }
            
        }
    }
    
    var resistanceFactor:CGFloat? {
        didSet{
            
        }
    }
    
    
    override func prepare() {
        super.prepare()
        
        itemSize = CGSize(width: (collectionView?.bounds.size.width)!, height: 100)
        
        minimumLineSpacing = 30
        
        if animator == nil {
            animator = UIDynamicAnimator(collectionViewLayout: self)
            
            let contentSize:CGSize = collectionViewContentSize
            
            let items = super.layoutAttributesForElements(in: CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
            
            if let items1 = items {
                
                for item:UICollectionViewLayoutAttributes in items1 {
                    
                    let spring:UIAttachmentBehavior = UIAttachmentBehavior.init(item: item, attachedToAnchor: item.center)
                    
                    collision.addItem(item)
                    
                    spring.length = 0
                    spring.damping = springDamping!
                    spring.frequency = springFrequency!
                    
                    animator?.addBehavior(spring)
                    
                }
            }
            
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return animator?.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator?.layoutAttributesForCell(at:indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        //在上一次的基础上运动了多少
        let scrollDelta:CGFloat = newBounds.origin.y - (collectionView?.bounds.origin.y)!
        
        //拖动点
        let touchLocation:CGPoint = (collectionView?.panGestureRecognizer.location(in: collectionView))!
        
        //遍历所有的cell
        for attachmentBehavior:UIDynamicBehavior in (animator?.behaviors)! {
            
            let springBehavior:UIAttachmentBehavior = attachmentBehavior as! UIAttachmentBehavior
            
            
            //cell的锚点
            let anchorPoint:CGPoint = springBehavior.anchorPoint
            
            //锚点与拖拽点的距离
            let distanceFromTouch:CGFloat = CGFloat(fabsf(Float(touchLocation.y - anchorPoint.y)))
            
            //设置一个比例
            let scrollResistance:CGFloat = distanceFromTouch / resistanceFactor!
            
            //获取到对应的cell
            let item:UICollectionViewLayoutAttributes = springBehavior.items.first as! UICollectionViewLayoutAttributes
            
            let min:CGFloat = scrollDelta > scrollDelta * scrollResistance ? scrollDelta * scrollResistance : scrollDelta
            
            let max:CGFloat = scrollDelta < scrollDelta * scrollResistance ? scrollDelta * scrollResistance : scrollDelta
            
            //修改y值
            item.center.y += scrollDelta > 0 ? min : max
            
            //刷新动画
            animator?.updateItem(usingCurrentState: item)
            
        }
        
        return false
       
    }

}












