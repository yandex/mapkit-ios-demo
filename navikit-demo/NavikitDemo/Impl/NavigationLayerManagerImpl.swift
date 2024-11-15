//
//  NavigationLayerManagerImpl.swift
//

import YandexMapsMobile

final class NavigationLayerManagerImpl: NSObject, NavigationLayerManager, YMKRouteViewListener {
    // MARK: - Public properties

    var selectedRoute: YMKDrivingRoute? {
        navigationLayer.selectedRoute()?.route
    }

    // MARK: - Constructor

    init(navigationLayer: YMKNavigationLayer, mapViewStateManager: MapViewStateManager) {
        self.navigationLayer = navigationLayer
        self.mapViewStateManager = mapViewStateManager
    }

    // MARK: - Public methods

    func setup() {
        navigationLayer.addRouteViewListener(with: self)
    }

    func onRouteViewTap(withRoute route: YMKRouteView) {
        switch navigationLayer.mode {
        case .routeSelection:
            navigationLayer.selectRoute(withRoute: route)

        case .guidance:
            navigationLayer.navigation.guidance.switchToRoute(with: route.route)
        @unknown default:
            print("Invalid navigation layer mode - \(navigationLayer.mode)")
        }
    }

    func onRouteViewsChanged() {
        guard selectedRoute == nil,
              let route = navigationLayer.routes.first else {
            return
        }

        mapViewStateManager.set(state: .routeVariants)

        navigationLayer.selectRoute(withRoute: route)
    }

    // MARK: - Private properties

    private let navigationLayer: YMKNavigationLayer
    private let mapViewStateManager: MapViewStateManager
}
