//
//  RouteViewStyleProvider.swift
//

import YandexMapsMobile
import YMKStylingAutomotiveNavigation
import YMKStylingRoadEvents

final class RouteViewStyleProvider: NSObject, YMKNavigationRouteViewStyleProvider {
    // MARK: - Constructor

    init(carNavigationStyleProvider: YMKAutomotiveNavigationStyleProvider, styleManager: NavigationStyleManager) {
        self.carNavigationStyleProvider = carNavigationStyleProvider
        self.styleManager = styleManager
    }

    // MARK: - Public methods

    func provideJamStyle(
        with flags: YMKDrivingFlags,
        isSelected: Bool,
        isNightMode: Bool,
        navigationLayerMode: YMKNavigationLayerMode,
        jamStyle: YMKNavigationJamStyle
    ) {
        carNavigationStyleProvider
            .routeViewStyleProvider()
            .provideJamStyle(
                with: flags,
                isSelected: isSelected,
                isNightMode: isNightMode,
                navigationLayerMode: navigationLayerMode,
                jamStyle: jamStyle
            )
    }

    func providePolylineStyle(
        with flags: YMKDrivingFlags,
        isSelected: Bool,
        isNightMode: Bool,
        navigationLayerMode: YMKNavigationLayerMode,
        polylineStyle: YMKPolylineStyle
    ) {
        carNavigationStyleProvider
            .routeViewStyleProvider()
            .providePolylineStyle(
                with: flags,
                isSelected: isSelected,
                isNightMode: isNightMode,
                navigationLayerMode: navigationLayerMode,
                polylineStyle: polylineStyle
            )
    }

    func provideManoeuvreStyle(
        with flags: YMKDrivingFlags,
        isSelected: Bool,
        isNightMode: Bool,
        navigationLayerMode: YMKNavigationLayerMode,
        arrowStyle: YMKArrowStyle
    ) {
        carNavigationStyleProvider
            .routeViewStyleProvider()
            .provideManoeuvreStyle(
                with: flags,
                isSelected: isSelected,
                isNightMode: isNightMode,
                navigationLayerMode: navigationLayerMode,
                arrowStyle: arrowStyle
            )
    }

    func provideRouteStyle(
        with flags: YMKDrivingFlags,
        isSelected: Bool,
        isNightMode: Bool,
        navigationLayerMode: YMKNavigationLayerMode,
        routeStyle: YMKNavigationRouteStyle
    ) {
        carNavigationStyleProvider
            .routeViewStyleProvider()
            .provideRouteStyle(
                with: flags,
                isSelected: isSelected,
                isNightMode: isNightMode,
                navigationLayerMode: navigationLayerMode,
                routeStyle: routeStyle
            )

        let showJams = {
            switch styleManager.currentJamsMode {
            case .disabled:
                return false

            case .enabled:
                return true

            case .enabledForCurrentRoute:
                return isSelected
            }
        }()

        routeStyle.setShowJamsWithShowJams(showJams)

        if !flags.predicted {
            routeStyle.setShowRouteWithShowRoute(true)
            routeStyle.setShowTrafficLightsWithShowTrafficLights(styleManager.trafficLightsVisibility && isSelected)
            routeStyle.setShowRoadEventsWithShowRoadEvents(styleManager.roadEventsOnRouteVisibility && isSelected)
            routeStyle.setShowBalloonsWithShowBalloons(styleManager.balloonsVisibility)
            routeStyle.setShowManoeuvresWithShowManoeuvres(isSelected)
        } else {
            routeStyle.setShowRouteWithShowRoute(styleManager.predictedVisibility)
            routeStyle.setShowTrafficLightsWithShowTrafficLights(false)
            routeStyle.setShowRoadEventsWithShowRoadEvents(styleManager.roadEventsOnRouteVisibility)
            routeStyle.setShowBalloonsWithShowBalloons(false)
            routeStyle.setShowManoeuvresWithShowManoeuvres(false)
        }
    }

    // MARK: - Private propeties

    private let carNavigationStyleProvider: YMKAutomotiveNavigationStyleProvider
    private let styleManager: NavigationStyleManager
}
