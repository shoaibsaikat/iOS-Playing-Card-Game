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
    lazy var cardBehavior       = PlayingCardBehavior(in: animator)
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
            cardBehavior.addItem(view: cardView)
        }
    }

    func cardFlipped() {
        let faceUpCards = playingCards.filter { $0.faceUp }
        if faceUpCards.count > 1 {
            if faceUpCards[0].rank == faceUpCards[1].rank {
                // cards matched
                faceUpCards.filter { $0.faceUp }.forEach { cardView in
                    // remove behavior if cards matched, this also fixes scale animation issue
                    removeBehavior(view: cardView)
                    cardView.matched = true
                    cardView.faceUp = false
                }
            } else {
                // cards did not
                faceUpCards.filter { $0.faceUp }.forEach { cardView in
                    cardView.faceUp = false
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
    
    func removeBehavior(view: UIView) {
        cardBehavior.removeItem(view: view)
    }
}

