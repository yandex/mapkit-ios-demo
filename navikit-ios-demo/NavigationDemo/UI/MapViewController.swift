//
//  MapViewController.swift
//  NavigationDemo
//

import UIKit
import YandexMapsMobile

class MapViewController: UIViewController {
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = YMKMapView(frame: view.frame)

        viewModel.setup(with: mapView.mapWindow, controller: self)

        view.addSubview(mapView)

        setup()

        setupSubviews()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            viewModel.updateColorScheme()
        }
    }

    // MARK: - Private methods

    private func setup() {
        viewModel.setup()
        viewModel.setupStateSubscription(onStateChanged: setupSubviews)
    }

    // MARK: - Private properties

    private var mapView: YMKMapView!
    private let viewModel = MapViewModel()

    // MARK: - Layout

    private var zoomButtonsContainer = UIStackView()
    private var bannerView: UIView?
    private var upcomingManeuverView: UpcomingManeuverView?
}

private extension MapViewController {
    func setupSubviews() {
        zoomButtonsContainer.removeFromSuperview()
        zoomButtonsContainer = UIStackView()

        bannerView?.removeFromSuperview()
        bannerView = nil

        upcomingManeuverView?.removeFromSuperview()
        upcomingManeuverView = nil

        let state = viewModel.mapViewStateManager.viewState.value

        let hasFocusOnRouteButton = state == .guidance

        view.addSubview(zoomButtonsContainer)
        zoomButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        zoomButtonsContainer.axis = .vertical
        zoomButtonsContainer.spacing = 2.0 * Layout.buttonMarging

        let settingsButton = UIButton()
        let zoomInButton = UIButton()
        let zoomOutButton = UIButton()
        let findMeButton = UIButton()
        let focusOnRouteButton = UIButton()

        var buttons = [
            settingsButton,
            zoomInButton,
            zoomOutButton,
            findMeButton
        ]

        if hasFocusOnRouteButton {
            buttons.append(focusOnRouteButton)
        }

        buttons
            .forEach {
                zoomButtonsContainer.addArrangedSubview($0)

                $0.heightAnchor.constraint(equalToConstant: Layout.buttonSide).isActive = true
                $0.widthAnchor.constraint(equalToConstant: Layout.buttonSide).isActive = true
                $0.backgroundColor = Palette.background
                $0.layer.cornerRadius = Layout.cornerRadius
            }

        zoomButtonsContainer.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -Layout.buttonMarging
        ).isActive = true
        zoomButtonsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        settingsButton.addTarget(self, action: #selector(handleSettingsButtonTap), for: .touchUpInside)
        zoomInButton.addTarget(self, action: #selector(handleZoomInButtonTap), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(handleZoomOutButtonTap), for: .touchUpInside)
        findMeButton.addTarget(self, action: #selector(handleFindMeButtonTap), for: .touchUpInside)
        focusOnRouteButton.addTarget(self, action: #selector(handleFocusOnRouteButtonTap), for: .touchUpInside)

        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        zoomInButton.setImage(UIImage(systemName: "plus"), for: .normal)
        zoomOutButton.setImage(UIImage(systemName: "minus"), for: .normal)
        findMeButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        focusOnRouteButton.setImage(
            UIImage(systemName: "road.lanes.curved.left"),
            for: .normal
        )

        switch state {
        case .map:
            break

        case .routeVariants:
            bannerView = RoutesVariantsBannerView(
                routingManager: viewModel.routingManager,
                mapViewStateManager: viewModel.mapViewStateManager
            )

            if let bannerView {
                view.addSubview(bannerView)

                [
                    bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ]
                .forEach { $0.isActive = true }
            }

        case .guidance:
            let viewModel = GuidanceViewModel(
                navigationManager: viewModel.navigationManager,
                locationManager: viewModel.locationManager,
                guidance: viewModel.guidance,
                routingManager: viewModel.routingManager,
                mapViewStateManager: viewModel.mapViewStateManager,
                cameraManager: viewModel.cameraManager,
                navigationLayerManager: viewModel.navigationLayerManager,
                simulationManager: viewModel.simulationManager,
                settingsRepository: viewModel.settingsRepository
            )
            bannerView = GuidanceBannerView(viewModel: viewModel)

            upcomingManeuverView = UpcomingManeuverView(viewModel: viewModel)
        }

        if let bannerView {
            view.addSubview(bannerView)

            [
                bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
            .forEach { $0.isActive = true }
        }

        if let upcomingManeuverView {
            view.addSubview(upcomingManeuverView)

            [
                upcomingManeuverView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                upcomingManeuverView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor,
                    constant: Layout.buttonMarging
                )
            ]
            .forEach { $0.isActive = true }
        }
    }

    @objc
    private func handleSettingsButtonTap() {
        navigationController?.pushViewController(
            SettingsScreen.settings.createController(with: viewModel.settingsRepository),
            animated: true
        )
    }

    @objc
    private func handleZoomInButtonTap() {
        viewModel.cameraManager.changeZoom(.plus)
    }

    @objc
    private func handleZoomOutButtonTap() {
        viewModel.cameraManager.changeZoom(.minus)
    }

    @objc
    private func handleFindMeButtonTap() {
        if viewModel.mapViewStateManager.viewState.value == .guidance {
            viewModel.cameraManager.cameraMode = .following
        } else {
            viewModel.cameraManager.moveCameraToUserLocation()
        }
    }

    @objc
    private func handleFocusOnRouteButtonTap() {
        if viewModel.mapViewStateManager.viewState.value == .guidance {
            viewModel.cameraManager.cameraMode = .overview
        }
    }
}
