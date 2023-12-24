//
//  MapCameraListener.swift
//  MapSearch
//

import YandexMapsMobile

class MapCameraListener: NSObject, YMKMapCameraListener {
    // MARK: - Constructor

    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
    }

    // MARK: - Public methods

    func onCameraPositionChanged(
        with map: YMKMap,
        cameraPosition: YMKCameraPosition,
        cameraUpdateReason: YMKCameraUpdateReason,
        finished: Bool
    ) {
        if cameraUpdateReason == .gestures {
            searchViewModel.setVisibleRegion(with: map.visibleRegion)
        }
    }

    // MARK: - Private properties

    private let searchViewModel: SearchViewModel
}
