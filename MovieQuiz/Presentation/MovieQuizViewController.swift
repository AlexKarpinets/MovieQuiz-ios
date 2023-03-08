import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private property
    private var correctAnswers = 0
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService?
    private var alert = ResultAlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewController = self
    }
    
    //MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }
    
    // MARK: Func
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - Private func
     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {return}
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.showNextQuesionResults()
        }
    }
    
    private func showNextQuesionResults() {
        if presenter.isLastQuestion() {
            guard let statisticService else { return }
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            alert.showAlert(
                in: self, with: AlertModel(
                    title: "Этот раунд окончен!",
                    message: """
                                                                Ваш результат: \(correctAnswers) из \(presenter.questionsAmount)
                                                                Количество сыгранных квизов: \(statisticService.gamesCount)
                                                                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                                                                Средняя точность: \("\(String(format: "%.2f", statisticService.totalAccuracy))%")
                                                                """,
                    buttonText: "Сыграть ещё раз", completion: { [weak self] _ in
                        self?.reset()
                    }))
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func reset() {
        presenter.resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func setup() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        alert.showAlert(in: self, with: AlertModel(
            title: "",
            message: "Ошибка",
            buttonText: "Попробовать еще раз",
            completion: { [weak self] _ in
                guard let self else { return }
                self.reset()
            }))
    }
    
    // MARK: - IBActions
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        sender.isEnabled.toggle()
        presenter.noButtonTapped(UIButton())
    }
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        sender.isEnabled.toggle()
        presenter.yesButtonTapped(UIButton())
    }
}
