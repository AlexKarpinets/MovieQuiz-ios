import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    //    private var questions: [QuizQuestion] = [
    //        QuizQuestion(
    //            image: "The Godfather",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Dark Knight",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Kill Bill",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Avengers",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Deadpool",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Green Knight",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Old",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "The Ice Age Adventures of Buck Wild",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "Tesla",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "Vivarium",
    //            correctAnswer: false)
    //    ]
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                    
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let correctAnswer = rating > 7
            let question = QuizQuestion(
                image: imageData,
                correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}
