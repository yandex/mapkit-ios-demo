//
//  MapViewController.swift
//  MapRouting
//
//  Created by Daniil Pustotin on 28.08.2023.
//

import UIKit
import YandexMapsMobile

class MapViewController: UIViewController {
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = YMKMapView(frame: view.frame)
        view.addSubview(mapView)
        map = mapView.mapWindow.map

        map.addInputListener(with: mapInputListener)

        routingViewModel.placemarksCollection = map.mapObjects.add()
        routingViewModel.routesCollection = map.mapObjects.add()

        move()

        setupSubviews()

        Const.defaultPoints
            .forEach { routingViewModel.addRoutePoint($0) }
    }

    // MARK: - Private methods

    private func move(to cameraPosition: YMKCameraPosition = Const.startPosition) {
        map.move(with: cameraPosition, animation: YMKAnimation(type: .smooth, duration: 1.0))
    }

    private func setupSubviews() {
        view.addSubview(resetRoutePointsButton)
        resetRoutePointsButton.translatesAutoresizingMaskIntoConstraints = false

        resetRoutePointsButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        resetRoutePointsButton.backgroundColor = Palette.background
        resetRoutePointsButton.layer.cornerRadius = Layout.buttonCornerRadius

        resetRoutePointsButton.addTarget(self, action: #selector(handleResetRoutePointsButtonTap), for: .touchUpInside)

        [
            resetRoutePointsButton.heightAnchor.constraint(equalToConstant: Layout.buttonSize),
            resetRoutePointsButton.widthAnchor.constraint(equalToConstant: Layout.buttonSize),
            resetRoutePointsButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.buttonMargin
            ),
            resetRoutePointsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.buttonMargin)
        ]
        .forEach { $0.isActive = true }
    }

    @objc
    private func handleResetRoutePointsButtonTap() {
        routingViewModel.resetRoutePoints()
    }

    // MARK: - Private properties

    private var mapView: YMKMapView!
    private var map: YMKMap!

    private lazy var routingViewModel = RoutingViewModel(controller: self)
    private lazy var mapInputListener: YMKMapInputListener = MapInputListener(routingViewModel: routingViewModel)

    private let resetRoutePointsButton = UIButton()

    // MARK: - Private nesting

    private enum Const {
        static let startPoint = YMKPoint(latitude: 59.941282, longitude: 30.308046)
        static let startPosition = YMKCameraPosition(target: startPoint, zoom: 13.0, azimuth: .zero, tilt: .zero)

        static let defaultPoints: [YMKPoint] = [
            YMKPoint(latitude: 59.929576, longitude: 30.291737),
            YMKPoint(latitude: 59.954093, longitude: 30.305770)
        ]
    }

    private enum Layout {
        static let buttonSize: CGFloat = 50.0
        static let buttonMargin: CGFloat = 50.0
        static let buttonCornerRadius: CGFloat = 8.0
    }
}
