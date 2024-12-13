import UIKit

class TriviaViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var outputTextField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var stopTheGameButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
   // @IBOutlet weak var scoresButton: UIButton!
    
    // Game variables
       var availableIndices: [Int] = []
       var score = 0
       var currentQuestionIndex = 0
       var shuffledQuestions: [[String]] = []
       var timer: Timer?
       var timeLeft = 10
       var gameStarted = false
    
    
    
    // Question set
    let words = [
         ["Traditional dish made from dough of wheat flour mixed with water or eggs and formed into sheets or other shapes, then boiled or baked?", "Pasta", "Hint: A staple of Italian cuisine, often served with sauce.", "pasta"],
         ["What sweet treat is made from cocoa beans and often enjoyed in bars or desserts?", "Chocolate", "Hint: This treat is a favorite on Valentine's Day.", "chocolate"],
         ["What natural landform erupts with lava, ash, and gases from beneath the Earth's surface?", "Volcano", "Hint: It can create new land and is often associated with destruction.", "volcano"],
         ["What tool is used to determine direction, often showing north, south, east, and west?", "Compass", "Hint: Used by explorers and hikers to find their way.","compass"],
         ["What optical device allows us to observe distant objects, often used to view stars and planets?", "Telescope", "Hint: A device used to study the night sky and discover distant galaxies.", "telescope"],
         ["What is the largest planet in our solar system?", "Jupiter", "Hint: This gas giant is known for its Great Red Spot.",  "jupiter"],
         ["Which element has the chemical symbol O?", "Oxygen", "Hint: This element is essential for breathing and combustion.","oxygen"],
         ["In which country would you find the Great Wall?", "China", "Hint: This country is also known for its ancient culture and large population.", "china"],
         ["What is the capital city of France?", "Paris", "Hint: Known for its Eiffel Tower, this city is a hub for art and fashion.","paris"],
         ["Which country is known as the Land of the Rising Sun?", "Japan", "Hint: Known for its technology, anime, and sushi.",  "japan"],
         ["What is the smallest bone in the human body?", "Stapes", "Hint: This bone is located in the ear and plays a role in hearing.",  "stapes"],
         ["Which fruit is known for having its seeds on the outside?", "Strawberry", "Hint: This red berry is commonly used in desserts and jams.",  "strawberry"],
         ["What is the hardest natural substance on Earth?", "Diamond", "Hint: This precious gem is often used in jewelry and cutting tools.", "diamond"],
         ["Who painted the Mona Lisa?", "Leonardo da Vinci", "Hint: This artist was also a scientist and inventor during the Renaissance.", "leonardo"],
         ["What animal is known for its black and white stripes?", "Zebra", "Hint: This animal lives in Africa and is part of the horse family.",  "zebra"],
         ["What is the largest desert in the world?", "Sahara", "Hint: This desert is located in northern Africa and is known for its vast sand dunes.", "sahara"],
         ["Who was the first man to walk on the moon?", "Neil Armstrong", "Hint: He made his famous statement, 'That's one small step for man, one giant leap for mankind.'", "neil_armstrong"],
         ["What is the longest river in the world?", "Nile", "Hint: This river flows through northeastern Africa and was crucial to ancient Egyptian civilization.",  "nile"],
         ["What is the name of Harry Potter's pet owl?", "Hedwig", "Hint: This owl delivered letters and was very loyal to Harry Potter.", "hedwig"],
         ["What language is primarily spoken in Brazil?", "Portuguese", "Hint: It is the official language of Brazil, not Spanish.", "portuguese"],
         ["What is the name of the galaxy we live in?", "Milky Way", "Hint: This galaxy contains our solar system and is named after the pale band of light across the night sky.", "milky_way"],
         ["What is the capital of Australia?", "Canberra", "Hint: It is not Sydney or Melbourne, but located between them.",  "canberra"],
         ["What famous ship sank in 1912 after hitting an iceberg?", "Titanic", "Hint: This ship was considered 'unsinkable' but tragically sank on its maiden voyage.", "titanic"],
         ["Which bird is known for its colorful feathers and ability to mimic human speech?", "Parrot", "Hint: This bird is often kept as a pet and can imitate words and sounds.",  "parrot"]
     ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableIndices = Array(0..<words.count)
                shuffledQuestions = words.shuffled()
        setBackgroundImage()
                configureUI()
        hintButton.isEnabled = false
    }
    
    func setBackgroundImage() {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "triviaBG")
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

    
    func configureUI() {
            outputTextField.isEnabled = false
            guessButton.isEnabled = false
            hintButton.isEnabled = false
            stopTheGameButton.isEnabled = false
            timerLabel.text = "Time Left: 0"
        }
    
    
    func loadQuestion() {
            guard currentQuestionIndex < shuffledQuestions.count else {
                endGame()
                return
            }

            let currentQuestion = shuffledQuestions[currentQuestionIndex]
            questionLabel.text = currentQuestion[0]
            hintLabel.text = ""
            outputTextField.text = ""
            timerLabel.text = "Time Left: \(timeLeft)"
        }

    
    @IBAction func guessButtonTapped(_ sender: Any) {
        guard let userAnswer = outputTextField.text?.lowercased() else { return }
           let correctAnswer = shuffledQuestions[currentQuestionIndex][1].lowercased()

           if userAnswer == correctAnswer {
               score += 10
               cardFlipAnimation()
               loadNextQuestion()
               displayConfetti() // Show confetti only if the answer is correct
           } else {
               wiggleAnimation()
               showAlert(title: "Incorrect", message: "Try again.")
           }
    }
    
    @IBAction func hintButtonTapped(_ sender: Any) {
        hintLabel.text = shuffledQuestions[currentQuestionIndex][2]
                hintLabel.isHidden = false
    }
    
    @IBAction func stopGameButtonTapped(_ sender: Any) {
        timer?.invalidate()
                navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startGameButtonTapped(_ sender: Any) {
        if !gameStarted {
            gameStarted = true
            timeLeft = 10
            outputTextField.isEnabled = true
            guessButton.isEnabled = true
            stopTheGameButton.isEnabled = true
            startTimer()
            loadQuestion()
            hintButton.isEnabled = true
        }
    }
    
    
    func loadNextQuestion() {
            currentQuestionIndex += 1
            loadQuestion()
        }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1
            timerLabel.text = "Time Left: \(timeLeft) seconds"
        } else {
            timer?.invalidate()
            showAlert(title: "Time's Up!", message: "Your final score: \(score)")
            endGame()
        }
    }

    func endGame() {
        // Stop the timer
        timer?.invalidate()

        // Display confetti
        displayConfetti()

        // Show final score to the user
        showAlert(title: "Game Over!", message: "Your final score is \(score)")

        // Reset the game state to prepare for a new game
        resetGame()
    }

    
    
    func displayConfetti() {
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
           // completion()
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
    
    
    
    func resetGame() {
        gameStarted = false
        score = 0
        currentQuestionIndex = 0
        timeLeft = 10
        configureUI()
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Wiggle Animation when answer is incorrect
        func wiggleAnimation() {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.values = [-10, 10, -10, 10]
            animation.duration = 0.5
            animation.repeatCount = 1
            outputTextField.layer.add(animation, forKey: "wiggle")
        }

        // Card Flip Animation for correct answers
        func cardFlipAnimation() {
            UIView.transition(with: questionLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                self.questionLabel.isHidden = true
                self.questionLabel.isHidden = false
            })
        }
}
