//
//  NavigationStyleManagerImpl.swift
//

import YandexMapsMobile
import YMKStylingAutomotiveNavigation
import YMKStylingRoadEvents

final class NavigationStyleManagerImpl: NSObject, NavigationStyleManager {
    var trafficLightsVisibility = true

    var roadEventsOnRouteVisibility = true

    var balloonsVisibility = true

    var predictedVisibility = true

    var currentJamsMode: JamsMode = .enabledForCurrentRoute

    func routeViewStyleProvider() -> YMKNavigationRouteViewStyleProvider {
        internalRouteViewStyleProvider
    }

    func balloonImageProvider() -> YMKNavigationBalloonImageProvider {
        carNavigationStyleProvider.balloonImageProvider()
    }

    func requestPointStyleProvider() -> YMKNavigationRequestPointStyleProvider {
        carNavigationStyleProvider.requestPointStyleProvider()
    }

    func userPlacemarkStyleProvider() -> YMKNavigationUserPlacemarkStyleProvider {
        carNavigationStyleProvider.userPlacemarkStyleProvider()
    }

    func routePinsStyleProvider() -> YMKNavigationRoutePinsStyleProvider {
        carNavigationStyleProvider.routePinsStyleProvider()
    }

    // MARK: - Private properties

    private let carNavigationStyleProvider = YMKAutomotiveNavigationStyleProvider()

    private lazy var internalRouteViewStyleProvider = RouteViewStyleProvider(
        carNavigationStyleProvider: carNavigationStyleProvider,
        styleManager: self
    )
}
