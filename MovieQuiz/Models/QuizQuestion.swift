import Foundation

struct QuizQuestion {
    let image: Data
    let question = "Рейтинг этого фильма больше чем \(Int.random(in: 5...9))?"
    let correctAnswer: Bool
}
