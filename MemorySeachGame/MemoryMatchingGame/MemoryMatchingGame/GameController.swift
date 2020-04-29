//
//  GameController.swift
//  MemoryMatchingGame
//
//  Created by 朱继卿 on 2020-04-27.
//  Copyright © 2020 verus. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CardCollectionCell"

class GameController: UIViewController {
    var rows = 0
    var columns = 0
    var matchNumber = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var player1ScoreLb: UILabel!
    @IBOutlet weak var player2ScoreLb: UILabel!
    @IBOutlet weak var turnLb: UILabel!
    private var cards:[Card] = []
    private var buffer:[CardCollectionCell] = []
    private var player1Score = 0
    private var player2Score = 0
    
    private var cardsRemain = 0 {
        didSet {
            if (self.cardsRemain == 0) {
                self.didWinGame()
            }
        }
    }
    
    private var turn = 1 {
        didSet {
            self.turnLb.text = "The turn of player #\(self.turn)"
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        cards = setupData()
        setupView(cards: cards)
    }

    func setupView(cards: [Card]) {
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let width = (collectionView.frame.width - (CGFloat(columns) - 1) * 16) / CGFloat(columns) // get the width for every cell
        let height = width / 0.749 // get the height according to radio of image
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        
    }
    
    func setupData() -> [Card] {
        // using Codable to decode json data
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let loaclData = NSData.init(contentsOfFile: path!)! as Data
        let wrapper = try! JSONDecoder().decode(CardsWrapper.self, from: loaclData)// because we do not use real network requests, we can unwrapping forcedly
        
        print("*****\(wrapper.products?.count)")
        var randomCards: [Card] = []
        for card in wrapper.products! {
            if (randomCards.count >= rows * columns) {
                break
            }
            for _ in (0..<matchNumber) {
                randomCards.append(card)
            }
           
        }
//        Fisher–Yates shuffle Algorithm
        for (index, _) in randomCards.enumerated() {
            let random = Int.random(in: 0..<randomCards.count)
            randomCards.swapAt(random, index)
        }
        
        cardsRemain = randomCards.count
        
        return randomCards
    }
    
    func cardsMatching() {
        let id = buffer[0].imageId
        for cell in buffer {
            if (id != cell.imageId)  {// do no match
                let delayTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.recoverCards()
                }
                return
            }
        }
        // matching and get score
        buffer.removeAll()
        if (turn == 1) {
            player1Score += 10
            player1ScoreLb.text = "Player #1 score: \(player1Score)"
            turn = 2
        } else {
            player2Score += 10
            player2ScoreLb.text = "Player #2 score: \(player2Score)"
            turn = 1
        }
        cardsRemain -= matchNumber

    }
    
    func recoverCards() {
        for cell in buffer {
            cell.showCard(false, animted: true)
        }
        buffer.removeAll()
        
        turn = turn == 1 ? 2 : 1
    }

}

extension GameController {
    func didWinGame() {
        let confirmAction = UIAlertAction.init(title: "okay!", style: .`default`) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        var player = player1Score > player2Score ? "1" : "2"
        if (player2Score == player1Score) {
            player = "1 & 2"
        }
        
        let alertController = UIAlertController(title: "player #\(player) won the game!", message: "", preferredStyle: .alert)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension GameController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows * columns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CardCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCollectionCell
        
        let url = URL(string: cards[indexPath.row].image.src)
        let data = try? Data(contentsOf: url!)
        
        cell.contentImageView.image = UIImage(data: data!)
        cell.imageId = cards[indexPath.row].image.id

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: CardCollectionCell = collectionView.cellForItem(at: indexPath) as! CardCollectionCell
        guard !cell.shown else {
            return
        }
        cell.showCard(true, animted: true)

        buffer.append(cell)
        
        if (buffer.count == matchNumber) {
            cardsMatching()
        }
    }
}
