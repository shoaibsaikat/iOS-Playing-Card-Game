//
//  PlayingCard.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 26/4/24.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    var description: String {
        return "\(suit)\(rank)"
    }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        var description: String {
            return self.rawValue
        }
        
        case spades = "♠️"
        case hearts = "❤️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static var all = [Suit.spades, .hearts, .clubs, .diamonds]
    }
    
    enum Rank: CustomStringConvertible {
        var description: String {
            return "\(order)"
        }
        
        case ace
        case number(Int)
        case face(String)
        
        var order: Int {
            switch self {
            case .ace:                          return 1
            case .number(let x):                return x
            case .face(let x) where x == "j":   return 11
            case .face(let x) where x == "q":   return 12
            case .face(let x) where x == "k":   return 13
            default:
                                                return 0
            }
        }
        
        static var all: [Rank] {
            var ranks = [Rank.ace]
            for pips in 2...10 {
                ranks.append(Rank.number(pips))
            }
            ranks += [Rank.face("j"), .face("q"), .face("k")]
            return ranks
        }
    }
}
