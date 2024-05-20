//
//  ViewController.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 26/4/24.
//

import UIKit

class ViewController: UIViewController, PlayingCardObserver {
    var deck = PlayingDeck()
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = PlayingCardAnimator(animator: animator)
    
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
//                cards match
                playingCards.filter { $0.faceUp }.forEach { cardView in
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75, delay: 0, options: [], animations: {
                        cardView.transform = CGAffineTransform.identity.scaledBy(x: 1.7, y: 1.7)
                    }, completion: { _ in
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75, delay: 0, options: [], animations: {
                            cardView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                            cardView.alpha = 0
                        }, completion: { _ in
                            cardView.matched = true
                            cardView.faceUp = false
                            // just clearing up the changes, optional code
                            cardView.transform = CGAffineTransform.identity
                            cardView.alpha = 1
                        })
                    })
                }
            } else {
//                cards do not match
                playingCards.filter { $0.faceUp }.forEach { cardView in
                    UIView.transition(with: cardView, duration: 1.8, options: [.transitionCrossDissolve], animations: {
                        cardView.faceUp = false
                    }, completion: { _ in
//                        TODO: not working, need to check why
                        self.cardBehavior.addPushBehavior(cardView)
                    })
                }
            }
        }
    }
}

