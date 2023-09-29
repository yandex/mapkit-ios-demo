//
//  PlacemarkMapObjectTapListener.swift
//  MapObjects
//
//  Created by Daniil Pustotin on 03.08.2023.
//

import YandexMapsMobile

final class PlacemarkMapObjectTapListener: NSObject, YMKMapObjectTapListener {
    // MARK: - Constructor

    init(controller: UIViewController, alertTitle: String) {
        self.controller = controller
        self.alertTitle = alertTitle
    }

    // MARK: - Public methods

    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        AlertPresenter.present(from: controller, with: alertTitle)
        return true
    }

    // MARK: - Private properties

    private weak var controller: UIViewController?
    private let alertTitle: String
}
