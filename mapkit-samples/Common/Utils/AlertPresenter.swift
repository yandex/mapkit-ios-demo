//
//  AlertPresenter.swift
//  MapkitSamples
//

import UIKit

enum AlertPresenter {
    static func present(from controller: UIViewController?, with text: String, message: String? = nil) {
        guard let controller = controller else {
            return
        }
        let alertVC = UIAlertController(title: text, message: message, preferredStyle: .actionSheet)
        controller.present(alertVC, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alertVC.dismiss(animated: true)
        }
    }
}
