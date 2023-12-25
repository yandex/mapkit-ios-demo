//
//  NavigationLayerManager.swift
//  NavigationDemo
//

import YandexMapsMobile

protocol NavigationLayerManager {
    // MARK: - Public properties

    var selectedRoute: YMKDrivingRoute? { get }

    // MARK: - Public methods

    func setup()
}
