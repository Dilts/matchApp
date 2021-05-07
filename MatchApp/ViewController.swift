//
//  ViewController.swift
//  MatchApp
//
//  Created by Brian Dilts on 5/7/21.
//

import UIKit

class ViewController: UIViewController {

    let model = CardModel()
    var cardsArray = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
    }


}

