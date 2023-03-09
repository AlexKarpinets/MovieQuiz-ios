import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
     var correctAnswers = 0
     private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService!
    private var alert = ResultAlertPresenter()
    
    init(viewController: MovieQuizViewController) {
          self.viewController = viewController
        statisticService = StatisticServiceImplementation()
          questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
          questionFactory?.loadData()
          viewController.showLoadingIndicator()
      }
    
    func didLoadDataFromServer() {
           viewController?.hideLoadingIndicator()
           questionFactory?.requestNextQuestion()
       }
       
       func didFailToLoadData(with error: Error) {
           let message = error.localizedDescription
           viewController?.showNetworkError(message: message)
       }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.question,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonTapped(_ sender: UIButton) {
        didAnswer(isYes: true)
    }
    
    func noButtonTapped(_ sender: UIButton) {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
        viewController?.show(quiz: viewModel)
    }
    
     func showNextQuestionResults() {
        if self.isLastQuestion() {
            guard let statisticService else { return }
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            guard let viewController else { return }
           alert.showAlert(
                in: viewController, with: AlertModel(
                    title: "Этот раунд окончен!",
                    message: """
                                                                Ваш результат: \(correctAnswers) из \(self.questionsAmount)
                                                                Количество сыгранных квизов: \(statisticService.gamesCount)
                                                                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                                                                Средняя точность: \("\(String(format: "%.2f", statisticService.totalAccuracy))%")
                                                                """,
                    buttonText: "Сыграть ещё раз", completion: { [weak self] _ in
                        self?.reset()
                    }))
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
     func reset() {
        self.resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}
