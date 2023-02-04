//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Karpinets Alexander on 31.01.2023.
//

import UIKit

class AlertPresenter {
    func showAlert(in vc: UIViewController, with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion)
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
