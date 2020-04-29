//
//  CardCollectionCell.swift
//  MemoryMatchingGame
//
//  Created by 朱继卿 on 2020-04-27.
//  Copyright © 2020 verus. All rights reserved.
//

import UIKit

class CardCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    
    var imageId = 0
    var shown = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.image = UIImage(named: "cardBg.png")
        
        contentImageView.isHidden = true
    }
    
    func showCard(_ show: Bool, animted: Bool) {
        contentImageView.isHidden = false
        imageView.isHidden = false
        shown = show
        if animted {
            if show {
                UIView.transition(
                    from: imageView,
                    to: contentImageView,
                    duration: 0.5,
                    options: [.transitionFlipFromRight, .showHideTransitionViews],
                    completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transition(
                    from: contentImageView,
                    to: imageView,
                    duration: 0.5,
                    options: [.transitionFlipFromRight, .showHideTransitionViews],
                    completion:  { (finished: Bool) -> () in
                })
            }
        } else {
            if show {
                bringSubviewToFront(contentImageView)
                imageView.isHidden = true
            } else {
                bringSubviewToFront(imageView)
                contentImageView.isHidden = true
            }
        }
    }

}
