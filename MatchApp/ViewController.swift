//
//  ViewController.swift
//  MatchApp
//
//  Created by Brian Dilts on 5/7/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // Set the ViewController as the datasource and the delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    //MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card from the card array
        let selectedCard = cardsArray[indexPath.row]
        
        //Finishing configuring cell
        cell.configureCell(card: selectedCard)
        
        // Return it
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get a reference to this cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false {
            
            // Flip the card up
            cell?.flipUp()
            
            // Check if this was the first card flipped or second
            if firstFlippedCardIndex == nil {
                // This is the first cad flipped over
                firstFlippedCardIndex = indexPath
                
            }else {
                // This is the second card flipped over
                
                // Run the comparison logic
            }
        }
        
    }
    
    //MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName {
            // It is a match!
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            
        }else {
            
            // Not a match, flip them back over
        }
        
        //Resset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
        
    }
    

}

