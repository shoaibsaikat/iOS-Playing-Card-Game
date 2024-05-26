//
//  PlayingCardAnimator.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 19/5/24.
//

import UIKit

class PlayingCardBehavior: UIDynamicBehavior {
    var collision: UICollisionBehavior = {
        let collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        return collision
    }()

    var property: UIDynamicItemBehavior = {
        let property = UIDynamicItemBehavior()
        property.elasticity = 1.0
        property.allowsRotation = false
        property.resistance = 0
        return property
    }()
    
    func push(_ view: UIView) {
        let push = UIPushBehavior(items: [], mode: .instantaneous)
//        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
//            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
//            switch (view.center.x, view.center.y) {
//            case let (x, y) where x < center.x && y < center.y: push.angle = (CGFloat.pi / 2).arc4random
//            case let (x, y) where x > center.x && y < center.y: push.angle = CGFloat.pi - (CGFloat.pi / 2).arc4random
//            case let (x, y) where x < center.x && y > center.y: push.angle = -(CGFloat.pi / 2).arc4random
//            case let (x, y) where x > center.x && y > center.y: push.angle = CGFloat.pi + (CGFloat.pi / 2).arc4random
//            default: push.angle = 2 * CGFloat.pi
//            }
//        }
        push.angle = (2 * CGFloat.pi).arc4random
        push.magnitude = 1.0 + CGFloat(2.0).arc4random
        push.addItem(view)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(view: UIView) {
        collision.addItem(view)
        property.addItem(view)
        push(view)
    }
    
    func removeItem(view: UIView) {
        collision.removeItem(view)
        property.removeItem(view)
    }
    
    override init() {
        super.init()
        addChildBehavior(collision)
        addChildBehavior(property)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        if (self >= 0) {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        }
    }
}
