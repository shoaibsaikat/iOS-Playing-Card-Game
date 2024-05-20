//
//  PlayingCardAnimator.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 19/5/24.
//

import UIKit

class PlayingCardAnimator: UIDynamicBehavior {
    
    lazy var animator: UIDynamicAnimator? = nil
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
        return property
    }()
    
    func addPushBehavior(view: PlayingCardView) {
        push.addItem(view)
        push.magnitude = 1.0 + CGFloat.random(in: 2 ... 3)
        push.angle = CGFloat.random(in: 0 ... 2 * CGFloat.pi)
        self.addChildBehavior(push)
        push.action = {
            self.removeChildBehavior(self.push)
        }
    }
    
    func addCollisionBehavior(view: PlayingCardView) {
        collision.addItem(view)
        self.addChildBehavior(collision)
    }
    
    func addDynamicBehavior(view: PlayingCardView) {
        property.addItem(view)
        self.addChildBehavior(property)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(animator: UIDynamicAnimator) {
        self.init()
        self.animator = animator
        self.animator?.addBehavior(self)
    }
}
