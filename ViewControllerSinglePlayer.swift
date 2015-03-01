//
//  ViewControllerSinglePlayer.swift
//  Black Jack Upgrade
//
//  Created by Yue Zhao on 2/27/15.
//  Copyright (c) 2015 Yue Zhao. All rights reserved.
//

import UIKit

class ViewControllerSinglePlayer: UIViewController {

    @IBOutlet weak var betInput: UITextField!
    @IBOutlet weak var betButton: UIButton!
    @IBOutlet weak var chipBalance: UILabel!
    @IBOutlet weak var Playercard1: UILabel!
    @IBOutlet weak var Playercard2: UILabel!
    @IBOutlet weak var Playercard3: UILabel!
    @IBOutlet weak var Playercard4: UILabel!
    @IBOutlet weak var Playercard5: UILabel!
    
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var playersum: UILabel!
    @IBOutlet weak var dealercard1: UILabel!
    @IBOutlet weak var dealercard2: UILabel!
    @IBOutlet weak var dealercard3: UILabel!
    @IBOutlet weak var dealercard4: UILabel!
    @IBOutlet weak var dealercard5: UILabel!
    @IBOutlet weak var dealersum: UILabel!
    
    @IBOutlet weak var retryButton: UIButton!
    
    var playerLabels:[UILabel] = []
    var dealerLabels:[UILabel] = []
    var blackjack: Game!
    var cntchip:Int = 100
    var numberOfDeckSize: Int = 1
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playerLabels += [Playercard1, Playercard2, Playercard3, Playercard4, Playercard5]
        dealerLabels += [dealercard1, dealercard2, dealercard3, dealercard4, dealercard5]
        blackjack = Game (deckSize: numberOfDeckSize, playerNumber: 1)
        getPlayerStats()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Bet(sender: UIButton) {
        cntchip -= betInput.text.toInt()!
        chipBalance.text = "\(cntchip)"
        
    }
    
    @IBAction func standButton(sender: UIButton) {
        blackjack.stand(0)
        getPlayerStats()
    }
    
    @IBAction func hitButton(sender: UIButton) {
        blackjack.hit(blackjack.currentPlayer)
        var current:Int = blackjack.players[0].checkSum().intSum
        if (current > 21) {
            for x in 0..<blackjack.players[0].cards.count {
                playerLabels[x].text = nil
            }
            blackjack.stand(blackjack.currentPlayer)
        }
        getPlayerStats()

    }
    
    @IBAction func retry(sender: UIButton) {
        retryButton.hidden = true
        hitButton.hidden = false
        standButton.hidden = false
        blackjack.players[0].stand = false
        //dealerLabels[0].hidden = true
        //dealerLabels.removeAll(keepCapacity: false)
        for i in 0..<2 {dealerLabels[i].text = " "}
        for i in 0..<5 {playerLabels[i].text = " "}
        
        blackjack.players[0].cards.removeAll(keepCapacity: false)
        blackjack.dealer.cards.removeAll(keepCapacity: false)
        
        //viewDidLoad()
        
        
        for k in 0..<2{blackjack.players[0].addCard(blackjack.catchCard(blackjack.currentDeck)!)}
        blackjack.dealer.addCard(blackjack.catchCard(blackjack.currentDeck)!)
        blackjack.dealer.addCard(blackjack.catchCard(blackjack.currentDeck)!)
        
        
        getPlayerStats()
    }
    
    
    func getPlayerStats (){
        var alreadystand = 0
        reload()
        dealersum.text = blackjack.dealer.checkSum("hidden").strSum    //
        if (blackjack.players[0].stand == true) {
            alreadystand += 1
        }
        
        if (alreadystand > 0) {
            dealerLabels[0].text = blackjack.dealer.cardShow()?.cd //??
            hitButton.hidden = true
            standButton.hidden = true
            while (blackjack.dealer.checkSum().intSum < 16) {
                blackjack.dealer.addCard(blackjack.catchCard(blackjack.currentDeck)!)
            }
            
            dealersum.text = blackjack.dealer.checkSum().strSum
            playersum.text = showScore(blackjack.players[0].checkSum().intSum, dealerScore: blackjack.dealer.checkSum().intSum)
            retryButton.hidden = false
        }
        chipBalance.text = "\(cntchip)"
        //var current : Int = cntchip - betInput.text.toInt()!
        //chipBalance.text = "\(current)"
        dealerLabels[0].hidden = true
        
    }
    
    
    func showScore(playerScore: Int, dealerScore: Int) -> String {
        
        if (playerScore > 21) {
            
            return ("Bust!")
            
        }
        
        if (dealerScore > 21) {
            dealerLabels[0].hidden = false
            cntchip += 2 * betInput.text.toInt()!
            return ("Dealer bust! You Win!")
        }
        
        if (playerScore == 21 && dealerScore != 21) {
            dealerLabels[0].hidden = false
            cntchip += 4 * betInput.text.toInt()!
            return ("😄Awesome! You got a Blak Jack!")
        }
        
        if (playerScore > dealerScore) {
            dealerLabels[0].hidden = false
            cntchip += 2 * betInput.text.toInt()!
            return ("You win!")
        }
        
        if (playerScore < dealerScore) {
            dealerLabels[0].hidden = false
            return ("Unluck😔")
        }
        cntchip += betInput.text.toInt()!
        dealerLabels[0].hidden = false
        return ("Push")
        
        
    }
    
    func reload() {
        for i in 0..<1 {
        for x in 0..<blackjack.players[i].cards.count {
            playerLabels[x].text = blackjack.players[i].cards[x].cd
            playersum.text = blackjack.players[i].checkSum().strSum
            
        }
        for y in 0..<blackjack.dealer.cards.count {
            dealerLabels[y].text = blackjack.dealer.cards[y].cd
        }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}