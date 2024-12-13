//
//  MenuViewController.swift
//  Gameverse
//
//  Created by Benitha Sri Panchagiri on 11/23/24.
//

import UIKit
//import FirebaseDatabaseInternal
//import FirebaseCore
//import FirebaseAuth

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewOL.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) as! GameCollectionViewCell
                
                let game = games[indexPath.row]
        
        print("Game image for row \(indexPath.row): \(String(describing: game.image))")
        
                cell.assignGame(with: game)
        
                
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        
        // Update description label
        descriptionOL.text = selectedGame.description
        
        // Enable the correct game button and hide the other
        switch indexPath.row {
        case 0: // Trivia game
            scrambledBtn.isHidden = true
            triviaBtn.isHidden = false
            triviaBtn.isEnabled = true
        case 1: // Scramble game
            triviaBtn.isHidden = true
            scrambledBtn.isHidden = false
            scrambledBtn.isEnabled = true
        default:
            break
        }
    }

    
    
    //outlets
    @IBOutlet weak var greetingOL: UILabel!
  
    @IBOutlet weak var descriptionOL: UILabel!
    
    @IBOutlet weak var scrambledBtn: UIButton!
    
    @IBOutlet weak var triviaBtn: UIButton!
    
    @IBOutlet weak var collectionViewOL: UICollectionView!
    
    
//    @IBAction func scoreButton(_ sender: Any) {
//        
//        guard let selectedIndexPath = collectionViewOL.indexPathsForSelectedItems?.first else {
//                print("No game selected")
//                return
//            }
//            
//            let selectedGame = games[selectedIndexPath.row]
//            performSegue(withIdentifier: "scoreSegue", sender: selectedGame)
//    }
//    
      
        var name = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionViewOL.delegate = self
        collectionViewOL.dataSource = self
        
        // Initially disable both game buttons
        scrambledBtn.isHidden = true
        triviaBtn.isHidden = true
        
        greetingOL.text = "Hello, \(name)!. Welcome to the Gameverse"
        setBackgroundImage()
       
    }
    
    
    /// Sets the background image for the view
    func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "myimage4")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0) // Ensures the background is behind all other UI elements
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transition = segue.identifier
        let destination = segue.destination
        
        if transition == "scrambledSegue" {
            destination as! ScrambleViewController
            
        }
        
        if transition == "triviaSegue" {
            destination as! TriviaViewController
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
