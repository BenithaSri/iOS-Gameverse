//
//  GameCollectionViewCell.swift
//  Gameverse
//
//  Created by Benitha Sri Panchagiri on 12/1/24.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    func assignGame(with game: Game) {
        imageView.image = game.image
        print("Image set to: \(String(describing: imageView.image))")
    }
    
}
