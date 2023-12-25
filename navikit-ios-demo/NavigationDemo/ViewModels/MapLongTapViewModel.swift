//
//  MapLongTapViewModel.swift
//  NavigationDemo
//

import YandexMapsMobile

final class MapLongTapViewModel: NSObject, YMKMapInputListener {
    // MARK: - Constructor

    init(
        map: YMKMap,
        routingManager: RoutingManager,
        alertPresenter: AlertPresenter,
        mapViewStateManager: MapViewStateManager
    ) {
        self.map = map
        self.routingManager = routingManager
        self.alertPresenter = alertPresenter
        self.mapViewStateManager = mapViewStateManager
    }

    // MARK: - Public methods

    func setup() {
        map.addInputListener(with: self)
    }

    func onMapTap(with map: YMKMap, point: YMKPoint) {}

    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        switch mapViewStateManager.viewState.value {
        case .map:
            presentDestinationPointAlert(with: point)

        case .routeVariants:
            presentAddViaOrWaypointAlert(with: point)

        case .guidance:
            break
        }
    }

    // MARK: - Private methods

    private func presentDestinationPointAlert(with point: YMKPoint) {
        let alert = AlertFactory.makeWithOkAndCancel(
            with: "Build route to this point",
            message: "Route to point \(point.humanReadableDescription)"
        ) { [weak self] in
            self?.routingManager.addRoutePoint(point, type: .waypoint)
        }
        alertPresenter.present(alert: alert)
    }

    private func presentAddViaOrWaypointAlert(with point: YMKPoint) {
        let alert = AlertFactory.makeWithTwoVariants(
            with: "Add point to the route",
            message: "Go via or to the point \(point.humanReadableDescription)",
            variantOne: "Go via",
            variantTwo: "Go to",
            onVariantOne: { [weak self] in
                self?.routingManager.addRoutePoint(point, type: .viapoint)
            },
            onVariantTwo: { [weak self] in
                self?.routingManager.addRoutePoint(point, type: .waypoint)
            }
        )
        alertPresenter.present(alert: alert)
    }

    // MARK: - Private properties

    private let map: YMKMap
    private let routingManager: RoutingManager
    private let alertPresenter: AlertPresenter
    private let mapViewStateManager: MapViewStateManager
}
