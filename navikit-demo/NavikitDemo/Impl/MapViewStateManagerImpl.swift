//
//  MapViewStateManagerImpl.swift
//

import Combine

final class MapViewStateManagerImpl: MapViewStateManager {
    // MARK: - Public properties

    private(set) var viewState = CurrentValueSubject<MapViewState, Never>(.map)

    // MARK: - Constructor

    init(navigationManager: NavigationManager, cameraManager: CameraManager) {
        self.navigationManager = navigationManager
        self.cameraManager = cameraManager
    }

    // MARK: - Public methods

    func set(state viewState: MapViewState) {
        switch viewState {
        case .map:
            navigationManager.stopGuidance()
            cameraManager.moveCameraToUserLocation()
            cameraManager.cameraMode = .free

        case .routeVariants:
            break

        case .guidance:
            break
        }
        self.viewState.send(viewState)
    }

    // MARK: - Private properties

    private let navigationManager: NavigationManager
    private var cameraManager: CameraManager
}
