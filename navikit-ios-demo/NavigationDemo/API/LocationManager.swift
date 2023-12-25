//
//  LocationManager.swift
//  NavigationDemoApp
//

import Combine
import YandexMapsMobile

protocol LocationManager: YMKGuidanceListener {
    // MARK: - Public properties

    var location: CurrentValueSubject<YMKLocation?, Never> { get }

    // MARK: - Public methods

    func addGuidanceListener()
    func removeGuidanceListener()
}
