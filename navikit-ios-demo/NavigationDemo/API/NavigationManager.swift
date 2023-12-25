//
//  NavigationManager.swift
//  NavigationDemoApp
//

import Combine
import YandexMapsMobile

protocol NavigationManager {
    // MARK: - Public properties

    var status: CurrentValueSubject<GuidanceStatus, Never> { get }
    var routeFinished: PassthroughSubject<Void, Never> { get }
    var roadName: CurrentValueSubject<String, Never> { get }
    var roadFlags: CurrentValueSubject<String, Never> { get }
    var upcomingManeuvers: CurrentValueSubject<[YMKNavigationUpcomingManoeuvre], Never> { get }
    var upcomingLaneSigns: CurrentValueSubject<[YMKNavigationUpcomingLaneSign], Never> { get }
    var currentRoute: CurrentValueSubject<YMKDrivingRoute?, Never> { get }
    var speedLimit: YMKLocalizedValue? { get }
    var speedLimitStatus: YMKSpeedLimitStatus { get }

    // MARK: - Public methods

    func serializeNavigation()
    func requestRoutes(points: [YMKRequestPoint])
    func startGuidance(route: YMKDrivingRoute)
    func stopGuidance()
    func resume()
    func suspend()
    func start()
}
