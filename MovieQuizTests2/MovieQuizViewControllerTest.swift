import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
    func setup() {
    }
    
    func showAnswerResult(isCorrect: Bool) {
    }
    
    func showLoadingIndicator() {
    }
    
    func hideLoadingIndicator() {
    }
    
    func showNetworkError(message: String) {
    }
    
    func show(quiz step: QuizStepViewModel) {
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock) // почему то вызывает ошибку несоответствия типа, код взят из учебника практикума
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
