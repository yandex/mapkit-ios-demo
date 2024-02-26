//
//  AlertPresenter.swift
//

import UIKit

class AlertPresenter {
    // MARK: - Constructor

    init(controller: UIViewController?) {
        self.controller = controller
    }

    // MARK: - Public properties

    func present(alert: UIAlertController, selfDismissing: Bool = false) {
        controller?.present(alert, animated: true)
        if selfDismissing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true)
            }
        }
    }

    // MARK: - Private properties

    private weak var controller: UIViewController?
}

enum AlertFactory {
    static func make(
        with title: String,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .actionSheet,
        actions: [UIAlertAction] = []
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { action in
            alert.addAction(action)
        }
        return alert
    }

    static func makeWithOkAndCancel(
        with title: String,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .actionSheet,
        onOk okHandler: @escaping () -> Void
    ) -> UIAlertController {
        let actions = [
            UIAlertAction(title: "Ok", style: .default) { _ in
                okHandler()
            },
            UIAlertAction(title: "Cancel", style: .cancel)
        ]
        return make(with: title, message: message, preferredStyle: preferredStyle, actions: actions)
    }

    static func makeWithTextField(
        with title: String,
        message: String? = nil,
        onSet setHandler: @escaping (Float) -> Void
    ) -> UIAlertController {
        let alert = make(with: title, message: message, preferredStyle: .alert)
        alert.addTextField {
            $0.keyboardType = .numberPad
        }
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default) { _ in
                setHandler(Float(alert.textFields!.first!.text!)!)
            }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        return alert
    }

    static func makeWithTwoVariants(
        with title: String,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .actionSheet,
        variantOne: String,
        variantTwo: String,
        onVariantOne variantOneHandler: @escaping () -> Void,
        onVariantTwo variantTwoHandler: @escaping () -> Void
    ) -> UIAlertController {
        let actions = [
            UIAlertAction(title: variantOne, style: .default) { _ in variantOneHandler() },
            UIAlertAction(title: variantTwo, style: .default) { _ in variantTwoHandler() },
            UIAlertAction(title: "Cancel", style: .cancel)
        ]
        return make(with: title, message: message, preferredStyle: preferredStyle, actions: actions)
    }
}
