//
//  ViewController.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 26/4/24.
//

import UIKit

class ViewController: UIViewController, PlayingCardObserver {
    var deck                    = PlayingDeck()
    lazy var animator           = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior       = PlayingCardBehavior(animator: animator)
    var runningAnimtationCount  = 0
    
    @IBOutlet var playingCards: [PlayingCardView]! {
        didSet {
            for card in playingCards {
//                let swipe = UISwipeGestureRecognizer(target: self, action: #selector(traverseCard))
//                swipe.direction = [.left, .right]
//                playingCardView.addGestureRecognizer(swipe)
                
//                let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.cardImageScalling(byPinch:)))
//                playingCardView.addGestureRecognizer(pinch)

                card.addGestureRecognizer(UITapGestureRecognizer(target: card, action: #selector(card.flipCard(_:))))
                card.setController(self)
            }
        }
    }

//    @objc func traverseCard() {
//        if playingCardView.faceUp, let card = deck.draw() {
//            playingCardView.rank = card.rank.order
//            playingCardView.suit = card.suit.rawValue
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = deck.drawCardPair()
        for cardView in playingCards {
            if cards == nil || (cards?.isEmpty)! {
                cards = deck.drawCardPair()
            }
            if let card = cards?.removeLast() {
                cardView.playingCardView(rank: card.rank.order, suit: card.suit.rawValue)
            } else {
                cardView.playingCardView(rank: 0, suit: "?")
            }
            cardBehavior.addOtherBehavior(cardView)
            cardBehavior.addPushBehavior(cardView)
        }
    }

    func cardFlipped() {
        let faceUpCards = playingCards.filter { $0.faceUp }
        if faceUpCards.count > 1 {
            if faceUpCards[0].rank == faceUpCards[1].rank {
                // cards matched
                faceUpCards.filter { $0.faceUp }.forEach { cardView in
                    cardView.matched = true
                    cardView.faceUp = false
                }
            } else {
                // cards did not
                faceUpCards.filter { $0.faceUp }.forEach { cardView in
                    cardView.faceUp = false
                    // below does not work if done from view, need to check why?
                    cardBehavior.addPushBehavior(cardView)
                }
            }
        }
    }
    
    func animationStarted() {
        // lock?
        runningAnimtationCount = runningAnimtationCount + 1
    }
    
    func animationFinished() {
        // unlock?
        if runningAnimtationCount > 0 {
            runningAnimtationCount = runningAnimtationCount - 1
        }
    }
    
    func isAnimationRunning() -> Bool {
        return runningAnimtationCount > 0 ? true : false
    }
}

