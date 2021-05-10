//
//  ViewController.swift
//  MatchApp
//
//  Created by Brian Dilts on 5/7/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Int = 30 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // Set the ViewController as the datasource and the delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Init the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Play the shuffle sound
        soundPlayer.playSound(effect: .shuffle)
        
    }
    
    //MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the time if it reaches zero
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            //Check if the user has cleared the pairs
            checkforGameEnd()
        }
        
        // check if the user has cleared all the pairs
        
    }

    //MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the card it represents
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card from the card array
        let selectedCard = cardsArray[indexPath.row]
        
        //Finishing configuring cell
        cardCell?.configureCell(card: selectedCard)
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get a reference to this cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // Flip the card up
            cell?.flipUp()
            
            // Play sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if this was the first card flipped or second
            if firstFlippedCardIndex == nil {
                // This is the first cad flipped over
                firstFlippedCardIndex = indexPath
                
            }else {
                // This is the second card flipped over
                
                // Run the comparison logic
                checkForMatch(indexPath)
            }
        }
        
    }
    
    //MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent card 1 and 2
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        if cardOne.imageName == cardTwo.imageName {
            // It is a match!
            // Play sound
            soundPlayer.playSound(effect: .match)
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // was that the last pair?
            checkforGameEnd()
            
        }else {
            // Not a match
            // Play sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        //Resset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
        
    }
    
    func checkforGameEnd() {
        
        // Check if there is any card that is unmatched
        // Assume the user has won, loop through and see if all pairs are found
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
               // We found a card that is unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            // User has won
            showAlert(title: "Congradulations!", message: "You've won the game!")
        }else {
            // User has not won yet, check if there's any time left
            if milliseconds <= 0 {
                showAlert(title: "Times up!", message: "Better luck next time!")
            }
        }
        
    }
    
    func showAlert(title:String, message:String) {
        
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button for the user to dismiss it
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        // Show the alert
        present(alert, animated: true, completion: nil)
        
    }
    

}

