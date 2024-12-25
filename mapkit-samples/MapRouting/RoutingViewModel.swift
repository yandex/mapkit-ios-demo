//
//  RoutingViewModel.swift
//  MapRouting
//

import UIKit
import YandexMapsMobile

final class RoutingViewModel {
    // MARK: - Public properties

    private(set) var routePoints: [YMKPoint] = [] {
        didSet {
            onRoutingPointsUpdated()
        }
    }
    private(set) var routes: [YMKDrivingRoute] = [] {
        didSet {
            onRoutesUpdated()
        }
    }

    var placemarksCollection: YMKMapObjectCollection!
    var routesCollection: YMKMapObjectCollection!

    // MARK: - Constructor

    init(controller: UIViewController) {
        self.controller = controller
    }

    // MARK: - Public methods

    func addRoutePoint(_ point: YMKPoint) {
        routePoints.append(point)
    }

    func resetRoutePoints() {
        routePoints.removeAll()
    }

    // MARK: - Private methods

    private func onRoutingPointsUpdated() {
        guard let image = UIImage(systemName: "circle.fill") else { return }
        
        placemarksCollection.clear()

        if routePoints.isEmpty {
            drivingSession?.cancel()
            routes = []
            return
        }

        let iconStyle = YMKIconStyle()
        iconStyle.scale = 0.5
        iconStyle.zIndex = 20.0

        routePoints.forEach {
            let placemark = placemarksCollection.addPlacemark()
            placemark.geometry = $0
            placemark.setIconWith(image, style: iconStyle)
        }

        if routePoints.count < 2 {
            return
        }

        let requestPoints =
            [
                YMKRequestPoint(
                    point: routePoints.first!,
                    type: .waypoint,
                    pointContext: nil,
                    drivingArrivalPointId: nil,
                    indoorLevelId: nil
                )
            ] +
            routePoints[1..<routePoints.count - 1]
            .map { YMKRequestPoint(point: $0, type: .viapoint, pointContext: nil, drivingArrivalPointId: nil, indoorLevelId: nil) } +
            [
                YMKRequestPoint(
                    point: routePoints.last!,
                    type: .waypoint,
                    pointContext: nil,
                    drivingArrivalPointId: nil,
                    indoorLevelId: nil
                )
            ]

        let drivingOptions = YMKDrivingOptions()
        let vehicleOptions = YMKDrivingVehicleOptions()

        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: drivingOptions,
            vehicleOptions: vehicleOptions,
            routeHandler: drivingRouteHandler
        )
    }

    private func onRoutesUpdated() {
        routesCollection.clear()
        if routes.isEmpty {
            return
        }

        routes.enumerated()
            .forEach { pair in
                let routePolyline = routesCollection.addPolyline(with: pair.element.geometry)
                if pair.offset == 0 {
                    routePolyline.styleMainRoute()
                } else {
                    routePolyline.styleAlternativeRoute()
                }
            }
    }

    private func drivingRouteHandler(drivingRoutes: [YMKDrivingRoute]?, error: Error?) {
        if let error = error {
            switch error {
            case _ as YRTNetworkError:
                AlertPresenter.present(from: controller, with: "Routes request error due network issues")

            default:
                AlertPresenter.present(from: controller, with: "Routes request unknown error")
            }
            return
        }

        guard let drivingRoutes = drivingRoutes else {
            return
        }

        routes = drivingRoutes
    }

    // MARK: - Private properties

    private lazy var drivingRouter: YMKDrivingRouter = YMKDirectionsFactory.instance().createDrivingRouter(
        withType: .combined
    )
    private var drivingSession: YMKDrivingSession?

    private weak var controller: UIViewController?
}
