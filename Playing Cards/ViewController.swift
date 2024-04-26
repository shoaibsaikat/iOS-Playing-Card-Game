//
//  ViewController.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 26/4/24.
//

import UIKit

class ViewController: UIViewController {
    var deck = PlayingDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...25 {
            print("\(deck.draw()!)")
        }
    }


}

