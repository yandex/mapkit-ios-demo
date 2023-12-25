//
//  GuidanceViewModel.swift
//  NavigationDemo
//

import Combine
import Foundation
import YandexMapsMobile

struct GuidanceViewState {
    // MARK: - Public nesting

    struct SpeedState {
        let current: Double?
        let limit: Double?
        let isLimitExceeded: Bool
    }

    // MARK: - Public properties

    let road: String
    let flags: String
    let timeLeft: String
    let distanceLeft: String
    let speedState: SpeedState
    let simulationSpeed: String
    let isSimulationPanelVisible: Bool
}

struct UpcomingManeuverViewState {
    // MARK: - Public properties

    let distance: String
    let action: NSNumber?
    let nextStreet: String?
    let laneSign: YMKDrivingLaneSign?
}

final class GuidanceViewModel {
    // MARK: - Public properties

    let viewState = CurrentValueSubject<GuidanceViewState?, Never>(nil)
    let upcomingManeuverViewState = CurrentValueSubject<UpcomingManeuverViewState?, Never>(nil)

    // MARK: - Contructor

    init(
        navigationManager: NavigationManager,
        locationManager: LocationManager,
        guidance: YMKGuidance,
        routingManager: RoutingManager,
        mapViewStateManager: MapViewStateManager,
        cameraManager: CameraManager,
        navigationLayerManager: NavigationLayerManager,
        simulationManager: SimulationManager,
        settingsRepository: SettingsRepository
    ) {
        self.navigationManager = navigationManager
        self.locationManager = locationManager
        self.guidance = guidance
        self.routingManager = routingManager
        self.mapViewStateManager = mapViewStateManager
        self.cameraManager = cameraManager
        self.navigationLayerManager = navigationLayerManager
        self.simulationManager = simulationManager
        self.settingsRepository = settingsRepository
    }

    // MARK: - Public methods

    func startIfNotYet() {
        guard let route = navigationLayerManager.selectedRoute,
              navigationManager.status.value == .stopped else {
            return
        }

        navigationManager.startGuidance(route: route)

        cameraManager.cameraMode = .following
    }

    func cancel() {
        navigationManager.stopGuidance()
        mapViewStateManager.set(state: .map)
    }

    func setupViewStateUpdates() -> AnyCancellable {
        Publishers.CombineLatest(
            Publishers.CombineLatest4(
                navigationManager.roadName,
                navigationManager.roadFlags,
                locationManager.location,
                simulationManager.isSimulationActive
            )
            .eraseToAnyPublisher(),
            settingsRepository.simulationSpeed
        )
        .eraseToAnyPublisher()
        .map { [weak self] arg0, simulationSpeed in
            let (road, flags, location, isSimulationActive) = arg0

            guard let self else {
                return nil
            }
            let route = self.guidance.currentRoute
            let time = route?.timeWithTraffic.text ?? "undefined"
            let distance = route?.distanceLeft.text ?? "undefined"
            let roadName = !road.isEmpty ? road : "undefined"

            return GuidanceViewState(
                road: "Road: \(roadName)",
                flags: "Road flags: \(flags.isEmpty ? "None" : flags)",
                timeLeft: "Time left: \(time)",
                distanceLeft: "Distance left: \(distance)",
                speedState: self.speedState(at: location),
                simulationSpeed: YRTI18nManagerFactory.getI18nManagerInstance().localizeSpeed(
                    withSpeed: Double(simulationSpeed)
                ),
                isSimulationPanelVisible: isSimulationActive
            )
        }
        .assign(to: \.viewState.value, on: self)
    }

    func setupUpcomingManeuverUpdates() -> AnyCancellable {
        Publishers.CombineLatest4(
            navigationManager.upcomingManeuvers,
            navigationManager.upcomingLaneSigns,
            navigationManager.currentRoute,
            locationManager.location
        )
        .eraseToAnyPublisher()
        .map { maneuvers, laneSigns, currentRoute, _ in
            guard let currentRoute,
                  let nextManeuver = maneuvers.first,
                  let maneuverPosition = nextManeuver.position.positionOnRoute(withRouteId: currentRoute.routeId) else {
                return nil
            }

            let distanceToManeuver = Int(
                YMKPolylineUtils.distanceBetweenPolylinePositions(
                    with: currentRoute.geometry,
                    from: currentRoute.position,
                    to: maneuverPosition
                )
            ) / 10 * 10

            let nextLaneSign = laneSigns.first { laneSign in
                guard let position = laneSign.position.positionOnRoute(withRouteId: currentRoute.routeId),
                      maneuverPosition.segmentIndex == position.segmentIndex else {
                    return false
                }
                return true
            }?.laneSign

            return UpcomingManeuverViewState(
                distance: YRTI18nManagerFactory.getI18nManagerInstance().localizeDistance(
                    withDistance: distanceToManeuver
                ),
                action: nextManeuver.annotation.action,
                nextStreet: nextManeuver.annotation.toponym,
                laneSign: nextLaneSign
            )
        }
        .assign(to: \.upcomingManeuverViewState.value, on: self)
    }

    func setupGuidanceFinishedSubscription() -> AnyCancellable {
        Publishers.Merge(
            simulationManager.simulationFinished,
            navigationManager.routeFinished
        )
        .sink { [weak self] _ in
            self?.mapViewStateManager.set(state: .map)
        }
    }

    func changeSimulationSpeed(by amount: Float) {
        let newSpeed = settingsRepository.simulationSpeed.value + amount
        settingsRepository.simulationSpeed.send(newSpeed)
        simulationManager.setSpeed(with: Double(newSpeed))
    }

    // MARK: - Private methods

    private func speedState(at location: YMKLocation?) -> GuidanceViewState.SpeedState {
        GuidanceViewState.SpeedState(
            current: location?.speed?.doubleValue,
            limit: navigationManager.speedLimit?.value,
            isLimitExceeded: navigationManager.speedLimitStatus != .belowLimit
        )
    }

    // MARK: - Private properties

    private let navigationManager: NavigationManager
    private let locationManager: LocationManager
    private let guidance: YMKGuidance
    private let routingManager: RoutingManager
    private let mapViewStateManager: MapViewStateManager
    private var cameraManager: CameraManager
    private let navigationLayerManager: NavigationLayerManager
    private let simulationManager: SimulationManager
    private let settingsRepository: SettingsRepository
}
