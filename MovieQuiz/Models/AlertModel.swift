//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Karpinets Alexander on 31.01.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> ())?
}
