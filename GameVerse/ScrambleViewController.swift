//
//  ScrambleViewController.swift
//  Gameverse
//
//  Created by Benitha Sri Panchagiri on 11/21/24.
//

import UIKit
import AVFoundation


    
    class ScrambleViewController: UIViewController {
        
        @IBOutlet weak var hintButton: UIButton!
        
        @IBOutlet weak var scrambledWordLabel: UILabel!
        
        
        @IBOutlet weak var hintLabel: UILabel!
        
        @IBOutlet weak var userInputTextField: UITextField!
        
        @IBOutlet weak var submitButton: UIButton!
        
        @IBOutlet weak var timerLabel: UILabel!
        
        @IBOutlet weak var stopButtonTapped: UIButton!
        
        @IBOutlet weak var scoreBtn: UIButton!
        
        
        @IBOutlet weak var gameStart: UIButton!
        
        var wordsAndHints = [
            "apple": "A popular fruit, often red or green, and commonly used in pies.",
            "banana": "A long yellow fruit, often peeled and eaten as a snack.",
            "grape": "A small, round fruit that comes in bunches, often used to make wine.",
            "cherry": "A small, red fruit, often used in pies or on top of desserts.",
            "orange": "A citrus fruit that is orange in color, rich in vitamin C.",
            "kiwi": "A small, brown, fuzzy fruit with bright green flesh inside.",
            "mango": "A tropical fruit, often orange or yellow, and known for its sweet taste.",
            "pear": "A sweet fruit with a round bottom and narrow top, often green or yellow.",
            "peach": "A juicy, sweet fruit with a fuzzy skin, typically orange or yellow.",
            "strawberry": "A small red fruit, often heart-shaped and sweet with tiny seeds on the surface.",
            "elephant": "A large gray animal with big ears and a long trunk, found in Africa and Asia.",
            "giraffe": "A tall animal with a long neck and spots, often seen in Africa.",
            "tiger": "A large wild cat known for its orange fur with black stripes.",
            "panda": "A black-and-white bear, native to China, and famous for eating bamboo.",
            "dolphin": "A friendly sea mammal known for its intelligence and acrobatic abilities.",
            "whale": "A large sea mammal, known for its size and often migrates long distances.",
            "carrot": "A long, orange vegetable that grows underground and is rich in vitamins.",
            "spinach": "A leafy green vegetable, often used in salads and known for being healthy.",
            "broccoli": "A green vegetable that looks like a small tree and is high in nutrients.",
            "tomato": "A red, round fruit often used in salads, sauces, and cooking."
        ]
        
        var usedWords: Set<String> = [] // To track words that have been used
        var currentWord: String!
        var scrambledWord: String!
        var hintText: String!
        var score = 0
        var timeLeft = 10 // Timer set to 90 seconds
        var timer: Timer?
        //var gameWonPlayer: AVAudioPlayer?
        var gameStarted = false
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            configureUI()
            setBackgroundImage()
            hintButton.isEnabled = false
        }
        
        
        func configureUI() {
                hintLabel.isHidden = true
                timerLabel.text = "Time Left: 0"
                userInputTextField.isEnabled = false
                submitButton.isEnabled = false
                stopButtonTapped.isEnabled = false
                
                gameStart.addTarget(self, action: #selector(startGame), for: .touchUpInside)
            }

        
        func startNewGame() {
            let unusedWords = wordsAndHints.keys.filter { !usedWords.contains($0) }
            if unusedWords.isEmpty {
                endGame() // If all words are used, end the game
                return
            }
            
            // Pick a random word from the unused words
            currentWord = unusedWords.randomElement()
            
            // Mark the word as used
            usedWords.insert(currentWord)
            
            // Scramble the word
            scrambledWord = scrambleWord(currentWord)
            
            // Set the image related to the word (ensure the images are named accordingly)
            
            
            // Set the hint text
            hintText = wordsAndHints[currentWord]
            
            // Update UI
            scrambledWordLabel.text = scrambledWord
            hintLabel.text = hintText
            hintLabel.isHidden = true // Initially hidden
            userInputTextField.text = ""
            
        }
        
        func scrambleWord(_ word: String) -> String {
            return String(word.shuffled())
            
        }
        
        func setBackgroundImage() {
            let backgroundImageView = UIImageView()
            backgroundImageView.image = UIImage(named: "scrambleBG")
            backgroundImageView.contentMode = .scaleAspectFit
            backgroundImageView.alpha = 0.5
            backgroundImageView.isUserInteractionEnabled = false // Allow buttons to receive touch events
            
            // Set constraints for centering the image
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(backgroundImageView)
            
            NSLayoutConstraint.activate([
                backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
            ])
        }
        
        
        @IBAction func submitButtonTapped(_ sender: Any) {
            guard let userInput = userInputTextField.text else {
                showAlert(title: "Error", message: "Please enter your guess.")
                return
            }
            
            if userInput.lowercased() == currentWord.lowercased() {
                score += 10
                cardFlipAnimation()
                startNewGame()
            } else {
                wiggleAnimation()
            }
            
        }
        
        
        
        @IBAction func stopBtn(_ sender: Any) {
            timer?.invalidate()
            
            // Dim the background and show "Game Stopped" overlay
            let overlay = UIView(frame: view.bounds)
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            overlay.alpha = 0
            let label = UILabel()
            label.text = "Game Stopped"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            overlay.addSubview(label)
            label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
            
            view.addSubview(overlay)
            
            UIView.animate(withDuration: 0.5, animations: {
                overlay.alpha = 1
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    overlay.removeFromSuperview()
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        
        @IBAction func hintButtonTapped(_ sender: Any) {
            hintLabel.isHidden = false
            hintLabel.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.hintLabel.alpha = 1.0
            }
        }
        
        
        @IBAction func startGame(_ sender: Any) {
            if !gameStarted {
                       gameStarted = true
                       timeLeft = 10
                       userInputTextField.isEnabled = true
                       submitButton.isEnabled = true
                       stopButtonTapped.isEnabled = true
                hintButton.isEnabled = true
                       startTimer()
                       startNewGame()
                   }
        }
        

        
        func wiggleAnimation() {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.values = [-10, 10, -10, 10]
            animation.duration = 0.5
            animation.repeatCount = 1
            userInputTextField.layer.add(animation, forKey: "wiggle")
        }
        
        
        
        
        
        func cardFlipAnimation() {
            UIView.transition(with: scrambledWordLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                self.scrambledWordLabel.isHidden = true
                self.scrambledWordLabel.isHidden = false
            })
        }
        
        
        
        @objc func updateTimer() {
            if timeLeft > 0 {
                timeLeft -= 1
                updateTimerLabel()
            } else {
                timer?.invalidate() // Stop the timer when time runs out
                endGame() // End the game when time runs out
            }
        }
        
        func animateLabelChange(label: UILabel, newText: String, color: UIColor) {
            UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve, animations: {
                label.textColor = color
                label.text = newText
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        label.textColor = .black
                        label.text = self.scrambledWord
                    })
                }
            }
        }
        
        
        
        @IBAction func stopButtonTapped(_ sender: Any) {
            timer?.invalidate() // Stop the timer
            showEndGameOverlay(message: "Game Stopped", isGameWon: false)
        }
        
        
        // Show alert helper
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
        func startTimer() {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        
        func updateTimerLabel() {
            timerLabel.text = "Time Left: \(timeLeft) seconds"
        }
        
        func animateWin() {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = .identity
                })
            }
        }
        
        func emojiToImage(emoji: String) -> UIImage? {
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            emoji.draw(in: CGRect(origin: .zero, size: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        func endGame() {
            showDarkOverlay()
            displayConfetti {
                self.showEndGameOverlay(message: "You Won!🏆", isGameWon: true)
            }
        }
        
        func showDarkOverlay() {
            let overlayView = UIView(frame: view.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            overlayView.alpha = 0
            view.addSubview(overlayView)
            
            UIView.animate(withDuration: 0.5) {
                overlayView.alpha = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                UIView.animate(withDuration: 0.5, animations: {
                    overlayView.alpha = 0
                }, completion: { _ in
                    overlayView.removeFromSuperview()
                })
            }
        }
        
        func showEndGameOverlay(message: String, isGameWon: Bool) {
            // Create the overlay view
            let overlayView = UIView(frame: view.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            overlayView.alpha = 0
            view.addSubview(overlayView)
            
            // Animate the overlay appearance
            UIView.animate(withDuration: 0.5) {
                overlayView.alpha = 1
            }
            
            // Create the message label
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textColor = .white
            messageLabel.font = UIFont.boldSystemFont(ofSize: 30)
            messageLabel.textAlignment = .center
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(messageLabel)
            
            // Center the label on the overlay
            NSLayoutConstraint.activate([
                messageLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
                messageLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
            ])
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                UIView.animate(withDuration: 0.5, animations: {
                    overlayView.alpha = 0
                }, completion: { _ in
                    overlayView.removeFromSuperview()
                })
            }
        }
        
        
        
        func displayConfetti(completion: @escaping () -> Void) {
            let confettiLayer = CAEmitterLayer()
            confettiLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: -50)
            confettiLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
            confettiLayer.emitterShape = .line
            
            let emojis = ["🎉", "🎊", "✨", "💥", "💫"]
            var cells: [CAEmitterCell] = []
            
            for emoji in emojis {
                guard let emojiImage = emojiToImage(emoji: emoji) else { continue }
                
                let cell = CAEmitterCell()
                cell.contents = emojiImage.cgImage
                cell.birthRate = 20 // Increased number of particles
                cell.lifetime = 4.0 // Extended lifetime for a longer effect
                cell.velocity = CGFloat.random(in: 150...400)
                cell.velocityRange = 150
                cell.scale = 0.35
                cell.emissionRange = CGFloat.pi
                cells.append(cell)
            }
            
            confettiLayer.emitterCells = cells
            view.layer.addSublayer(confettiLayer)
            
            // Extend the confetti effect
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                confettiLayer.removeFromSuperlayer()
                completion()
            }
        }
        
        
        
        func resetGame() {
            usedWords.removeAll()
            timeLeft = 60 // Reset timer to 60 seconds
            startNewGame()
            startTimer()
        }
        
        
    }


