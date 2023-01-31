//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Karpinets Alexander on 30.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
