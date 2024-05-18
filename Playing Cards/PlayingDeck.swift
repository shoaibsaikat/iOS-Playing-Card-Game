//
//  PlayingDeck.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 26/4/24.
//

import Foundation

struct PlayingDeck {
    private(set) var cards = [PlayingCard]()
    
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func drawCardPair() -> [PlayingCard]? {
        if cards.count > 1 {
            var index = 0
            var resultCards = [PlayingCard]()
            resultCards.append(cards.remove(at: cards.count.arc4random))
            for card in cards {
                if card.rank.order == resultCards[0].rank.order {
                    resultCards.append(cards.remove(at: index))
                    return resultCards
                }
                index = index + 1
            }
        }
        return nil
    }
}

extension Int {
    var arc4random: Int {
        if (abs(self) > 0) {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return self
        }
    }
}
