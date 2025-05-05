//
//  MapCameraListener.swift
//  MapSearch
//

import YandexMapsMobile

class OfflineMapRegionListUpdatesListener: NSObject, YMKOfflineMapRegionListUpdatesListener {

    // MARK: - Constructor

    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
    }

    // MARK: - Public methods

    func onListUpdated() {
        searchViewModel.regionListState = .success
    }

    // MARK: - Private properties

    private let searchViewModel: SearchViewModel
}
