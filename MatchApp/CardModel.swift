//
//  CardModel.swift
//  MatchApp
//
//  Created by Brian Dilts on 5/7/21.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an empty array to store cards
        var generatedCards = [Card]()
        
        // Empty array to check for dupes
        var c = [Int]()
        // randomly generate 8 pairs of cards
        while c.count < 8 {
            
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            // Create two new card object
            let cardOne = Card()
            let cardTwo = Card()
            
            //Check that number is unique
            if c.contains(randomNumber) == false {
                c.append(randomNumber)
                
                // Set image names if randomNumber is unique
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                // Add unique cards to the array
                generatedCards += [cardOne, cardTwo]
                
                print("unique random number generated: \(randomNumber)")
                
            }else {
                print("this number is not unique, loop back through and find unique card")
            }
           print(c)
        }
        
        // Randomize the cards in the array
        generatedCards.shuffle()
        
        // Return the array
        return generatedCards
        
    }
    
}

