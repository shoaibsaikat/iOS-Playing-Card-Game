//
//  ViewController.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 26/4/24.
//

import UIKit

class ViewController: UIViewController, PlayingCardObserver {
    var deck = PlayingDeck()
    
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
        }
    }

    func cardFlipped() {
        let faceUpCards = playingCards.filter {
            $0.faceUp
        }
        if faceUpCards.count > 1 {
            playingCards.forEach { cardView in
                if cardView.faceUp && !cardView.matched {
                    UIView.transition(with: cardView, duration: 1.8, options: [.transitionCrossDissolve], animations: {
                        cardView.faceUp = false
                    })
                }
            }
        }
    }
}

