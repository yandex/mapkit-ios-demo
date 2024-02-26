//
//  MapViewStateManager.swift
//

import Combine

protocol MapViewStateManager {
    // MARK: - Public properties

    var viewState: CurrentValueSubject<MapViewState, Never> { get }

    // MARK: - Public methods

    func set(state: MapViewState)
}
