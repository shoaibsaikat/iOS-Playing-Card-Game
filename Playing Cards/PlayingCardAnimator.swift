//
//  PlayingCardAnimator.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 19/5/24.
//

import UIKit

class PlayingCardAnimator: UIDynamicBehavior {
    var collision: UICollisionBehavior = {
        let collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        return collision
    }()
    var push: UIPushBehavior = {
        return UIPushBehavior(items: [], mode: .instantaneous)
    }()
    var property: UIDynamicItemBehavior = {
        let property = UIDynamicItemBehavior()
        property.elasticity = 1.0
        property.allowsRotation = false
        property.resistance = 0
        return property
    }()
    
    func addPushBehavior(_ view: PlayingCardView) {
        push.addItem(view)
        push.magnitude = 1.0 + CGFloat.random(in: 1 ... 2)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (view.center.x, view.center.y) {
            case let (x, y) where x < center.x && y < center.y: push.angle = CGFloat.random(in: 0 ... CGFloat.pi / 2)
            case let (x, y) where x > center.x && y < center.y: push.angle = CGFloat.pi - CGFloat.random(in: 0 ... CGFloat.pi / 2)
            case let (x, y) where x < center.x && y > center.y: push.angle = CGFloat.random(in: -CGFloat.pi / 2 ... 0)
            case let (x, y) where x > center.x && y > center.y: push.angle = CGFloat.pi + CGFloat.random(in: 0 ... CGFloat.pi / 2)
            default: push.angle = 2 * CGFloat.pi
            }
        }
        self.addChildBehavior(push)
        push.action = {
            self.removePushBehavior(view)
        }
    }
    
    func removePushBehavior(_ view: PlayingCardView) {
        self.push.removeItem(view)
        self.removeChildBehavior(self.push)
    }
    
    func addOtherBehavior(_ view: PlayingCardView) {
        addCollisionBehavior(view)
        addDynamicBehavior(view)
    }
    
    func removeOtherBehavior(_ view: PlayingCardView) {
        removeCollisionBehavior(view)
        removeDynamicBehavior(view)
    }
    
    private func addCollisionBehavior(_ view: PlayingCardView) {
        collision.addItem(view)
        self.addChildBehavior(collision)
    }
    
    private func removeCollisionBehavior(_ view: PlayingCardView) {
        collision.removeItem(view)
        self.removeChildBehavior(collision)
    }
    
    private func addDynamicBehavior(_ view: PlayingCardView) {
        property.addItem(view)
        self.addChildBehavior(property)
    }
    
    private func removeDynamicBehavior(_ view: PlayingCardView) {
        property.removeItem(view)
        self.removeChildBehavior(property)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
