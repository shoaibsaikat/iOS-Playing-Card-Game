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
    
    func addPushBehavior(_ view: PlayingCardView) {
        let push = UIPushBehavior(items: [], mode: .instantaneous)
        push.magnitude = 1.0 + CGFloat(3.0).arc4random
        push.angle = (2 * CGFloat.pi).arc4random
        push.addItem(view)
        addChildBehavior(push)
        push.action = {
            self.removePushBehavior(push, from: view)
        }
    }
    
    func removePushBehavior(_ push:UIPushBehavior, from view: PlayingCardView) {
        push.removeItem(view)
        removeChildBehavior(push)
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

extension CGFloat {
    var arc4random: CGFloat {
        if (self >= 0) {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        }
    }
}
