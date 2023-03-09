import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func setup()
    func show(quiz step: QuizStepViewModel)
    func showAnswerResult(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
} 
