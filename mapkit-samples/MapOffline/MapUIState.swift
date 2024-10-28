//
//  MapUIState.swift
//  MapSearch
//

import YandexMapsMobile

struct MapUIState {
    let query: String
    let searchState: SearchState
    let regionListState: RegionListState

    init(query: String = String(), searchState: SearchState, regionListState: RegionListState) {
        self.query = query
        self.searchState = searchState
        self.regionListState = regionListState
    }
}

struct SearchResponseItem {
    let point: YMKPoint
    let geoObject: YMKGeoObject?
}

enum SearchState {
    case idle
    case loading
    case error
    case success(items: [SearchResponseItem], zoomToItems: Bool, itemsBoundingBox: YMKBoundingBox)
}

enum RegionListState {
    case idle
    case success
}
