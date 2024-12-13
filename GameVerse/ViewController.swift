//
//  ViewController.swift
//  Gameverse
//
//  Created by Benitha Sri Panchagiri on 11/21/24.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackgroundImage()
    }
    
    /// Sets the background image for the view
    func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "myimg2")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0) // Ensures the background is behind all other UI elements
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transition = segue.identifier
        let destination = segue.destination
        
        if transition == "startSegue" {
            if let menuVC = destination as? MenuViewController {
                menuVC.name = userName.text ?? "" // Pass the user name
            }
        }
       
    }


}

