//
//  ViewController.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 26/4/24.
//

import UIKit

class ViewController: UIViewController {
    var deck = PlayingDeck()
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(traverseCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.cardImageScalling(byPinch:)))
            playingCardView.addGestureRecognizer(pinch)
        }
    }
    
    @objc func traverseCard() {
        if playingCardView.faceUp, let card = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playingCardView.faceUp = !playingCardView.faceUp
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

