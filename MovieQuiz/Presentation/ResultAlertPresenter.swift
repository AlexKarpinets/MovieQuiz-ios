import UIKit

final class ResultAlertPresenter {
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
        alert.view.accessibilityIdentifier = "Alert"
    }
}

