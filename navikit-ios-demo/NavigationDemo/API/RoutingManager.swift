//
//  RoutingManager.swift
//  NavigationDemo
//

import YandexMapsMobile

protocol RoutingManager: AnyObject {
    // MARK: - Public methods

    func addRoutePoint(_ point: YMKPoint, type: YMKRequestPointType)
}
