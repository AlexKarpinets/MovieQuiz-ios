import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private property
    private var presenter: MovieQuizPresenter!
    private var alert = ResultAlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - Func
    
    func setup() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            presenter.correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {return}
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.presenter.proceedToNextQuestionOrResults()
        }
    }
    
    //    func highlightImageBorder(isCorrectAnswer: Bool) {
    //        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    //    }
    
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        alert.showAlert(in: self, with: AlertModel(
            title: "",
            message: "Ошибка",
            buttonText: "Попробовать еще раз",
            completion: { [weak self] _ in
                guard let self else { return }
                self.presenter.reset()
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
