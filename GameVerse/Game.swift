import Foundation
import UIKit

struct Game {
    let image: UIImage
    var description: String
    var latestScore: Int
    var bestScore: Int
    let name: String
}

let games = [
    Game(
        image: UIImage(named: "trivia_game") ?? UIImage(), // Provide a default placeholder image
        description: "Welcome to the Trivia Game! Test your knowledge with a variety of fun and challenging questions. Can you guess the correct answers and score high? Ready to play and learn? Let's get started! 😉",
        latestScore: 0,
        bestScore: 0,
        name: "Trivia"
    ),
    Game(
        image: UIImage(named: "word_scramble") ?? UIImage(), // Provide a default placeholder image
        description: "Welcome to Scramble Words! In this game, you'll be given a scrambled version of a word. Your task is to unscramble the letters and type the correct word in the input field. You can click on the Hint button if you need help. You'll have a limited time to guess as many words as you can, so be quick! Enjoy the challenge and have fun! 🎉",
        latestScore: 0,
        bestScore: 0,
        name: "Scramble Words"
    )
]
